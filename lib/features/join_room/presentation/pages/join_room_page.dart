import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/features/game/presentation/pages/secret_reveal_page.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    context.read<MultiplayerCubit>().searchHosts();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MultiplayerCubit, MultiplayerState>(
      listener: (context, state) {
        if (state.status == MultiplayerStatus.connected) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SecretRevealPage()),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackNavigation(),
              const SizedBox(height: 24),
              _buildHeader(state.status == MultiplayerStatus.searching),
              const SizedBox(height: 32),
              _buildSecretTip(),
              const SizedBox(height: 32),
              _buildNearbyGamesHeader(),
              const SizedBox(height: 24),
              _buildNearbyGamesList(context, state),
              const SizedBox(height: 40),
            ],
          ),
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




  Widget _buildHeader(bool isScanning) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLogoBox('ስ'),
            const SizedBox(width: 4),
            _buildLogoBox('ው'),
            const SizedBox(width: 4),
            _buildLogoBox('ር'),
            const SizedBox(width: 12),
            _buildLogoBox('ቃ'),
            const SizedBox(width: 4),
            _buildLogoBox('ል'),
            const SizedBox(width: 4),
            _buildLogoBox(' '),
            const SizedBox(width: 4),
            _buildLogoBox(' '),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '(JOIN GAME)',
          style: GoogleFonts.epilogue(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryPink.withOpacity(0.8),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            RotationTransition(
              turns: _scanController,
              child: const Icon(
                Icons.lens_blur_rounded,
                size: 16,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'SCANNING FOR NEARBY GAMES...',
              style: GoogleFonts.manrope(
                fontSize: 10,
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

  Widget _buildLogoBox(String char) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: GoogleFonts.epilogue(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }


  Widget _buildSecretTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SECRET TIP',
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep your identity hidden until the\nmoment of truth.',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: Colors.white60,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyGamesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Nearby Games',
          style: GoogleFonts.epilogue(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'WIFI DISCOVERY ACTIVE',
          style: GoogleFonts.manrope(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: Colors.white12,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyGamesList(BuildContext context, MultiplayerState state) {
    if (state.status == MultiplayerStatus.searching && state.discoveredServices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
              const SizedBox(height: 16),
              Text(
                'SCANNING FOR NEARBY ROOMS...',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface.withOpacity(0.3),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (state.discoveredServices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'No rooms found nearby.\nMake sure you\'re on the same WiFi.',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: AppColors.onSurface.withOpacity(0.3),
              height: 1.6,
            ),
          ),
        ),
      );
    }
    return Column(
      children: state.discoveredServices.map((service) {
        return _buildNearbyGameTile(
          context: context,
          host: service.name,
          onJoin: () => context.read<MultiplayerCubit>().connectToHost(service),
        );
      }).toList(),
    );
  }

  Widget _buildNearbyGameTile({
    required BuildContext context,
    required String host,
    required VoidCallback onJoin,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.wifi,
              color: Colors.greenAccent.withOpacity(0.8),
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  host,
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'OPEN · LOCAL WIFI',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.greenAccent.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onJoin,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, size: 14, color: Colors.white60),
                  const SizedBox(width: 8),
                  Text(
                    'JOIN',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

