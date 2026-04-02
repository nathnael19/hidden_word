import 'package:equatable/equatable.dart';

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
  const HomeLoaded({
    this.selectedTheme = 'Food',
    this.currentTabIndex = 0,
  });

  HomeLoaded copyWith({
    String? selectedTheme,
    int? currentTabIndex,
  }) {
    return HomeLoaded(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  @override
  List<Object> get props => [selectedTheme, currentTabIndex];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
