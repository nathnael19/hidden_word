import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';

class MissionBriefingCard extends StatelessWidget {
  final TextEditingController roomNameController;
  final TextEditingController playerNameController;
  final MultiplayerState netState;
  final VoidCallback onStartHosting;

  const MissionBriefingCard({
    super.key,
    required this.roomNameController,
    required this.playerNameController,
    required this.netState,
    required this.onStartHosting,
  });

  @override
  Widget build(BuildContext context) {
    final canEdit = netState.status != MultiplayerStatus.connecting;
    final roomName = roomNameController.text.trim();
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
                _buildFieldLabel('ROOM IDENTIFIER', AppColors.primaryPink.withOpacity(0.5)),
                const SizedBox(height: 12),
                _buildTextField(roomNameController, canEdit, AppColors.primaryPink.withOpacity(0.8)),
                const SizedBox(height: 24),
                _buildFieldLabel('HOST CODENAME', AppColors.gold.withOpacity(0.5)),
                const SizedBox(height: 12),
                _buildTextField(playerNameController, true, AppColors.gold.withOpacity(0.8)),
                const SizedBox(height: 24),
                _buildHostingButton(canStartHosting, isAlreadyHosting),
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

  Widget _buildTextField(TextEditingController controller, bool enabled, Color focusColor) {
    return TextField(
      controller: controller,
      enabled: enabled,
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
          borderSide: BorderSide(color: focusColor),
        ),
      ),
    );
  }

  Widget _buildHostingButton(bool canStartHosting, bool isAlreadyHosting) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: canStartHosting ? AppColors.primaryRed : Colors.white.withOpacity(0.05),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: canStartHosting ? onStartHosting : null,
        child: Text(
          isAlreadyHosting ? 'UPDATE MISSION IDENTITY' : 'INITIALIZE BROADCAST',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
