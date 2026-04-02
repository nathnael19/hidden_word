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
  final String selectedTheme;
  final int currentTabIndex;
  final ConnectViewMode connectViewMode;
  final int playersCount;
  final int timerSeconds;
  final int roundsCount;

  const HomeLoaded({
    this.selectedTheme = 'Food',
    this.currentTabIndex = 0,
    this.connectViewMode = ConnectViewMode.main,
    this.playersCount = 6,
    this.timerSeconds = 60,
    this.roundsCount = 5,
  });

  HomeLoaded copyWith({
    String? selectedTheme,
    int? currentTabIndex,
    ConnectViewMode? connectViewMode,
    int? playersCount,
    int? timerSeconds,
    int? roundsCount,
  }) {
    return HomeLoaded(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      connectViewMode: connectViewMode ?? this.connectViewMode,
      playersCount: playersCount ?? this.playersCount,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      roundsCount: roundsCount ?? this.roundsCount,
    );
  }

  @override
  List<Object> get props => [
        selectedTheme,
        currentTabIndex,
        connectViewMode,
        playersCount,
        timerSeconds,
        roundsCount,
      ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
