import 'package:equatable/equatable.dart';

/// Parsed data from a Hidden Word QR code.
class QrData extends Equatable {
  final String ip;
  final int port;
  final String roomName;

  const QrData({
    required this.ip,
    required this.port,
    required this.roomName,
  });

  @override
  List<Object?> get props => [ip, port, roomName];
}

/// Handles encoding and decoding the Hidden Word QR deep-link format.
///
/// Format: `hiddenword://join?ip={IP}&port={PORT}&room={ROOM_NAME}`
class QrService {
  static const _scheme = 'hiddenword';
  static const _host = 'join';

  /// Builds the QR string for a given host session.
  static String encode(String ip, int port, String roomName) {
    final uri = Uri(
      scheme: _scheme,
      host: _host,
      queryParameters: {
        'ip': ip,
        'port': port.toString(),
        'room': roomName,
      },
    );
    return uri.toString();
  }

  /// Parses a scanned string. Returns [QrData] on success, null if invalid.
  static QrData? decode(String raw) {
    try {
      final uri = Uri.parse(raw);

      if (uri.scheme != _scheme || uri.host != _host) return null;

      final ip = uri.queryParameters['ip'];
      final portStr = uri.queryParameters['port'];
      final roomName = uri.queryParameters['room'];

      if (ip == null || ip.isEmpty) return null;
      if (portStr == null) return null;

      final port = int.tryParse(portStr);
      if (port == null || port <= 0 || port > 65535) return null;

      // Basic IPv4 format check
      final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
      if (!ipRegex.hasMatch(ip)) return null;

      return QrData(
        ip: ip,
        port: port,
        roomName: roomName ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
