import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_state.dart';
import 'package:hidden_word/features/game/data/repositories/word_repository.dart';

class GameCubit extends Cubit<GameState> {
  Timer? _gameTimer;

  GameCubit() : super(const GameState());

  /// Builds a roster for spy selection and voting labels. Uses [connectedPlayers]
  /// when non-empty; otherwise generates placeholder names from [playersCount].
  static List<String> _resolveRoster(int playersCount, List<String> connectedPlayers) {
    if (connectedPlayers.isNotEmpty) return List<String>.from(connectedPlayers);
    if (playersCount <= 0) return const [];
    return List.generate(playersCount, (i) => 'Player ${i + 1}');
  }

  /// Initialises the game. Fetches a random word from [categoryId].
  Future<void> init(
    int playersCount, {
    String categoryId = 'food',
    List<String>? spyPlayerNamesOverride,
    List<String> connectedPlayers = const [],
    int spyCount = 1,
  }) async {
    final roster = _resolveRoster(playersCount, connectedPlayers);
    final effectiveCount = roster.isNotEmpty ? roster.length : playersCount;
    final secretWord = await WordRepository.pickRandomWord(categoryId);

    List<String> spies;
    if (spyPlayerNamesOverride != null && spyPlayerNamesOverride.isNotEmpty) {
      spies = List<String>.from(spyPlayerNamesOverride);
    } else if (roster.isEmpty) {
      spies = const [];
    } else {
      final k = spyCount.clamp(1, roster.length);
      final shuffled = List<String>.from(roster)..shuffle(Random());
      spies = shuffled.take(k).toList();
    }

    emit(GameState(
      totalPlayers: effectiveCount,
      currentPlayerIndex: 1,
      phase: GamePhase.reveal,
      isRevealed: false,
      isReady: false,
      isVotingReady: false,
      secretWord: secretWord,
      spyCaught: false,
      spyPlayerNames: spies,
      connectedPlayers: roster,
      sessionActive: true,
      categoryId: categoryId,
      spyCount: spies.length,
      playersReadyCount: 0,
    ));
  }

  void toggleReveal() {
    emit(state.copyWith(isRevealed: !state.isRevealed));
  }

  void markAsReady() {
    emit(state.copyWith(isReady: true));
  }

  void setPlayersReadyCount(int count) {
    emit(state.copyWith(playersReadyCount: count));
  }

  void startDiscussion({bool isHost = false}) {
    _gameTimer?.cancel();
    emit(state.copyWith(
      phase: GamePhase.discussion,
      timerSeconds: 105,
      playersReadyCount: 0,
    ));

    if (isHost) {
      _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final s = state;
        if (s.phase != GamePhase.discussion) {
          timer.cancel();
          return;
        }
        if (s.timerSeconds > 0) {
          final next = s.timerSeconds - 1;
          emit(state.copyWith(timerSeconds: next));
          if (next == 0) {
            timer.cancel();
            startVoting(isHost: true);
          }
        }
      });
    }
  }

  void startVoting({bool isHost = false}) {
    _gameTimer?.cancel();
    emit(state.copyWith(
      phase: GamePhase.voting,
      timerSeconds: 45,
      isVotingReady: false,
      clearVotedPlayer: true,
    ));

    if (isHost) {
      _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final s = state;
        if (s.phase != GamePhase.voting) {
          timer.cancel();
          return;
        }
        if (s.timerSeconds > 0) {
          final next = s.timerSeconds - 1;
          emit(state.copyWith(timerSeconds: next));
        } else {
          timer.cancel();
        }
      });
    }
  }

  void selectVote(int index) {
    emit(state.copyWith(
      votedPlayerIndex: index,
      isVotingReady: true,
    ));
  }

  void startResults(bool spyCaught, String? majorityVotedName) {
    _gameTimer?.cancel();
    emit(state.copyWith(
      phase: GamePhase.results,
      spyCaught: spyCaught,
      majorityVotedName: majorityVotedName,
    ));
  }

  Future<void> resetGame() async {
    await init(
      state.totalPlayers,
      categoryId: state.categoryId,
      connectedPlayers: state.connectedPlayers,
      spyCount: state.spyCount,
    );
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
