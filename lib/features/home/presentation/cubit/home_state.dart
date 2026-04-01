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
  const HomeLoaded({this.selectedTheme = 'Food'});

  HomeLoaded copyWith({
    String? selectedTheme,
  }) {
    return HomeLoaded(
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }

  @override
  List<Object> get props => [selectedTheme];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
