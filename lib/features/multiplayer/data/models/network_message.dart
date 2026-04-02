import 'dart:convert';
import 'package:equatable/equatable.dart';

enum NetworkMessageType {
  phaseSync,
  action,
  playerJoin,
  playerLeave,
}

class NetworkMessage extends Equatable {
  final NetworkMessageType type;
  final Map<String, dynamic> payload;

  const NetworkMessage({
    required this.type,
    required this.payload,
  });

  factory NetworkMessage.fromJson(Map<String, dynamic> json) {
    return NetworkMessage(
      type: NetworkMessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NetworkMessageType.phaseSync,
      ),
      payload: json['payload'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'payload': payload,
    };
  }

  String encode() => jsonEncode(toJson());

  factory NetworkMessage.decode(String source) =>
      NetworkMessage.fromJson(jsonDecode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [type, payload];
}
