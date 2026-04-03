import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/features/join_room/presentation/widgets/radar_scanner_widget.dart';

class NearbyGamesList extends StatelessWidget {
  final MultiplayerState state;
  final Animation<double> scanAnimation;
  final Function(BonsoirService) onJoin;

  const NearbyGamesList({
    super.key,
    required this.state,
    required this.scanAnimation,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNearbyGamesHeader(),
        const SizedBox(height: 12),
        _buildNearbyGamesList(context),
      ],
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
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Row(
          children: [
            Text(
              'Auto-scanning',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.sync, size: 14, color: Colors.white.withOpacity(0.25)),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbyGamesList(BuildContext context) {
    if (state.status == MultiplayerStatus.searching && state.discoveredServices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: RadarScannerWidget(animation: scanAnimation),
              ),
              const SizedBox(height: 24),
              Text(
                'INTERCEPTING SIGNALS...',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.green.withOpacity(0.3),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.discoveredServices.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.signal_cellular_connected_no_internet_4_bar_rounded,
                size: 48,
                color: Colors.white.withOpacity(0.05),
              ),
              const SizedBox(height: 20),
              Text(
                'NO ROOMS LOCATED',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.2),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ensure the Host is visible on your\nnetwork or local hotspot.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.15),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: state.discoveredServices.map((service) {
        return _NearbyGameTile(
          host: service.name,
          onJoin: () => onJoin(service),
        );
      }).toList(),
    );
  }
}

class _NearbyGameTile extends StatelessWidget {
  final String host;
  final VoidCallback onJoin;

  const _NearbyGameTile({required this.host, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onJoin,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    host.toLowerCase().contains('room') ? Icons.door_front_door_rounded : Icons.sports_esports_rounded,
                    color: Colors.white.withOpacity(0.4),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SIGNAL STABLE • READY TO DEPLOY',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.greenAccent.withOpacity(0.3),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: Colors.white.withOpacity(0.15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
