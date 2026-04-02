import 'dart:async';
import 'dart:io';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'multiplayer_state.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/multiplayer/data/models/network_message.dart';

class MultiplayerCubit extends Cubit<MultiplayerState> {
  final GameCubit gameCubit;
  StreamSubscription<GameState>? _gameSubscription;
  BonsoirService? _service;
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  HttpServer? _server;
  WebSocketChannel? _clientChannel;
  final Map<WebSocketChannel, String> _connectedClients = {};
  final Set<String> _readyPlayers = {};
  final Map<String, String> _playerVotes = {};
  bool _votingRoundResolved = false;
  final NetworkInfo _networkInfo = NetworkInfo();

  MultiplayerCubit({required this.gameCubit}) : super(const MultiplayerState());

  /// Clears per-round readiness/votes before host calls [GameCubit.init].
  void prepareNewSession() {
    _readyPlayers.clear();
    _playerVotes.clear();
    _votingRoundResolved = false;
  }

  /// IP shown to joiners + mDNS. When the phone is the hotspot AP, [NetworkInfo.getWifiIP]
  /// is often null/wrong because that API targets station (client) Wi‑Fi, not the soft‑AP.
  Future<String> _resolveAdvertisedHostIp() async {
    String? ip;
    try {
      ip = await _networkInfo
          .getWifiIP()
          .timeout(const Duration(seconds: 3), onTimeout: () => null);
    } catch (_) {}
    if (ip != null && ip.isNotEmpty) return ip;

    try {
      ip = await _networkInfo.getWifiGatewayIP();
      if (ip != null && ip.isNotEmpty) return ip;
    } catch (_) {}

    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );

    bool looksLikeAp(NetworkInterface i) {
      final n = i.name.toLowerCase();
      return n.contains('ap') ||
          n.contains('wlan') ||
          n.contains('softap') ||
          n.contains('p2p');
    }

    for (final iface in interfaces) {
      if (!looksLikeAp(iface)) continue;
      for (final a in iface.addresses) {
        if (!a.isLoopback && a.type == InternetAddressType.IPv4) {
          return a.address;
        }
      }
    }

    for (final iface in interfaces) {
      for (final a in iface.addresses) {
        if (a.address.startsWith('192.168.43.')) return a.address;
      }
    }

    for (final iface in interfaces) {
      for (final a in iface.addresses) {
        if (a.isLoopback) continue;
        if (a.type == InternetAddressType.IPv4) return a.address;
      }
    }

