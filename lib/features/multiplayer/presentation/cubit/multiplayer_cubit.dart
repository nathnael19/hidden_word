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
  final List<WebSocketChannel> _connectedClients = [];
  final NetworkInfo _networkInfo = NetworkInfo();

  MultiplayerCubit({required this.gameCubit}) : super(const MultiplayerState());

  // --- HOSTING ---
  Future<void> startHosting(String playerName) async {
    try {
      emit(state.copyWith(status: MultiplayerStatus.hosting, playerName: playerName));

      // 1. Get Local IP
      final ip = await _networkInfo.getWifiIP();
      if (ip == null) throw Exception("Could not get local IP");

      // 2. Start WebSocket Server
      final handler = webSocketHandler((webSocket, _) {
        _connectedClients.add(webSocket);
        webSocket.stream.listen((message) {
          // Handle incoming actions from clients (e.g., 'READY')
          _handleClientMessage(webSocket, message);
        }, onDone: () => _connectedClients.remove(webSocket));
      });

      _server = await shelf_io.serve(handler, ip, 0); // Port 0 for ephemeral
      final port = _server!.port;

      // 3. Broadcast Service
      _service = BonsoirService(
        name: "$playerName's Room",
        type: '_hiddenword._tcp',
        port: port,
        attributes: {'ip': ip},
      );

      _broadcast = BonsoirBroadcast(service: _service!);
      await _broadcast!.initialize();
      await _broadcast!.start();

      // Listen for local game state changes to broadcast to clients
      _gameSubscription = gameCubit.stream.listen((gameState) {
        broadcastToClients(NetworkMessage(
          type: NetworkMessageType.phaseSync,
          payload: gameState.toJson(),
        ).encode());
      });

      emit(state.copyWith(status: MultiplayerStatus.hosting, hostIp: ip, hostPort: port));
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
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

      _clientChannel!.stream.listen((message) {
        // Handle state sync from host
        _handleHostMessage(message);
      }, onDone: () => stopMultiplayer());

      emit(state.copyWith(status: MultiplayerStatus.connected, hostIp: ip, hostPort: port));
    } catch (e) {
      emit(state.copyWith(status: MultiplayerStatus.error, errorMessage: e.toString()));
    }
  }

  // --- MESSAGE HANDLING ---
  void _handleClientMessage(WebSocketChannel client, dynamic message) {
    // Logic to update master GameCubit or player list
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
          final category = networkMessage.payload['category'] as String? ?? 'food';
          gameCubit.init(6, categoryId: category).then((_) {
            emit(state.copyWith(status: MultiplayerStatus.connected));
          });
        }
      }
    }
  }

  void broadcastToClients(String encodedMessage) {
    for (final client in _connectedClients) {
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
    for (final client in _connectedClients) {
      await client.sink.close();
    }
    _connectedClients.clear();
    emit(const MultiplayerState());
  }

  @override
  Future<void> close() {
    stopMultiplayer();
    return super.close();
  }
}
