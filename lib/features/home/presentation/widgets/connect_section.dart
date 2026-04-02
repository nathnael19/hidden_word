import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/game_lobby/presentation/pages/game_lobby_page.dart';
import 'package:hidden_word/features/room_lobby/presentation/pages/room_lobby_page.dart';
import 'package:hidden_word/features/join_room/presentation/pages/join_room_page.dart';

class ConnectSection extends StatelessWidget {
  const ConnectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoaded) return const SizedBox();

        switch (state.connectViewMode) {
          case ConnectViewMode.main:
            return const GameLobbyPage();
          case ConnectViewMode.host:
            return const RoomLobbyPage();
          case ConnectViewMode.join:
            return const JoinRoomPage();
        }
      },
    );
  }
}
