import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_state.dart';
import 'package:hidden_word/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.missionParameters,
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
                _buildSectionHeader(
                  Icons.visibility_off_outlined,
                  l10n.numberOfSpies,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSpyButton(1, state.spyCount == 1, l10n),
                    const SizedBox(width: 12),
                    _buildSpyButton(2, state.spyCount == 2, l10n),
                    const SizedBox(width: 12),
                    _buildSpyButton(3, state.spyCount == 3, l10n),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  Icons.category_outlined,
                  l10n.wordCategories,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: [
                    _buildCategoryChip(
                      l10n.categoryTraditionalFood,
                      'Traditional Food',
                      state.selectedCategories.contains('Traditional Food'),
                    ),
                    _buildCategoryChip(
                      l10n.categoryHeritageSites,
                      'Heritage Sites',
                      state.selectedCategories.contains('Heritage Sites'),
                    ),
                    _buildCategoryChip(
                      l10n.categoryEthiopianCulture,
                      'Ethiopian Culture',
                      state.selectedCategories.contains('Ethiopian Culture'),
                    ),
                    _buildCategoryChip(
                      l10n.categorySports,
                      'Sports',
                      state.selectedCategories.contains('Sports'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildTimerTile(state.isTimerEnabled, l10n),
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

  Widget _buildSpyButton(int count, bool isSelected, AppLocalizations l10n) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSpyCountChanged(count),
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
            l10n.spyCountLabel(count),
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

  Widget _buildCategoryChip(String label, String value, bool isSelected) {
    return GestureDetector(
      onTap: () => onCategoryToggle(value),
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

  Widget _buildTimerTile(bool isEnabled, AppLocalizations l10n) {
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
                  l10n.discussionTimer,
                  style: GoogleFonts.epilogue(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  l10n.discussionTimerDesc,
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
