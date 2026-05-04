import 'package:equatable/equatable.dart';

enum ConnectViewMode { main, host, join }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> selectedThemes;
  final int currentTabIndex;
  final ConnectViewMode connectViewMode;
  final int playersCount;
  final int timerSeconds;
  final int roundsCount;
  final bool isConfigValid;

  const HomeLoaded({
    this.selectedThemes = const ['Food'],
    this.currentTabIndex = 0,
    this.connectViewMode = ConnectViewMode.main,
    this.playersCount = 6,
    this.timerSeconds = 60,
    this.roundsCount = 5,
    this.isConfigValid = true,
  });

  HomeLoaded copyWith({
    List<String>? selectedThemes,
    int? currentTabIndex,
    ConnectViewMode? connectViewMode,
    int? playersCount,
    int? timerSeconds,
    int? roundsCount,
    bool? isConfigValid,
  }) {
    return HomeLoaded(
      selectedThemes: selectedThemes ?? this.selectedThemes,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      connectViewMode: connectViewMode ?? this.connectViewMode,
      playersCount: playersCount ?? this.playersCount,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      roundsCount: roundsCount ?? this.roundsCount,
      isConfigValid: isConfigValid ?? this.isConfigValid,
    );
  }

  @override
  List<Object> get props => [
        selectedThemes,
        currentTabIndex,
        connectViewMode,
        playersCount,
        timerSeconds,
        roundsCount,
        isConfigValid,
      ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
