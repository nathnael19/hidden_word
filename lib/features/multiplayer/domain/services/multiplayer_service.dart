import 'dart:async';
import 'dart:io';
import 'package:bonsoir/bonsoir.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MultiplayerService {
  final NetworkInfo _networkInfo = NetworkInfo();
  static const int kWebSocketPort = 40400;

  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription? _discoverySubscription;
  HttpServer? _server;
  WebSocketChannel? _clientChannel;

  // For hosting
  Future<Map<String, dynamic>> startServer({
    required String roomName,
    required Function(WebSocketChannel, dynamic) onClientMessage,
    required Function(WebSocketChannel) onClientDisconnected,
  }) async {
    final ip = await _resolveAdvertisedHostIp();

    final handler = webSocketHandler((webSocket, _) {
      webSocket.stream.listen((message) {
        onClientMessage(webSocket, message);
      }, onDone: () {
        onClientDisconnected(webSocket);
      });
    });

    HttpServer? server;
    int port = kWebSocketPort;
    try {
      server = await shelf_io.serve(handler, ip, kWebSocketPort);
      port = server.port;
    } on SocketException catch (_) {
      server = await shelf_io.serve(handler, ip, 0);
      port = server.port;
    }
    _server = server;

    final service = BonsoirService(
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

    _broadcast = BonsoirBroadcast(service: service);
    await _broadcast!.initialize();
    await _broadcast!.start();

    return {'ip': ip, 'port': port};
  }

  Future<void> stopServer() async {
    await _broadcast?.stop();
    await _server?.close();
    _server = null;
    _broadcast = null;
  }

  // For discovery
  Future<void> startDiscovery({
    required Function(List<BonsoirService>) onServicesUpdate,
  }) async {
    await _discoverySubscription?.cancel();
    await _discovery?.stop();

    _discovery = BonsoirDiscovery(type: '_hiddenword._tcp');
    await _discovery!.initialize();

    final List<BonsoirService> discoveredServices = [];

    _discoverySubscription = _discovery!.eventStream!.listen((event) {
      if (event is BonsoirDiscoveryServiceResolvedEvent) {
        final service = event.service;
        discoveredServices.removeWhere((s) => s.name == service.name);
        discoveredServices.add(service);
        onServicesUpdate(List.from(discoveredServices));
      } else if (event is BonsoirDiscoveryServiceFoundEvent) {
        final service = event.service;
        discoveredServices.removeWhere((s) => s.name == service.name);
        discoveredServices.add(service);
        onServicesUpdate(List.from(discoveredServices));
      } else if (event is BonsoirDiscoveryServiceLostEvent) {
        discoveredServices.removeWhere((s) => s.name == event.service.name);
        onServicesUpdate(List.from(discoveredServices));
      }
    });

    await _discovery!.start();
  }

  Future<void> stopDiscovery() async {
    await _discoverySubscription?.cancel();
    await _discovery?.stop();
    _discoverySubscription = null;
    _discovery = null;
  }

  // For client connection
  Future<Map<String, dynamic>> connectToHost({
    required BonsoirService service,
    required Function(dynamic) onMessage,
    required Function() onDone,
  }) async {
    final ipRaw = service.attributes['ip'] ??
        service.attributes['IP'] ??
        service.host ??
        _extractIpFromService(service);

    final port = (service.port != 0)
        ? service.port
        : (_extractPortFromService(service) ?? kWebSocketPort);

    String ip;
    if (ipRaw != null && ipRaw.isNotEmpty) {
      ip = await _resolveToIPv4(ipRaw);
    } else {
      String? gateway = await _networkInfo.getWifiGatewayIP();
      if (gateway == null || gateway.isEmpty) {
        gateway = '192.168.43.1';
      }
      ip = gateway;
    }

    final url = Uri.parse("ws://$ip:$port");
    _clientChannel = WebSocketChannel.connect(url);

    await _clientChannel!.ready.timeout(const Duration(seconds: 5));

    _clientChannel!.stream.listen(onMessage, onDone: onDone);

    return {'ip': ip, 'port': port, 'url': url};
  }

  void disconnect() {
    _clientChannel?.sink.close();
    _clientChannel = null;
  }

  void broadcastToClients(Iterable<WebSocketChannel> clients, String message) {
    for (final client in clients) {
      client.sink.add(message);
    }
  }

  void sendToHost(String message) {
    _clientChannel?.sink.add(message);
  }

  // Internals
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

    throw Exception('Could not determine local IP.');
  }

  Future<String> _resolveToIPv4(String hostOrIp) async {
    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (ipRegex.hasMatch(hostOrIp)) return hostOrIp;

    final addrs = await InternetAddress.lookup(hostOrIp)
        .timeout(const Duration(seconds: 3));
    for (final a in addrs) {
      if (a.type == InternetAddressType.IPv4) return a.address;
    }
    throw Exception('Could not resolve $hostOrIp to IPv4');
  }

  String? _extractIpFromService(BonsoirService service) {
    final attrs = service.attributes;
    final direct = attrs['ip'] ?? attrs['IP'];
    if (direct != null && direct.isNotEmpty) return direct;

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
    return int.tryParse(direct ?? '');
  }

  Future<void> dispose() async {
    await stopServer();
    await stopDiscovery();
    disconnect();
  }
}
