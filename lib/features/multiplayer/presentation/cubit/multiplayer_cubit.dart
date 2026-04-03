import 'dart:async';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'multiplayer_state.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/multiplayer/data/models/network_message.dart';
import 'package:hidden_word/features/multiplayer/domain/services/multiplayer_service.dart';

class MultiplayerCubit extends Cubit<MultiplayerState> {
  final GameCubit gameCubit;
  final MultiplayerService multiplayerService;
  
  StreamSubscription<GameState>? _gameSubscription;
  final Map<WebSocketChannel, String> _connectedClients = {};
  final Set<String> _readyPlayers = {};
  final Map<String, String> _playerVotes = {};
  bool _votingRoundResolved = false;

  MultiplayerCubit({
    required this.gameCubit,
    required this.multiplayerService,
  }) : super(MultiplayerState(playerName: _generateRandomAgentName()));

  static String _generateRandomAgentName() {
    final names = ['SHADOW', 'ECHO', 'SILENT', 'SPECTER', 'GHOST', 'VIPER', 'NOVA', 'RAVEN', 'CIPHER', 'ORACLE', 'COBRA', 'PHANTOM', 'NEON', 'TITAN', 'ZENITH'];
    final suffixes = ['AGENT', 'OPERATOR', 'WALKER', 'BLADE', 'SOUL', 'MIND', 'ZERO', 'HUNTER', 'STRIKER', 'VANGUARD'];
    final rand = DateTime.now().millisecond;
    final name = names[rand % names.length];
    final suffix = suffixes[(rand ~/ names.length) % suffixes.length];
    final id = (rand % 900) + 100;
    return '$name $suffix $id';
  }

  void setPlayerName(String name) {
    if (name.trim().isEmpty) return;
    emit(state.copyWith(playerName: name.trim()));
  }

  void prepareNewSession() {
    _readyPlayers.clear();
    _playerVotes.clear();
    _votingRoundResolved = false;
  }

