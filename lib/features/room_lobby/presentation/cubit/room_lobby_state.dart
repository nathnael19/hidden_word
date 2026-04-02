import 'package:equatable/equatable.dart';

class RoomLobbyState extends Equatable {
  final int spyCount;
  final List<String> selectedCategories;
  final bool isTimerEnabled;
  final List<Map<String, dynamic>> players;
  final String roomId;

  const RoomLobbyState({
    this.spyCount = 2,
    this.selectedCategories = const ['Traditional Food', 'Ethiopian Culture'],
    this.isTimerEnabled = true,
    this.players = const [],
    this.roomId = 'H 7 K 9',
  });

  RoomLobbyState copyWith({
    int? spyCount,
    List<String>? selectedCategories,
    bool? isTimerEnabled,
    List<Map<String, dynamic>>? players,
    String? roomId,
  }) {
    return RoomLobbyState(
      spyCount: spyCount ?? this.spyCount,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isTimerEnabled: isTimerEnabled ?? this.isTimerEnabled,
      players: players ?? this.players,
      roomId: roomId ?? this.roomId,
    );
  }

  @override
  List<Object> get props => [spyCount, selectedCategories, isTimerEnabled, players, roomId];
}
