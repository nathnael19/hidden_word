import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/join_room/presentation/cubit/join_room_cubit.dart';
import 'package:hidden_word/features/join_room/presentation/cubit/join_room_state.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';

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
    context.read<JoinRoomCubit>().init();
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
    return BlocBuilder<JoinRoomCubit, JoinRoomState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackNavigation(),
              const SizedBox(height: 24),
              _buildHeader(state.isScanning),
              const SizedBox(height: 32),
              _buildScannerCard(),
              const SizedBox(height: 32),
              _buildRoomCodeCard(),
              const SizedBox(height: 24),
              _buildSecretTip(),
              const SizedBox(height: 48),
              _buildNearbyGamesHeader(),
              const SizedBox(height: 24),
              _buildNearbyGamesList(state.nearbyGames),
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

  Widget _buildScannerCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scan to Join',
                style: GoogleFonts.epilogue(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primaryPink,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Point your camera at the host's\nscreen",
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: Colors.white30,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Mock Camera Visual
                  Opacity(
                    opacity: 0.4,
                    child: Icon(
                      Icons.photo_camera_back_outlined,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  // Scanning Corners
                  ..._buildCorners(),
                  // Scanning Line
                  _buildScanningLine(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    return [
      Positioned(top: 24, left: 24, child: _Corner(angle: 0)),
      Positioned(top: 24, right: 24, child: _Corner(angle: 90)),
      Positioned(bottom: 24, left: 24, child: _Corner(angle: 270)),
      Positioned(bottom: 24, right: 24, child: _Corner(angle: 180)),
    ];
  }

  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Positioned(
          top: 40 + (200 * _scanController.value),
          left: 40,
          right: 40,
          child: Container(
            height: 2,
            color: AppColors.primaryPink.withOpacity(0.5),
          ),
        );
      },
    );
  }

  Widget _buildRoomCodeCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Code',
            style: GoogleFonts.epilogue(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: 'E.G. AX-709',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white10,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              'JOIN ROOM',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'CODES ARE CASE-SENSITIVE AND VALID FOR THE\nCURRENT SESSION ONLY.',
            style: GoogleFonts.manrope(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: Colors.white12,
              height: 1.5,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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

  Widget _buildNearbyGamesList(List<Map<String, dynamic>> games) {
    if (games.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      );
    }
    return Column(
      children: games.map((game) => _buildNearbyGameTile(game)).toList(),
    );
  }

  Widget _buildNearbyGameTile(Map<String, dynamic> game) {
    final bool isFull = game['isFull'] ?? false;
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
              Icons.home_outlined,
              color: AppColors.primaryPink.withOpacity(0.8),
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game['host'],
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${game['players']} Players',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      game['status'],
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isFull
                            ? Colors.red.withOpacity(0.5)
                            : Colors.green.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isFull
                  ? Colors.white.withOpacity(0.02)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.link,
                  size: 14,
                  color: isFull ? Colors.white10 : Colors.white60,
                ),
                const SizedBox(width: 8),
                Text(
                  'JOIN',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isFull ? Colors.white10 : Colors.white,
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
}

class _Corner extends StatelessWidget {
  final double angle;
  const _Corner({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * 3.14159 / 180,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.primaryPink.withOpacity(0.5),
              width: 3,
            ),
            left: BorderSide(
              color: AppColors.primaryPink.withOpacity(0.5),
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}
