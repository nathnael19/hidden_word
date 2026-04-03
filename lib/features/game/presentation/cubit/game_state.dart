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
  /// All players who are spies for this round.
  final List<String> spyPlayerNames;
  final List<String> connectedPlayers;
  final String? majorityVotedName;
  /// True after [GameCubit.init] has run for an active round (host or synced client).
  final bool sessionActive;
  /// Word category id used for this session (words.json).
  final String categoryId;
  /// Number of spies configured for this session.
  final int spyCount;
  /// How many players have pressed ready (host-authoritative, synced).
  final int playersReadyCount;

  const GameState({
    this.currentPlayerIndex = 1,
    this.isRevealed = false,
    this.totalPlayers = 0,
    this.secretWord = '',
    this.isReady = false,
    this.phase = GamePhase.reveal,
    this.timerSeconds = 0,
    this.isPeeking = false,
    this.votedPlayerIndex,
    this.isVotingReady = false,
    this.spyCaught = false,
    this.spyPlayerNames = const [],
    this.connectedPlayers = const [],
    this.majorityVotedName,
    this.sessionActive = false,
    this.categoryId = 'food',
    this.spyCount = 1,
    this.playersReadyCount = 0,
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    List<String> parseSpyNames() {
      if (json['spyPlayerNames'] != null) {
        return List<String>.from(json['spyPlayerNames'] as List);
      }
      final legacy = json['spyPlayerName'] as String?;
      if (legacy != null && legacy.isNotEmpty) return [legacy];
      return const [];
    }

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
      spyPlayerNames: parseSpyNames(),
      connectedPlayers: List<String>.from(json['connectedPlayers'] ?? []),
      majorityVotedName: json['majorityVotedName'] as String?,
      sessionActive: json['sessionActive'] as bool? ?? false,
      categoryId: json['categoryId'] as String? ?? 'food',
      spyCount: json['spyCount'] as int? ?? 1,
      playersReadyCount: json['playersReadyCount'] as int? ?? 0,
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
      'spyPlayerNames': spyPlayerNames,
      'connectedPlayers': connectedPlayers,
      'majorityVotedName': majorityVotedName,
      'sessionActive': sessionActive,
      'categoryId': categoryId,
      'spyCount': spyCount,
      'playersReadyCount': playersReadyCount,
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
    List<String>? spyPlayerNames,
    List<String>? connectedPlayers,
    String? majorityVotedName,
    bool? sessionActive,
    String? categoryId,
    int? spyCount,
    int? playersReadyCount,
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
      spyPlayerNames: spyPlayerNames ?? this.spyPlayerNames,
      connectedPlayers: connectedPlayers ?? this.connectedPlayers,
      majorityVotedName: majorityVotedName ?? this.majorityVotedName,
      sessionActive: sessionActive ?? this.sessionActive,
      categoryId: categoryId ?? this.categoryId,
      spyCount: spyCount ?? this.spyCount,
      playersReadyCount: playersReadyCount ?? this.playersReadyCount,
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
        spyPlayerNames,
        connectedPlayers,
        majorityVotedName,
        sessionActive,
        categoryId,
        spyCount,
        playersReadyCount,
      ];
}
