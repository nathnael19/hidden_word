import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void init() {
    emit(HomeLoading());
    // Simulate some logic
    emit(HomeLoaded());
  }
}
