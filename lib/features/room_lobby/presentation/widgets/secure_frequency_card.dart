import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/l10n/app_localizations.dart';

class SecureFrequencyCard extends StatelessWidget {
  final MultiplayerState netState;

  const SecureFrequencyCard({super.key, required this.netState});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ip = netState.hostIp ?? '...';
    final port = netState.hostPort?.toString() ?? '...';
    final roomDisplay = netState.status == MultiplayerStatus.error
        ? l10n.statusOffline
        : netState.status == MultiplayerStatus.hosting
        ? '$ip:$port'
        : l10n.statusReadying;

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
              l10n.secureFrequency,
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
                Icon(
                  Icons.wifi_tethering,
                  size: 14,
                  color: AppColors.gold.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.localNetworkBroadcastActive,
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
}
