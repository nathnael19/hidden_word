import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';

class StartMissionButton extends StatelessWidget {
  final MultiplayerState netState;
  final VoidCallback onStartTap;

  const StartMissionButton({
    super.key,
    required this.netState,
    required this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: canStart ? onStartTap : null,
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
