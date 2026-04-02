import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void init() {
    emit(HomeLoading());
    // Initializing with default theme
    emit(const HomeLoaded(selectedTheme: 'Food'));
  }

  void selectTheme(String theme) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(selectedTheme: theme));
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
