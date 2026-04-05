import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/l10n/app_localizations.dart';

class RoomLobbyHeader extends StatelessWidget {
  final MultiplayerState netState;
  final VoidCallback onBackTap;

  const RoomLobbyHeader({
    super.key,
    required this.netState,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackNavigation(l10n),
        const SizedBox(height: 24),
        _buildHeader(netState, l10n),
      ],
    );
  }

  Widget _buildBackNavigation(AppLocalizations l10n) {
    return GestureDetector(
      onTap: onBackTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white.withOpacity(0.5),
              size: 14,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.abortMission,
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

  Widget _buildHeader(MultiplayerState netState, AppLocalizations l10n) {
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
                    _buildConnectionBadge(netState, l10n),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.hostMission,
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
                      ? l10n.broadcastingFrequency
                      : l10n.initializeFrequency,
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

  Widget _buildConnectionBadge(
    MultiplayerState netState,
    AppLocalizations l10n,
  ) {
    final isReady =
        netState.status == MultiplayerStatus.hosting &&
        netState.hostIp != null &&
        netState.hostPort != null;
    final isError = netState.status == MultiplayerStatus.error;
    final color = isError
        ? Colors.redAccent
        : isReady
        ? Colors.green
        : Colors.orange;
    final label = isError
        ? l10n.statusFailed
        : isReady
        ? l10n.statusBroadcasting
        : l10n.statusStarting;
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
}