    throw Exception(
      'Could not determine local IP. On hotspot, ensure it is on and try again.',
    );
  }

  // --- HOSTING ---
  Future<void> startHosting(String playerName) async {
    try {
      emit(state.copyWith(status: MultiplayerStatus.hosting, playerName: playerName));

      final ip = await _resolveAdvertisedHostIp();

      final handler = webSocketHandler((webSocket, _) {
        webSocket.stream.listen((message) {
          _handleClientMessage(webSocket, message);
        }, onDone: () {
          final name = _connectedClients[webSocket];
          _connectedClients.remove(webSocket);
          if (name != null) {
            _broadcastRosterUpdate();
          }
        });
      });

      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 0);
      final port = _server!.port;

      _service = BonsoirService(
        name: "$playerName's Room",
        type: '_hiddenword._tcp',
        port: port,
        attributes: {'ip': ip},
      );

      _broadcast = BonsoirBroadcast(service: _service!);
      await _broadcast!.initialize();
      await _broadcast!.start();

      _gameSubscription = gameCubit.stream.listen(_onGameStateForHostAndClients);

      emit(state.copyWith(status: MultiplayerStatus.hosting, hostIp: ip, hostPort: port));
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
    }
  }

  void _onGameStateForHostAndClients(GameState gameState) {
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
      emit(state.copyWith(status: MultiplayerStatus.searching));
      _discovery = BonsoirDiscovery(type: '_hiddenword._tcp');
      await _discovery!.initialize();

      _discovery!.eventStream!.listen((event) {
        if (event is BonsoirDiscoveryServiceFoundEvent ||
            event is BonsoirDiscoveryServiceResolvedEvent) {
          final service = event.service;
          if (service != null && service.attributes['ip'] != null) {
            final services = List<BonsoirService>.from(state.discoveredServices)
              ..removeWhere((s) => s.name == service.name)
              ..add(service);
            emit(state.copyWith(discoveredServices: services));
          }
        } else if (event is BonsoirDiscoveryServiceLostEvent) {
          final services = List<BonsoirService>.from(state.discoveredServices)
            ..removeWhere((s) => s.name == event.service.name);
          emit(state.copyWith(discoveredServices: services));
        }
      });

      await _discovery!.start();
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
    }
  }

  // --- CLIENT CONNECTION ---
  Future<void> connectToHost(BonsoirService service) async {
    try {
      emit(state.copyWith(status: MultiplayerStatus.connecting));

      final ip = service.attributes['ip'] ?? 'localhost';
      final port = service.port;
      final url = Uri.parse("ws://$ip:$port");

      _clientChannel = WebSocketChannel.connect(url);
      await _clientChannel!.ready;

      _clientChannel!.sink.add(NetworkMessage(
        type: NetworkMessageType.action,
        payload: {'action': 'JOIN', 'playerName': state.playerName},
      ).encode());

      _clientChannel!.stream.listen((message) {
        _handleHostMessage(message);
      }, onDone: () => stopMultiplayer());

      emit(state.copyWith(status: MultiplayerStatus.connected, hostIp: ip, hostPort: port));
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

  /// Host or client: registers readiness. Host applies locally; clients message the host.
  void submitReady(String playerName) {
    if (state.status == MultiplayerStatus.hosting) {
      _addReadyPlayer(playerName);
    } else {
      sendToHost(NetworkMessage(
        type: NetworkMessageType.action,
        payload: {'action': 'READY', 'playerName': playerName},
      ).encode());
    }
  }

  /// Host or client: submit vote for tally. Host applies locally; clients message the host.
  void submitVote(String voterName, String votedPlayerName) {
    if (state.status == MultiplayerStatus.hosting) {
      _playerVotes[voterName] = votedPlayerName;
      if (_allVotesIn()) {
        _tallyVotesAndFinish();
      }
    } else {
      sendToHost(NetworkMessage(
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
    final roster = _connectedClients.values.toList();
    emit(state.copyWith(connectedPlayers: roster));
    broadcastToClients(NetworkMessage(
      type: NetworkMessageType.action,
      payload: {'action': 'ROSTER_SYNC', 'connectedPlayers': roster},
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

        if (action == 'START_GAME') {
          // Session state arrives via phaseSync.
        } else if (action == 'ROSTER_SYNC') {
          final roster = List<String>.from(networkMessage.payload['connectedPlayers'] ?? []);
          emit(state.copyWith(connectedPlayers: roster));
        }
      }
    }
  }

  void broadcastToClients(String encodedMessage) {
    for (final client in _connectedClients.keys) {
      client.sink.add(encodedMessage);
    }
  }

  void sendToHost(String encodedMessage) {
    _clientChannel?.sink.add(encodedMessage);
  }

  // --- CLEANUP ---
  Future<void> stopMultiplayer() async {
    await _gameSubscription?.cancel();
    await _broadcast?.stop();
    await _discovery?.stop();
    await _server?.close();
    await _clientChannel?.sink.close();
    for (final client in _connectedClients.keys) {
      await client.sink.close();
    }
    _connectedClients.clear();
    _readyPlayers.clear();
    _playerVotes.clear();
    _votingRoundResolved = false;
    emit(const MultiplayerState());
  }

  @override
  Future<void> close() {
    stopMultiplayer();
    return super.close();
  }
}
