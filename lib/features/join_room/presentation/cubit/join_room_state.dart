import 'package:equatable/equatable.dart';

class JoinRoomState extends Equatable {
  final bool isScanning;
  final List<Map<String, dynamic>> nearbyGames;

  const JoinRoomState({
    this.isScanning = false,
    this.nearbyGames = const [],
  });

  JoinRoomState copyWith({
    bool? isScanning,
    List<Map<String, dynamic>>? nearbyGames,
  }) {
    return JoinRoomState(
      isScanning: isScanning ?? this.isScanning,
      nearbyGames: nearbyGames ?? this.nearbyGames,
    );
  }

  @override
  List<Object> get props => [isScanning, nearbyGames];
}
