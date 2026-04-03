import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_state.dart';

class MissionParametersCard extends StatelessWidget {
  final RoomLobbyState state;
  final Function(int) onSpyCountChanged;
  final Function(String) onCategoryToggle;
  final Function(bool) onTimerToggle;

  const MissionParametersCard({
    super.key,
    required this.state,
    required this.onSpyCountChanged,
    required this.onCategoryToggle,
    required this.onTimerToggle,
  });

  @override
  Widget build(BuildContext context) {
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
                    _buildSpyButton(1, state.spyCount == 1),
                    const SizedBox(width: 12),
                    _buildSpyButton(2, state.spyCount == 2),
                    const SizedBox(width: 12),
                    _buildSpyButton(3, state.spyCount == 3),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(Icons.category_outlined, 'WORD CATEGORIES'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: [
                    _buildCategoryChip('Traditional Food', state.selectedCategories.contains('Traditional Food')),
                    _buildCategoryChip('Heritage Sites', state.selectedCategories.contains('Heritage Sites')),
                    _buildCategoryChip('Ethiopian Culture', state.selectedCategories.contains('Ethiopian Culture')),
                    _buildCategoryChip('Sports', state.selectedCategories.contains('Sports')),
                  ],
                ),
                const SizedBox(height: 32),
                _buildTimerTile(state.isTimerEnabled),
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

  Widget _buildSpyButton(int count, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSpyCountChanged(count),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryRed : Colors.white.withOpacity(0.05),
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

  Widget _buildCategoryChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => onCategoryToggle(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) const Icon(Icons.check_circle, size: 14, color: Colors.black),
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

  Widget _buildTimerTile(bool isEnabled) {
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
            onChanged: onTimerToggle,
            activeThumbColor: AppColors.primaryRed,
          ),
        ],
      ),
    );
  }
}
