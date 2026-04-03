import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_cubit.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_state.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/core/game/lobby_category_mapping.dart';
import 'package:hidden_word/features/game/presentation/pages/secret_reveal_page.dart';
import 'package:hidden_word/features/room_lobby/presentation/widgets/agent_roster_section.dart';
import 'package:hidden_word/features/room_lobby/presentation/widgets/mission_briefing_card.dart';
import 'package:hidden_word/features/room_lobby/presentation/widgets/mission_parameters_card.dart';
import 'package:hidden_word/features/room_lobby/presentation/widgets/room_lobby_header.dart';
import 'package:hidden_word/features/room_lobby/presentation/widgets/secure_frequency_card.dart';
import 'package:hidden_word/features/room_lobby/presentation/widgets/start_mission_button.dart';

class RoomLobbyPage extends StatefulWidget {
  const RoomLobbyPage({super.key});

  @override
  State<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends State<RoomLobbyPage> {
  final TextEditingController _roomNameController = TextEditingController(text: 'SECURE CHAMBER');
  late TextEditingController _playerNameController;

  @override
  void initState() {
    super.initState();
    final netCubit = context.read<MultiplayerCubit>();
    context.read<RoomLobbyCubit>().init();
    _playerNameController = TextEditingController(text: netCubit.state.playerName);
    
    _playerNameController.addListener(() {
      context.read<MultiplayerCubit>().setPlayerName(_playerNameController.text);
    });
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomLobbyCubit, RoomLobbyState>(
      builder: (context, roomState) {
        return BlocBuilder<MultiplayerCubit, MultiplayerState>(
          builder: (context, netState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoomLobbyHeader(
                      netState: netState,
                      onBackTap: () => context.read<HomeCubit>().setConnectViewMode(ConnectViewMode.main),
                    ),
                    const SizedBox(height: 24),
                    if (netState.status == MultiplayerStatus.error &&
                        (netState.errorMessage?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildHostingErrorBanner(netState.errorMessage!),
                      ),
                    MissionBriefingCard(
                      roomNameController: _roomNameController,
                      playerNameController: _playerNameController,
                      netState: netState,
                      onStartHosting: () async {
                        context.read<MultiplayerCubit>().prepareNewSession();
                        await context.read<MultiplayerCubit>().startHosting(_roomNameController.text.trim());
                      },
                    ),
                    const SizedBox(height: 20),
                    MissionParametersCard(
                      state: roomState,
                      onSpyCountChanged: (count) => context.read<RoomLobbyCubit>().updateSpyCount(count),
                      onCategoryToggle: (label) => context.read<RoomLobbyCubit>().toggleCategory(label),
                      onTimerToggle: (val) => context.read<RoomLobbyCubit>().toggleTimer(val),
                    ),
                    const SizedBox(height: 20),
                    SecureFrequencyCard(netState: netState),
                    const SizedBox(height: 32),
                    AgentRosterSection(
                      connectedPlayers: netState.connectedPlayers,
                      localPlayerName: netState.playerName,
                    ),
                    const SizedBox(height: 48),
                    StartMissionButton(
                      netState: netState,
                      onStartTap: () async {
                        final lobbyState = context.read<RoomLobbyCubit>().state;
                        final categoryId = resolveCategoryIdFromLobby(lobbyState.selectedCategories);
                        context.read<MultiplayerCubit>().prepareNewSession();
                        final connectedPlayers = context.read<MultiplayerCubit>().state.connectedPlayers;
                        final hostName = context.read<MultiplayerCubit>().state.playerName;
                        final totalRoster = [hostName, ...connectedPlayers];

                        await context.read<GameCubit>().init(
                          totalRoster.length,
                          categoryId: categoryId,
                          connectedPlayers: totalRoster,
                          spyCount: lobbyState.spyCount,
                        );
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SecretRevealPage()),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHostingErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.35)),
      ),
      child: Text(
        message,
        style: GoogleFonts.beVietnamPro(
          fontSize: 13,
          color: Colors.redAccent.shade100,
          height: 1.35,
        ),
      ),
    );
  }
}
