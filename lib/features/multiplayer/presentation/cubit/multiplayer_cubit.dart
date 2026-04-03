import 'dart:async';
import 'dart:io';
import 'dart:math';
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
  StreamSubscription? _discoverySubscription;
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
  static const int kWebSocketPort = 40400;

  MultiplayerCubit({required this.gameCubit})
      : super(MultiplayerState(playerName: _generateRandomAgentName()));

  static String _generateRandomAgentName() {
    final names = [
      'SHADOW', 'ECHO', 'SILENT', 'SPECTER', 'GHOST',
      'VIPER', 'NOVA', 'RAVEN', 'CIPHER', 'ORACLE',
      'COBRA', 'PHANTOM', 'NEON', 'TITAN', 'ZENITH'
    ];
    final suffixes = [
      'AGENT', 'OPERATOR', 'WALKER', 'BLADE', 'SOUL',
      'MIND', 'ZERO', 'HUNTER', 'STRIKER', 'VANGUARD'
    ];
    final rand = Random();
    final name = names[rand.nextInt(names.length)];
    final suffix = suffixes[rand.nextInt(suffixes.length)];
    final id = rand.nextInt(900) + 100; // 100-999
    return '$name $suffix $id';
  }

  /// Sets the local player's display name for roster/voting.
  void setPlayerName(String name) {
    if (name.trim().isEmpty) return;
    emit(state.copyWith(playerName: name.trim()));
  }

  Future<String> _resolveToIPv4(String hostOrIp) async {
    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (ipRegex.hasMatch(hostOrIp)) return hostOrIp;

    final addrs = await InternetAddress.lookup(hostOrIp)
        .timeout(const Duration(seconds: 3));
    for (final a in addrs) {
      if (a.type == InternetAddressType.IPv4) return a.address;
    }
    throw Exception('Could not resolve $hostOrIp to an IPv4 address');
  }

  String? _extractIpFromService(BonsoirService service) {
    final attrs = service.attributes;

    final direct = attrs['ip'] ?? attrs['IP'];
    if (direct != null && direct.isNotEmpty) return direct;

    // Bonsoir sometimes provides a single "paarams" blob; in your logs it's:
    // paarams="{\"VERSION\":1,\"IP\":\"192.168.x.y\",...}"
    final paarams = attrs['paarams'];
    if (paarams != null && paarams.isNotEmpty) {
      final m = RegExp(r'"IP"\s*:\s*"([^"]+)"', caseSensitive: false)
          .firstMatch(paarams);
      if (m != null && m.group(1) != null && m.group(1)!.isNotEmpty) {
        return m.group(1);
      }
    }
    return null;
  }

  int? _extractPortFromService(BonsoirService service) {
    final direct = service.attributes['port'] ?? service.attributes['PORT'];
    final parsed = int.tryParse(direct ?? '');
    if (parsed != null && parsed > 0) return parsed;
    return null;
  }

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
  Future<void> startHosting(String roomName) async {
    try {
      // If we were already hosting (e.g. testing), stop old listeners/broadcast first.
      if (state.status == MultiplayerStatus.hosting) {
        await stopMultiplayer();
      }

      emit(state.copyWith(status: MultiplayerStatus.hosting, clearError: true));

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

      // Try the well-known port first. If it's still held from a hot-restart,
      // let the OS pick any free port (port 0). The actual port is always
      // communicated via mDNS TXT attributes, so joiners will find it.
      HttpServer? server;
      int port = kWebSocketPort;
      try {
        server = await shelf_io.serve(handler, ip, kWebSocketPort);
        port = server.port;
      } on SocketException catch (_) {
        // Fixed port busy — let the OS assign a free one.
        server = await shelf_io.serve(handler, ip, 0);
        port = server.port;
      }
      _server = server;
      print('[Multiplayer] WS server listening on $ip:$port');

      _service = BonsoirService(
        // Joiners display this service name directly.
        name: roomName,
        type: '_hiddenword._tcp',
        port: port,
        host: ip,
        attributes: {
          'ip': ip,
          'IP': ip,
          'port': port.toString(),
          'PORT': port.toString(),
        },
      );

      _broadcast = BonsoirBroadcast(service: _service!);
      await _broadcast!.initialize();
      await _broadcast!.start();

      _gameSubscription = gameCubit.stream.listen(_onGameStateForHostAndClients);

      emit(state.copyWith(status: MultiplayerStatus.hosting, hostIp: ip, hostPort: port, clearError: true));
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
    }
  }

  void _onGameStateForHostAndClients(GameState gameState) {
    // New round returns to reveal; reset so timer-based tally can run again.
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
      // Clear stale results from previous scans so room name changes show up.
      emit(state.copyWith(
        status: MultiplayerStatus.searching,
        discoveredServices: const [],
        clearError: true,
      ));

      // Cancel any previous discovery listener to avoid duplicate entries.
      await _discoverySubscription?.cancel();
      _discoverySubscription = null;
      await _discovery?.stop();
      _discovery = BonsoirDiscovery(type: '_hiddenword._tcp');
      await _discovery!.initialize();

      _discoverySubscription = _discovery!.eventStream!.listen((event) {
        if (event is BonsoirDiscoveryServiceResolvedEvent) {
          final service = event.service;

          final services = List<BonsoirService>.from(state.discoveredServices)
            ..removeWhere((s) => s.name == service.name)
            ..add(service);
          emit(state.copyWith(discoveredServices: services));
        } else if (event is BonsoirDiscoveryServiceFoundEvent) {
          // "Found" can have incomplete host/IP info, but we still keep the
          // service so the user can see the room. Connection will still fail
          // (with an error banner) if we can't determine an IP.
          final service = event.service;

          final services = List<BonsoirService>.from(state.discoveredServices)
            ..removeWhere((s) => s.name == service.name)
            ..add(service);
          emit(state.copyWith(discoveredServices: services));
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
      emit(state.copyWith(status: MultiplayerStatus.connecting, clearError: true));

      // 1. Resolve IP — TXT attributes first, then service.host, then gateway.
      final ipRaw =
          service.attributes['ip'] ?? service.attributes['IP'] ?? service.host ?? _extractIpFromService(service);

      // 2. Resolve port — service.port first, then TXT attributes, then fixed fallback.
      final port = (service.port != 0)
          ? service.port
          : (_extractPortFromService(service) ?? kWebSocketPort);

      String ip;
      if (ipRaw != null && ipRaw.isNotEmpty) {
        ip = await _resolveToIPv4(ipRaw);
      } else {
        String? gateway = await _networkInfo.getWifiGatewayIP();
        
        // If Android fails to give us a gateway (common on offline hotspots), 
        // fallback to the standard Android Hotspot IP before giving up.
        if (gateway == null || gateway.isEmpty) {
          gateway = '192.168.43.1'; 
          print('[Multiplayer] gateway fetch failed, trying standard hotspot IP: $gateway');
        }
        ip = gateway;
      }

      final url = Uri.parse("ws://$ip:$port");
      print('[Multiplayer] Connecting to: $url (service.port=${service.port}, attrs=${service.attributes})');

      _clientChannel = WebSocketChannel.connect(url);

      // Timeout so the UI doesn't hang if the host is unreachable.
      await _clientChannel!.ready.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          _clientChannel?.sink.close();
          throw Exception(
            'Connection timed out trying to reach $url. '
            'Make sure both devices are on the same network.',
          );
        },
      );

      _clientChannel!.sink.add(NetworkMessage(
        type: NetworkMessageType.action,
        payload: {'action': 'JOIN', 'playerName': state.playerName},
      ).encode());

      _clientChannel!.stream.listen((message) {
        _handleHostMessage(message);
      }, onDone: () => stopMultiplayer());

      emit(state.copyWith(status: MultiplayerStatus.connected, hostIp: ip, hostPort: port));
    } catch (e) {
      print('[Multiplayer] connectToHost error: $e');
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
    final clientNames = _connectedClients.values.toList();
    // Host sees only client names (host card is added by the UI).
    emit(state.copyWith(connectedPlayers: clientNames));
    // Clients receive the full roster including the host so they can
    // display everyone before the game starts.
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
    for (final client in _connectedClients.keys) {
      client.sink.add(encodedMessage);
    }
  }

  void sendToHost(String encodedMessage) {
    _clientChannel?.sink.add(encodedMessage);
  }

  // --- CLEANUP ---
  Future<void> stopMultiplayer() async {
    // Preserve the player name so it survives between sessions.
    final savedName = state.playerName;
    await _gameSubscription?.cancel();
    await _discoverySubscription?.cancel();
    _discoverySubscription = null;
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
    emit(MultiplayerState(playerName: savedName));
  }

  @override
  Future<void> close() {
    stopMultiplayer();
    return super.close();
  }
}
