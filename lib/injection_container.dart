import 'package:get_it/get_it.dart';
import 'package:hidden_word/features/game_lobby/presentation/cubit/game_lobby_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/join_room/presentation/cubit/join_room_cubit.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // Cubits
  sl.registerFactory(() => HomeCubit());
  sl.registerFactory(() => GameLobbyCubit());
  sl.registerFactory(() => RoomLobbyCubit());
  sl.registerFactory(() => JoinRoomCubit());
  sl.registerLazySingleton(() => GameCubit());
  sl.registerFactory(() => MultiplayerCubit(gameCubit: sl()));

  // Use cases

  // Repositories

  // Data sources

  //! Core
  // NetworkInfo

  //! External
  // SharedPreferences, http.Client, etc.
}
