import 'package:equatable/equatable.dart';

enum GamePhase { reveal, discussion, voting, results }

class GameState extends Equatable {
  final int currentPlayerIndex;
  final bool isRevealed;
  final int totalPlayers;
  final String secretWord;
  final bool isSpy;
  final bool isReady;
  final GamePhase phase;
  final int timerSeconds;
  final bool isPeeking;
  final int? votedPlayerIndex;
  final bool isVotingReady;
  final bool spyCaught;

  const GameState({
    this.currentPlayerIndex = 1,
    this.isRevealed = false,
    this.totalPlayers = 6,
    this.secretWord = 'BUNA', // Placeholder: Coffee
    this.isSpy = false,
    this.isReady = false,
    this.phase = GamePhase.reveal,
    this.timerSeconds = 105, // Discussion: 01:45
    this.isPeeking = false,
    this.votedPlayerIndex,
    this.isVotingReady = false,
    this.spyCaught = true,
  });

  GameState copyWith({
    int? currentPlayerIndex,
    bool? isRevealed,
    int? totalPlayers,
    String? secretWord,
    bool? isSpy,
    bool? isReady,
    GamePhase? phase,
    int? timerSeconds,
    bool? isPeeking,
    int? votedPlayerIndex,
    bool? isVotingReady,
    bool? spyCaught,
    bool clearVotedPlayer = false,
  }) {
    return GameState(
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      isRevealed: isRevealed ?? this.isRevealed,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      secretWord: secretWord ?? this.secretWord,
      isSpy: isSpy ?? this.isSpy,
      isReady: isReady ?? this.isReady,
      phase: phase ?? this.phase,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isPeeking: isPeeking ?? this.isPeeking,
      votedPlayerIndex: clearVotedPlayer ? null : (votedPlayerIndex ?? this.votedPlayerIndex),
      isVotingReady: isVotingReady ?? this.isVotingReady,
      spyCaught: spyCaught ?? this.spyCaught,
    );
  }

  @override
  List<Object?> get props => [
        currentPlayerIndex,
        isRevealed,
        totalPlayers,
        secretWord,
        isSpy,
        isReady,
        phase,
        timerSeconds,
        isPeeking,
        votedPlayerIndex,
        isVotingReady,
        spyCaught,
      ];
}