  // --- HOSTING ---
  Future<void> startHosting(String roomName) async {
    try {
      if (state.status == MultiplayerStatus.hosting) {
        await stopMultiplayer();
      }

      emit(state.copyWith(status: MultiplayerStatus.hosting, clearError: true));

      final result = await multiplayerService.startServer(
        roomName: roomName,
        onClientMessage: _handleClientMessage,
        onClientDisconnected: (client) {
          final name = _connectedClients[client];
          _connectedClients.remove(client);
          if (name != null) {
            _broadcastRosterUpdate();
          }
        },
      );

      _gameSubscription = gameCubit.stream.listen(_onGameStateForHostAndClients);

      emit(state.copyWith(
        status: MultiplayerStatus.hosting,
        hostIp: result['ip'],
        hostPort: result['port'],
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
    }
  }

  void _onGameStateForHostAndClients(GameState gameState) {
    if (state.status == MultiplayerStatus.hosting &&
        gameState.phase == GamePhase.reveal &&
        gameState.sessionActive) {
      _votingRoundResolved = false;
    }

    broadcastToClients(NetworkMessage(
      type: NetworkMessageType.phaseSync,
      payload: gameState.toJson(),
    ).encode());

    if (state.status != MultiplayerStatus.hosting) return;
    if (gameState.phase == GamePhase.voting &&
        gameState.timerSeconds == 0 &&
        !_votingRoundResolved) {
      _tallyVotesAndFinish();
    }
  }

  // --- DISCOVERY ---
  Future<void> searchHosts() async {
    try {
      emit(state.copyWith(
        status: MultiplayerStatus.searching,
        discoveredServices: const [],
        clearError: true,
      ));

      await multiplayerService.startDiscovery(
        onServicesUpdate: (services) {
          emit(state.copyWith(discoveredServices: services));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
    }
  }

  // --- CLIENT CONNECTION ---
  Future<void> connectToHost(BonsoirService service) async {
    try {
      emit(state.copyWith(status: MultiplayerStatus.connecting, clearError: true));

      final result = await multiplayerService.connectToHost(
        service: service,
        onMessage: _handleHostMessage,
        onDone: () => stopMultiplayer(),
      );

      multiplayerService.sendToHost(NetworkMessage(
        type: NetworkMessageType.action,
        payload: {'action': 'JOIN', 'playerName': state.playerName},
      ).encode());

      emit(state.copyWith(
        status: MultiplayerStatus.connected,
        hostIp: result['ip'],
        hostPort: result['port'],
      ));
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
    }
  }

  // --- MESSAGE HANDLING ---
  void _handleClientMessage(WebSocketChannel client, dynamic message) {
    if (message is String) {
      final networkMessage = NetworkMessage.decode(message);
      if (networkMessage.type == NetworkMessageType.action) {
        final action = networkMessage.payload['action'];
        final playerName = networkMessage.payload['playerName'] as String? ?? 'Unknown';

        if (action == 'JOIN') {
          _connectedClients[client] = playerName;
          _broadcastRosterUpdate();
        } else if (action == 'READY') {
          _addReadyPlayer(playerName);
        } else if (action == 'VOTE') {
          final votedPlayerName = networkMessage.payload['votedPlayerName'] as String?;
          if (votedPlayerName != null) {
            _playerVotes[playerName] = votedPlayerName;
            if (_allVotesIn()) {
              _tallyVotesAndFinish();
            }
          }
        }
      }
    }
  }

  void _addReadyPlayer(String playerName) {
    _readyPlayers.add(playerName);
    gameCubit.setPlayersReadyCount(_readyPlayers.length);
    if (_allPlayersReady()) {
      gameCubit.startDiscussion(isHost: true);
    }
  }

  bool _allPlayersReady() {
    final roster = gameCubit.state.connectedPlayers;
    if (roster.isEmpty) return false;
    return roster.length == _readyPlayers.length && roster.every(_readyPlayers.contains);
  }

  bool _allVotesIn() {
    final roster = gameCubit.state.connectedPlayers;
    if (roster.isEmpty) return false;
    return roster.every((name) => _playerVotes.containsKey(name));
  }

  void submitReady(String playerName) {
    if (state.status == MultiplayerStatus.hosting) {
      _addReadyPlayer(playerName);
    } else {
      multiplayerService.sendToHost(NetworkMessage(
        type: NetworkMessageType.action,
        payload: {'action': 'READY', 'playerName': playerName},
      ).encode());
    }
  }

  void submitVote(String voterName, String votedPlayerName) {
    if (state.status == MultiplayerStatus.hosting) {
      _playerVotes[voterName] = votedPlayerName;
      if (_allVotesIn()) {
        _tallyVotesAndFinish();
      }
    } else {
      multiplayerService.sendToHost(NetworkMessage(
        type: NetworkMessageType.action,
        payload: {
          'action': 'VOTE',
          'playerName': voterName,
          'votedPlayerName': votedPlayerName,
        },
      ).encode());
    }
  }

  void _broadcastRosterUpdate() {
    final clientNames = _connectedClients.values.toList();
    emit(state.copyWith(connectedPlayers: clientNames));
    
    final fullRoster = [state.playerName, ...clientNames];
    broadcastToClients(NetworkMessage(
      type: NetworkMessageType.action,
      payload: {'action': 'ROSTER_SYNC', 'connectedPlayers': fullRoster},
    ).encode());
  }

  void _tallyVotesAndFinish() {
    if (_votingRoundResolved) return;
    _votingRoundResolved = true;

    final Map<String, int> counts = {};
    for (final vote in _playerVotes.values) {
      counts[vote] = (counts[vote] ?? 0) + 1;
    }

    String? majorityName;
    int maxVotes = 0;
    counts.forEach((name, count) {
      if (count > maxVotes) {
        maxVotes = count;
        majorityName = name;
      }
    });

    final spies = gameCubit.state.spyPlayerNames;
    final spyCaught = majorityName != null && spies.contains(majorityName);
    gameCubit.startResults(spyCaught, majorityName);
  }

  void _handleHostMessage(dynamic message) {
    if (message is String) {
      final networkMessage = NetworkMessage.decode(message);
      if (networkMessage.type == NetworkMessageType.phaseSync) {
        final incomingState = GameState.fromJson(networkMessage.payload);
        gameCubit.syncState(incomingState);
      } else if (networkMessage.type == NetworkMessageType.action) {
        final action = networkMessage.payload['action'];
        if (action == 'ROSTER_SYNC') {
          final roster = List<String>.from(networkMessage.payload['connectedPlayers'] ?? []);
          emit(state.copyWith(connectedPlayers: roster));
        }
      }
    }
  }

  void broadcastToClients(String encodedMessage) {
    multiplayerService.broadcastToClients(_connectedClients.keys, encodedMessage);
  }

  Future<void> stopMultiplayer() async {
    final savedName = state.playerName;
    await _gameSubscription?.cancel();
    _connectedClients.clear();
    _readyPlayers.clear();
    _playerVotes.clear();
    _votingRoundResolved = false;
    await multiplayerService.dispose();
    emit(MultiplayerState(playerName: savedName));
  }

  @override
  Future<void> close() {
    stopMultiplayer();
    return super.close();
  }
}
