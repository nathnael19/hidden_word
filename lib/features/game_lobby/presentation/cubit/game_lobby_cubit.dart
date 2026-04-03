import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidden_word/features/game_lobby/presentation/cubit/game_lobby_state.dart';

class GameLobbyCubit extends Cubit<GameLobbyState> {
  GameLobbyCubit() : super(GameLobbyInitial());

  void init() async {
    emit(GameLobbyScanning());
    // Simulate scan delay
    await Future.delayed(const Duration(seconds: 2));
    
    emit(const GameLobbyReady(nearbyGames: []));
  }
}
