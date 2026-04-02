import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_state.dart';

class RoomLobbyCubit extends Cubit<RoomLobbyState> {
  RoomLobbyCubit() : super(const RoomLobbyState());

  void init() {
    emit(state.copyWith(
      players: [
        {'name': 'Abebe', 'status': 'READY', 'isHost': true},
        {'name': 'Sara', 'status': 'READY', 'isHost': false},
        {'name': 'Dawit', 'status': '...', 'isHost': false},
        {'name': 'Leya', 'status': 'READY', 'isHost': false},
      ],
    ));
  }

  void updateSpyCount(int count) {
    emit(state.copyWith(spyCount: count));
  }

  void toggleCategory(String category) {
    final updated = List<String>.from(state.selectedCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    emit(state.copyWith(selectedCategories: updated));
  }

  void toggleTimer(bool value) {
    emit(state.copyWith(isTimerEnabled: value));
  }
}
