import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_state.dart';
import 'package:hidden_word/features/game/data/repositories/word_repository.dart';

class GameCubit extends Cubit<GameState> {
  Timer? _gameTimer;

  GameCubit() : super(const GameState());

  /// Picks a random spy among all players.
  int _pickSpyIndex(int totalPlayers) {
    return Random().nextInt(totalPlayers) + 1;
  }

  /// Initialises the game. Fetches a random word from [categoryId].
  /// If no category is given, defaults to 'food'.
  Future<void> init(int playersCount, {String categoryId = 'food'}) async {
    final secretWord = await WordRepository.pickRandomWord(categoryId);
    final spyIndex = _pickSpyIndex(playersCount);

    emit(GameState(
      totalPlayers: playersCount,
      currentPlayerIndex: 1,
      phase: GamePhase.reveal,
      isRevealed: false,
      isReady: false,
      isVotingReady: false,
      secretWord: secretWord,
      isSpy: 1 == spyIndex, // will be overridden per device in a real session
      spyCaught: false,
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
    ));

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds > 0) {
        emit(state.copyWith(timerSeconds: state.timerSeconds - 1));
      } else {
        timer.cancel();
      }
    });
  }

  void startVoting() {
    _gameTimer?.cancel();
    emit(state.copyWith(
      phase: GamePhase.voting,
      timerSeconds: 45,
      isVotingReady: false,
      clearVotedPlayer: true,
    ));

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds > 0) {
        emit(state.copyWith(timerSeconds: state.timerSeconds - 1));
      } else {
        timer.cancel();
      }
    });
  }

  void selectVote(int index) {
    emit(state.copyWith(
      votedPlayerIndex: index,
      isVotingReady: true,
    ));
  }

  void startResults() {
    _gameTimer?.cancel();
    emit(state.copyWith(
      phase: GamePhase.results,
      spyCaught: true, // TODO: replace with actual vote tally
    ));
  }

  Future<void> resetGame() async {
    await init(state.totalPlayers);
  }

  void togglePeeking() {
    emit(state.copyWith(isPeeking: !state.isPeeking));
  }

  void syncState(GameState incomingState) {
    emit(incomingState);
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}
