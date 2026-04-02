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
import 'package:hidden_word/features/multiplayer/data/models/network_message.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/pages/secret_reveal_page.dart';

class RoomLobbyPage extends StatefulWidget {
  const RoomLobbyPage({super.key});

  @override
  State<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends State<RoomLobbyPage> {
  @override
  void initState() {
    super.initState();
    context.read<RoomLobbyCubit>().init();
    // Start broadcasting the room on the local network immediately
    context.read<MultiplayerCubit>().startHosting('My Room');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomLobbyCubit, RoomLobbyState>(
      builder: (context, roomState) {
        return BlocBuilder<MultiplayerCubit, MultiplayerState>(
          builder: (context, netState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackNavigation(),
                  const SizedBox(height: 24),
                  _buildHeader(netState),
                  const SizedBox(height: 32),
                  _buildSettingsCard(context, roomState),
                  const SizedBox(height: 32),
                  _buildInviteSection(netState),
                  const SizedBox(height: 40),
                  _buildPlayersHeader(netState.connectedPlayers.length + 1),
                  const SizedBox(height: 24),
                  _buildPlayersGrid(netState.connectedPlayers),
                  const SizedBox(height: 48),
                  _buildStartButton(context, netState),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBackNavigation() {
    return GestureDetector(
      onTap: () {
        context.read<HomeCubit>().setConnectViewMode(ConnectViewMode.main);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Text(
            'BACK TO LOBBY',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildHeader(MultiplayerState netState) {
    final isHosting = netState.status == MultiplayerStatus.hosting;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'THE THRONE',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white24,
                letterSpacing: 2,
              ),
            ),
            _buildConnectionBadge(isHosting),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'ስውር',
              style: GoogleFonts.epilogue(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ቅዱሳን',
              style: GoogleFonts.epilogue(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryRed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectionBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? 'BROADCASTING' : 'STARTING...',
            style: GoogleFonts.manrope(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: isActive ? Colors.green : Colors.orange,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, RoomLobbyState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.visibility_off_outlined, 'NUMBER OF SPIES'),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSpyButton(context, 1, state.spyCount == 1),
              const SizedBox(width: 12),
              _buildSpyButton(context, 2, state.spyCount == 2),
              const SizedBox(width: 12),
              _buildSpyButton(context, 3, state.spyCount == 3),
            ],
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(Icons.category_outlined, 'WORD CATEGORIES'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              _buildCategoryChip(
                context,
                'Traditional Food',
                state.selectedCategories.contains('Traditional Food'),
              ),
              _buildCategoryChip(
                context,
                'Heritage Sites',
                state.selectedCategories.contains('Heritage Sites'),
              ),
              _buildCategoryChip(
                context,
                'Ethiopian Culture',
                state.selectedCategories.contains('Ethiopian Culture'),
              ),
              _buildCategoryChip(
                context,
                'Sports',
                state.selectedCategories.contains('Sports'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildTimerTile(context, state.isTimerEnabled),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white24),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.white24,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSpyButton(BuildContext context, int count, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<RoomLobbyCubit>().updateSpyCount(count),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryRed
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: isSelected ? Border.all(color: Colors.white24) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$count ${count == 1 ? 'Spy' : 'Spies'}',
            style: GoogleFonts.epilogue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => context.read<RoomLobbyCubit>().toggleCategory(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check_circle, size: 14, color: Colors.black),
            if (isSelected) const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerTile(BuildContext context, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.gold, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '60s Discussion Timer',
                  style: GoogleFonts.epilogue(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Keep the pressure high',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: Colors.white30,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (val) => context.read<RoomLobbyCubit>().toggleTimer(val),
            activeThumbColor: AppColors.primaryRed,
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection(MultiplayerState netState) {
    final ip = netState.hostIp ?? '...';
    final port = netState.hostPort?.toString() ?? '...';
    final roomDisplay = netState.status == MultiplayerStatus.hosting ? '$ip:$port' : 'Starting...';
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ROOM ADDRESS',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white24,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  roomDisplay,
                  style: GoogleFonts.epilogue(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'LOCAL WIFI · AUTO-DISCOVERABLE',
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryPink.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_tethering, color: AppColors.gold, size: 36),
              const SizedBox(height: 8),
              Text(
                'WiFi LAN',
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gold.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'ተጫዋቾች',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($count/10)',
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white30,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AWAITING CONNECTIONS...',
              style: GoogleFonts.manrope(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: Colors.green,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayersGrid(List<String> connectedPlayers) {
    // +1 for the host (this device)
    final totalCount = connectedPlayers.length + 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: totalCount < 4 ? 4 : totalCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildPlayerCard({'name': 'You (Host)', 'status': 'READY', 'isHost': true});
        }
        if (index < totalCount) {
          return _buildPlayerCard({'name': connectedPlayers[index - 1], 'status': 'JOINED', 'isHost': false});
        }
        return _buildWaitingSlot();
      },
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player) {
    final bool isHost = player['isHost'] ?? false;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: isHost
            ? Border.all(
                color: AppColors.primaryPink.withOpacity(0.5),
                width: 1.5,
              )
            : null,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (isHost)
            Positioned(
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'HOST',
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white10,
                  backgroundImage: const AssetImage(
                    'assets/ritualist_avatar.png',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  player['name'],
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  player['status'],
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: player['status'] == 'READY'
                        ? Colors.green
                        : Colors.white24,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingSlot() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add_alt_1_outlined,
            color: Colors.white12,
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            'WAITING...',
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Colors.white12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, MultiplayerState netState) {
    final bool canStart = netState.status == MultiplayerStatus.hosting;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          GestureDetector(
            onTap: canStart
                ? () async {
                    // Tell all clients game is starting
                    context.read<MultiplayerCubit>().broadcastToClients(
                          NetworkMessage(
                            type: NetworkMessageType.action,
                            payload: {'action': 'START_GAME', 'category': 'food'},
                          ).encode(),
                        );
                    // Init host's game with a real random word
                    await context.read<GameCubit>().init(6);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SecretRevealPage()),
                      );
                    }
                  }
                : null,
            child: Container(
              width: double.infinity,
              height: 72,
              decoration: BoxDecoration(
                color: canStart
                    ? AppColors.primaryPink.withOpacity(0.85)
                    : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
                boxShadow: canStart
                    ? [
                        BoxShadow(
                          color: AppColors.primaryPink.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                'ጀምር (START GAME)',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: canStart ? Colors.black.withOpacity(0.8) : Colors.white24,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ALL PLAYERS MUST BE READY BEFORE THE HUNT BEGINS',
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
