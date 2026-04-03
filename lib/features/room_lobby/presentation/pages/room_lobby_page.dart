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

class RoomLobbyPage extends StatefulWidget {
  const RoomLobbyPage({super.key});

  @override
  State<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends State<RoomLobbyPage> {
  final TextEditingController _roomNameController =
      TextEditingController(text: 'SECURE CHAMBER');
  late TextEditingController _playerNameController;

  @override
  void initState() {
    super.initState();
    final netCubit = context.read<MultiplayerCubit>();
    context.read<RoomLobbyCubit>().init();
    _playerNameController = TextEditingController(text: netCubit.state.playerName);
    
    // Sync initial player name.
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
                    _buildBackNavigation(),
                    const SizedBox(height: 24),
                    if (netState.status == MultiplayerStatus.error &&
                        (netState.errorMessage?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildHostingErrorBanner(netState.errorMessage!),
                      ),
                    _buildHeader(netState),
                    const SizedBox(height: 12), // Tightened from 16
                    _buildRoomNameCard(context, netState),
                    const SizedBox(height: 12), // Tightened from 16
                    _buildPlayerNameCard(context, netState),
                    const SizedBox(height: 20), // Tightened from 32
                    _buildSettingsCard(context, roomState),
                    const SizedBox(height: 20), // Tightened from 32
                    _buildInviteSection(netState),
                    const SizedBox(height: 32), // Tightened from 40
                    _buildPlayersHeader(netState.connectedPlayers.length + 1),
                    const SizedBox(height: 24),
                    _buildPlayersGrid(netState.connectedPlayers),
                    const SizedBox(height: 48),
                    _buildStartButton(context, netState),
                    const SizedBox(height: 120), // Clearance for bottom navigation
                  ],
                ),
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

  Widget _buildHeader(MultiplayerState netState) {
    bool isHosting = netState.status == MultiplayerStatus.hosting;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.05,
              child: Icon(
                Icons.radar,
                size: 160,
                color: AppColors.primaryRed.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.broadcast_on_home,
                        size: 20,
                        color: AppColors.primaryRed.withOpacity(0.8),
                      ),
                    ),
                    _buildConnectionBadge(netState),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Host Mission',
                  style: GoogleFonts.epilogue(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isHosting 
                    ? 'Broadcasting mission frequency...' 
                    : 'Initialize secure frequency for your agents.',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomNameCard(BuildContext context, MultiplayerState netState) {
    final canEdit = netState.status != MultiplayerStatus.connecting;
    final roomName = _roomNameController.text.trim();
    final canStartHosting = canEdit && roomName.isNotEmpty;
    final isAlreadyHosting = netState.status == MultiplayerStatus.hosting;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                  'MISSION BRIEFING',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 2,
                  ),
                ),
                Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 16,
                  color: AppColors.primaryPink.withOpacity(0.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ROOM IDENTIFIER',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryPink.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _roomNameController,
                  enabled: canEdit,
                  style: GoogleFonts.epilogue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.primaryPink.withOpacity(0.8)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'HOST CODENAME',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gold.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _playerNameController,
                  style: GoogleFonts.epilogue(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.gold.withOpacity(0.8)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canStartHosting ? AppColors.primaryRed : Colors.white.withOpacity(0.05),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: canStartHosting
                        ? () async {
                            context.read<MultiplayerCubit>().prepareNewSession();
                            await context.read<MultiplayerCubit>().startHosting(_roomNameController.text.trim());
                          }
                        : null,
                    child: Text(
                      isAlreadyHosting ? 'UPDATE MISSION IDENTITY' : 'INITIALIZE BROADCAST',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // We consolidated this into _buildRoomNameCard
  Widget _buildPlayerNameCard(BuildContext context, MultiplayerState netState) {
    return const SizedBox.shrink();
  }

  Widget _buildConnectionBadge(MultiplayerState netState) {
    final isReady = netState.status == MultiplayerStatus.hosting &&
        netState.hostIp != null &&
        netState.hostPort != null;
    final isError = netState.status == MultiplayerStatus.error;
    final color = isError
        ? Colors.redAccent
        : isReady
            ? Colors.green
            : Colors.orange;
    final label = isError
        ? 'FAILED'
        : isReady
            ? 'BROADCASTING'
            : 'STARTING...';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, RoomLobbyState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                  'MISSION PARAMETERS',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 2,
                  ),
                ),
                Icon(
                  Icons.settings_input_component_rounded,
                  size: 16,
                  color: AppColors.gold.withOpacity(0.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
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
          ),
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
    final roomDisplay = netState.status == MultiplayerStatus.error
        ? 'OFFLINE'
        : netState.status == MultiplayerStatus.hosting
            ? '$ip:$port'
            : 'READYING...';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'SECURE FREQUENCY',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.3),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                roomDisplay,
                style: GoogleFonts.epilogue(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_tethering, size: 14, color: AppColors.gold.withOpacity(0.5)),
                const SizedBox(width: 8),
                Text(
                  'LOCAL NETWORK BROADCAST ACTIVE',
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gold.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Agent Roster',
          style: GoogleFonts.epilogue(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count / 10',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
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
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: MediaQuery.of(context).size.width < 380 ? 0.75 : 0.85,
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
    final bool isReady = player['status'] == 'READY' || player['status'] == 'JOINED';
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHost ? AppColors.primaryRed.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          width: isHost ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (isHost)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                ),
                child: Text(
                  'HOST',
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isHost ? Icons.security_rounded : Icons.person_rounded,
                    color: isHost ? AppColors.primaryRed.withOpacity(0.8) : Colors.white.withOpacity(0.4),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  player['name'],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.epilogue(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isReady ? Colors.green : Colors.orange).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    player['status'],
                    style: GoogleFonts.manrope(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: isReady ? Colors.greenAccent : Colors.orangeAccent,
                      letterSpacing: 1,
                    ),
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
          color: Colors.white.withOpacity(0.03),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.radio_button_unchecked_rounded,
              color: Colors.white.withOpacity(0.1),
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ENCRYPTING...',
            style: GoogleFonts.manrope(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.1),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, MultiplayerState netState) {
    final bool canStart = netState.status == MultiplayerStatus.hosting;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: canStart ? AppColors.primaryRed : Colors.white.withOpacity(0.05),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              shadowColor: AppColors.primaryRed.withOpacity(0.5),
            ),
            onPressed: canStart
                ? () async {
                    final lobbyState = context.read<RoomLobbyCubit>().state;
                    final categoryId = resolveCategoryIdFromLobby(
                      lobbyState.selectedCategories,
                    );
                    context.read<MultiplayerCubit>().prepareNewSession();
                    final connectedPlayers =
                        context.read<MultiplayerCubit>().state.connectedPlayers;
                    final hostName =
                        context.read<MultiplayerCubit>().state.playerName;
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
                  }
                : null,
            child: Text(
              'BEGIN MISSION',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'ALL AGENTS MUST BE BRIEFED BEFORE DEPLOYMENT',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.white.withOpacity(0.2),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
