import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidden_word/features/join_room/presentation/cubit/join_room_state.dart';

class JoinRoomCubit extends Cubit<JoinRoomState> {
  JoinRoomCubit() : super(const JoinRoomState());

  void init() {
    emit(state.copyWith(isScanning: true));
    // Mock local network discovery
    Future.delayed(const Duration(seconds: 2), () {
      emit(state.copyWith(
        isScanning: false,
        nearbyGames: [
          {'host': "Yonas's Room", 'players': '3/8', 'status': 'Waiting', 'isFull': false},
          {'host': "Dorm 4A", 'players': '5/10', 'status': 'Waiting', 'isFull': false},
          {'host': "ተጫዋቾች (Daddy Alpha)", 'players': '7/8', 'status': 'Full', 'isFull': true},
        ],
      ));
    });
  }

  void refresh() {
    init();
  }
}
