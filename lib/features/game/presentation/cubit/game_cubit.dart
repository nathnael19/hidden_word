import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  Timer? _gameTimer;

  GameCubit() : super(const GameState());

  void init(int playersCount) {
    emit(state.copyWith(
      totalPlayers: playersCount,
      currentPlayerIndex: 1,
      phase: GamePhase.reveal,
      isReady: false,
    ));
  }

  void toggleReveal() {
    emit(state.copyWith(isRevealed: !state.isRevealed));
  }

  void markAsReady() {
    emit(state.copyWith(isReady: true));
  }

  void startDiscussion() {
    _gameTimer?.cancel();
    emit(state.copyWith(
      phase: GamePhase.discussion,
      timerSeconds: 105, // 01:45
      isReady: true,
    ));

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds > 0) {
        emit(state.copyWith(timerSeconds: state.timerSeconds - 1));
      } else {
        timer.cancel();
        // The UI will handle auto-transition to voting phase
      }
    });
  }

  void startVoting() {
    _gameTimer?.cancel();
    emit(state.copyWith(
      phase: GamePhase.voting,
      timerSeconds: 45, // 0:45 for voting session
      votedPlayerIndex: null, // Reset previous vote
      clearVotedPlayer: true,
    ));

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds > 0) {
        emit(state.copyWith(timerSeconds: state.timerSeconds - 1));
      } else {
        timer.cancel();
        // Next phase would be reveal results
      }
    });
  }

  void selectVote(int index) {
    emit(state.copyWith(votedPlayerIndex: index));
  }

  void togglePeeking() {
    emit(state.copyWith(isPeeking: !state.isPeeking));
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}
