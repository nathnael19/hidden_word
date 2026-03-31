import 'package:get_it/get_it.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Home
  // Cubit
  sl.registerFactory(() => HomeCubit());

  // Use cases

  // Repositories

  // Data sources

  //! Core
  // NetworkInfo

  //! External
  // SharedPreferences, http.Client, etc.
}
