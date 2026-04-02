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
}
