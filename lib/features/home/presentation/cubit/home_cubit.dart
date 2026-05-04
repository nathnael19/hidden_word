import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void init() {
    emit(HomeLoading());
    // Initializing with default theme
    emit(const HomeLoaded(selectedThemes: ['Food']));
  }

  void selectTheme(String theme) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final updatedThemes = List<String>.from(currentState.selectedThemes);
      if (updatedThemes.contains(theme)) {
        // Toggle off if more than 1 selected
        if (updatedThemes.length > 1) {
          updatedThemes.remove(theme);
        }
      } else {
        // Toggle on
        updatedThemes.add(theme);
      }
      emit(currentState.copyWith(
        selectedThemes: updatedThemes,
        isConfigValid: updatedThemes.isNotEmpty,
      ));
    }
  }

  void setTabIndex(int index) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(currentTabIndex: index));
    }
  }

  void setConnectViewMode(ConnectViewMode mode) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(connectViewMode: mode));
    }
  }

  void updatePlayersCount(int count) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(playersCount: count.clamp(3, 10)));
    }
  }

  void updateTimer(int seconds) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(timerSeconds: seconds));
    }
  }

  void updateRounds(int count) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(roundsCount: count));
    }
  }
}
