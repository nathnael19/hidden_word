import 'package:bonsoir/bonsoir.dart';
import 'package:equatable/equatable.dart';

enum MultiplayerStatus { initial, hosting, searching, connecting, connected, error }

class MultiplayerState extends Equatable {
  final MultiplayerStatus status;
  final List<BonsoirService> discoveredServices;
  final List<String> connectedPlayers;
  final String? hostIp;
  final int? hostPort;
  final String? errorMessage;
  final String playerName;

  const MultiplayerState({
    this.status = MultiplayerStatus.initial,
    this.discoveredServices = const [],
    this.connectedPlayers = const [],
    this.hostIp,
    this.hostPort,
    this.errorMessage,
    this.playerName = 'Player',
  });

  MultiplayerState copyWith({
    MultiplayerStatus? status,
    List<BonsoirService>? discoveredServices,
    List<String>? connectedPlayers,
    String? hostIp,
    int? hostPort,
    String? errorMessage,
    String? playerName,
  }) {
    return MultiplayerState(
      status: status ?? this.status,
      discoveredServices: discoveredServices ?? this.discoveredServices,
      connectedPlayers: connectedPlayers ?? this.connectedPlayers,
      hostIp: hostIp ?? this.hostIp,
      hostPort: hostPort ?? this.hostPort,
      errorMessage: errorMessage ?? this.errorMessage,
      playerName: playerName ?? this.playerName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        discoveredServices,
        connectedPlayers,
        hostIp,
        hostPort,
        errorMessage,
        playerName,
      ];
}
