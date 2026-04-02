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

  const HomeLoaded({
    this.selectedTheme = 'Food',
    this.currentTabIndex = 0,
    this.connectViewMode = ConnectViewMode.main,
  });

  HomeLoaded copyWith({
    String? selectedTheme,
    int? currentTabIndex,
    ConnectViewMode? connectViewMode,
  }) {
    return HomeLoaded(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      connectViewMode: connectViewMode ?? this.connectViewMode,
    );
  }

  @override
  List<Object> get props => [selectedTheme, currentTabIndex, connectViewMode];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
