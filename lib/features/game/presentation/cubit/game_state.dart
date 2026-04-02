import 'package:equatable/equatable.dart';

enum GamePhase { reveal, discussion, voting, results }

class GameState extends Equatable {
  final int currentPlayerIndex;
  final bool isRevealed;
  final int totalPlayers;
  final String secretWord;
  final bool isReady;
  final GamePhase phase;
  final int timerSeconds;
  final bool isPeeking;
  final int? votedPlayerIndex;
  final bool isVotingReady;
  final bool spyCaught;
  final String? spyPlayerName;
  final List<String> connectedPlayers;
  final String? majorityVotedName;

  const GameState({
    this.currentPlayerIndex = 1,
    this.isRevealed = false,
    this.totalPlayers = 6,
    this.secretWord = 'BUNA',
    this.isReady = false,
    this.phase = GamePhase.reveal,
    this.timerSeconds = 105,
    this.isPeeking = false,
    this.votedPlayerIndex,
    this.isVotingReady = false,
    this.spyCaught = false,
    this.spyPlayerName,
    this.connectedPlayers = const [],
    this.majorityVotedName,
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      currentPlayerIndex: json['currentPlayerIndex'] as int,
      isRevealed: json['isRevealed'] as bool,
      totalPlayers: json['totalPlayers'] as int,
      secretWord: json['secretWord'] as String,
      isReady: json['isReady'] as bool,
      phase: GamePhase.values.firstWhere((e) => e.name == json['phase']),
      timerSeconds: json['timerSeconds'] as int,
      isPeeking: json['isPeeking'] as bool,
      votedPlayerIndex: json['votedPlayerIndex'] as int?,
      isVotingReady: json['isVotingReady'] as bool,
      spyCaught: json['spyCaught'] as bool,
      spyPlayerName: json['spyPlayerName'] as String?,
      connectedPlayers: List<String>.from(json['connectedPlayers'] ?? []),
      majorityVotedName: json['majorityVotedName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPlayerIndex': currentPlayerIndex,
      'isRevealed': isRevealed,
      'totalPlayers': totalPlayers,
      'secretWord': secretWord,
      'isReady': isReady,
      'phase': phase.name,
      'timerSeconds': timerSeconds,
      'isPeeking': isPeeking,
      'votedPlayerIndex': votedPlayerIndex,
      'isVotingReady': isVotingReady,
      'spyCaught': spyCaught,
      'spyPlayerName': spyPlayerName,
      'connectedPlayers': connectedPlayers,
      'majorityVotedName': majorityVotedName,
    };
  }

  GameState copyWith({
    int? currentPlayerIndex,
    bool? isRevealed,
    int? totalPlayers,
    String? secretWord,
    bool? isReady,
    GamePhase? phase,
    int? timerSeconds,
    bool? isPeeking,
    int? votedPlayerIndex,
    bool? isVotingReady,
    bool? spyCaught,
    String? spyPlayerName,
    List<String>? connectedPlayers,
    String? majorityVotedName,
    bool clearVotedPlayer = false,
  }) {
    return GameState(
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      isRevealed: isRevealed ?? this.isRevealed,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      secretWord: secretWord ?? this.secretWord,
      isReady: isReady ?? this.isReady,
      phase: phase ?? this.phase,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isPeeking: isPeeking ?? this.isPeeking,
      votedPlayerIndex: clearVotedPlayer ? null : (votedPlayerIndex ?? this.votedPlayerIndex),
      isVotingReady: isVotingReady ?? this.isVotingReady,
      spyCaught: spyCaught ?? this.spyCaught,
      spyPlayerName: spyPlayerName ?? this.spyPlayerName,
      connectedPlayers: connectedPlayers ?? this.connectedPlayers,
      majorityVotedName: majorityVotedName ?? this.majorityVotedName,
    );
  }

  @override
  List<Object?> get props => [
        currentPlayerIndex,
        isRevealed,
        totalPlayers,
        secretWord,
        isReady,
        phase,
        timerSeconds,
        isPeeking,
        votedPlayerIndex,
        isVotingReady,
        spyCaught,
        spyPlayerName,
        connectedPlayers,
        majorityVotedName,
      ];
}
