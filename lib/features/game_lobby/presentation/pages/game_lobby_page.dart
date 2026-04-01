import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/game_lobby/presentation/cubit/game_lobby_cubit.dart';
import 'package:hidden_word/features/game_lobby/presentation/cubit/game_lobby_state.dart';

class GameLobbyPage extends StatefulWidget {
  const GameLobbyPage({super.key});

  @override
  State<GameLobbyPage> createState() => _GameLobbyPageState();
}

class _GameLobbyPageState extends State<GameLobbyPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    context.read<GameLobbyCubit>().init();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: _buildAppBar(),
      body: BlocBuilder<GameLobbyCubit, GameLobbyState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildHostCard(),
                const SizedBox(height: 24),
                _buildDeviceStatusSection(),
                const SizedBox(height: 32),
                _buildJoinCard(),
                const SizedBox(height: 24),
                _buildNearbyGamesSection(state),
                const SizedBox(height: 32),
                _buildWifiInfoAlert(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.sort, color: Colors.white70),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ስውር', style: GoogleFonts.epilogue(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(width: 4),
          Text('ቃል', style: GoogleFonts.epilogue(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPink)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceContainerHigh,
            backgroundImage: const AssetImage('assets/ritualist_avatar.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('ስውር', style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2)),
            const SizedBox(width: 4),
            Text('ቃል', style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryPink, letterSpacing: 1.2)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how you want to join the digital ritual.',
          style: GoogleFonts.beVietnamPro(fontSize: 14, color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildHostCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primaryRed.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.sensors, size: 160, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fort_rounded, color: AppColors.gold, size: 32),
                const SizedBox(height: 12),
                Text('Host a Game', style: GoogleFonts.epilogue(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Create a room for others to join.', style: GoogleFonts.beVietnamPro(fontSize: 13, color: Colors.white.withOpacity(0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatusSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR DEVICE', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white30, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text("Abebe's Phone", style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              _buildStatusBadge('WAITING', Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          Text('Waiting for players...', style: GoogleFonts.beVietnamPro(fontSize: 14, color: Colors.white60)),
          const SizedBox(height: 16),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10, width: 1.5, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_alt_1_outlined, color: Colors.white24, size: 32),
                const SizedBox(height: 8),
                Text('NO PLAYERS JOINED YET', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white12, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.05,
              child: Icon(Icons.travel_explore_rounded, size: 160, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sensors, color: AppColors.primaryRed, size: 32),
                const SizedBox(height: 12),
                Text('Join a Game', style: GoogleFonts.epilogue(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Scan the local network for games.', style: GoogleFonts.beVietnamPro(fontSize: 13, color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyGamesSection(GameLobbyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nearby Games', style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Row(
              children: [
                Text('Auto-scanning', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white24)),
                const SizedBox(width: 4),
                const Icon(Icons.sync, size: 14, color: Colors.white24),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state is GameLobbyScanning)
          const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)))
        else if (state is GameLobbyReady)
          ...state.nearbyGames.map((game) => _buildGameItem(game)).toList(),
      ],
    );
  }

  Widget _buildGameItem(Map<String, String> game) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Icon(
              game['host']!.contains('Yonas') ? Icons.door_front_door_outlined : Icons.sports_esports_outlined,
              color: AppColors.primaryPink.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game['host']!, style: GoogleFonts.epilogue(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(game['status']!, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white24, letterSpacing: 0.5)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildWifiInfoAlert() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.gold,
            radius: 12,
            child: Icon(Icons.info_outline, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.white60, height: 1.5),
                children: [
                  const TextSpan(text: 'Ensure all players are connected to the '),
                  TextSpan(text: 'same WiFi network', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' or mobile hotspot to discover nearby games instantly.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return FadeTransition(
      opacity: _pulseController,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w900, color: color, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}
