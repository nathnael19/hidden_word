import 'package:get_it/get_it.dart';
import 'package:hidden_word/features/game_lobby/presentation/cubit/game_lobby_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Home
  // Cubit
  sl.registerFactory(() => HomeCubit());
  sl.registerFactory(() => GameLobbyCubit());

  // Use cases

  // Repositories

  // Data sources

  //! Core
  // NetworkInfo

  //! External
  // SharedPreferences, http.Client, etc.
}
