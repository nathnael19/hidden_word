import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/game/presentation/pages/secret_reveal_page.dart';
import 'package:hidden_word/features/join_room/presentation/widgets/join_room_hero.dart';
import 'package:hidden_word/features/join_room/presentation/widgets/nearby_games_list.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late TextEditingController _playerNameController;
  bool _navigatedToGame = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MultiplayerCubit>();
    cubit.searchHosts();
    _playerNameController = TextEditingController(text: cubit.state.playerName);
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _playerNameController.addListener(() {
      context.read<MultiplayerCubit>().setPlayerName(_playerNameController.text);
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GameCubit, GameState>(
          listenWhen: (prev, curr) => !prev.sessionActive && curr.sessionActive,
          listener: (context, gameState) {
            if (!_navigatedToGame) {
              _navigatedToGame = true;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SecretRevealPage()),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<MultiplayerCubit, MultiplayerState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackNavigation(),
                  if (state.status == MultiplayerStatus.error &&
                      (state.errorMessage?.isNotEmpty ?? false))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildErrorBanner(state.errorMessage!),
                    ),
                  if (state.status == MultiplayerStatus.connected)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildConnectedBanner(),
                    ),
                  const SizedBox(height: 12),
                  const JoinRoomHero(),
                  const SizedBox(height: 16),
                  _buildPlayerNameCard(),
                  const SizedBox(height: 20),
                  NearbyGamesList(
                    state: state,
                    scanAnimation: _scanController,
                    onJoin: (service) => context.read<MultiplayerCubit>().connectToHost(service),
                  ),
                  const SizedBox(height: 20),
                  _buildConnectivityInfoBanner(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackNavigation() {
    return GestureDetector(
      onTap: () {
        context.read<HomeCubit>().setConnectViewMode(ConnectViewMode.main);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white.withOpacity(0.5), size: 14),
            const SizedBox(width: 10),
            Text(
              'ABORT MISSION',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.greenAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Connected! Waiting for the host to start the game...',
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: Colors.greenAccent.shade100,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerNameCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AGENT PROFILE',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 2,
                  ),
                ),
                Icon(Icons.fingerprint, size: 16, color: AppColors.primaryPink.withOpacity(0.5)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('CODENAME', AppColors.primaryPink.withOpacity(0.5)),
                const SizedBox(height: 12),
                _buildTextField(_playerNameController, AppColors.primaryPink.withOpacity(0.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, Color color) {
    return Text(
      label,
      style: GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, Color focusColor) {
    return TextField(
      controller: controller,
      style: GoogleFonts.epilogue(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        hintText: 'IDENTIFY YOURSELF...',
        hintStyle: GoogleFonts.epilogue(color: Colors.white.withOpacity(0.1), fontWeight: FontWeight.w800),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: focusColor),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
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
        style: GoogleFonts.beVietnamPro(fontSize: 13, color: Colors.redAccent.shade100, height: 1.35),
      ),
    );
  }

  Widget _buildConnectivityInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
            child: const Icon(Icons.info_outline_rounded, color: AppColors.obsidian, size: 16),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.manrope(fontSize: 14, color: Colors.white.withOpacity(0.4), height: 1.5),
                children: [
                  const TextSpan(text: 'Ensure all players are connected to the '),
                  TextSpan(
                    text: 'same WiFi network',
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.8)),
                  ),
                  const TextSpan(text: ' or mobile hotspot to discover nearby games instantly.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
