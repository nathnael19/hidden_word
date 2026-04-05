import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:hidden_word/features/settings/presentation/cubit/settings_state.dart';
import 'package:hidden_word/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  _buildHeader(l10n),
                  const SizedBox(height: 40),
                  _buildSectionTitle(l10n.gameplayAccessibility),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    icon: Icons.language_rounded,
                    title: l10n.languageLabel,
                    subtitle: state.language == 'am'
                        ? l10n.amharicSubtitle
                        : l10n.englishSubtitle,
                    trailing: _buildLanguageToggle(context, state.language),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    icon: Icons.volume_up_rounded,
                    title: l10n.soundEffects,
                    subtitle: l10n.soundEffectsSubtitle,
                    trailing: _buildSwitch(
                      value: state.isSoundEnabled,
                      onChanged: (_) =>
                          context.read<SettingsCubit>().toggleSound(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    icon: Icons.vibration_rounded,
                    title: l10n.hapticFeedback,
                    subtitle: l10n.hapticFeedbackSubtitle,
                    trailing: _buildSwitch(
                      value: state.isHapticEnabled,
                      onChanged: (_) =>
                          context.read<SettingsCubit>().toggleHaptic(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    icon: Icons.timer_outlined,
                    title: l10n.gameTimer,
                    subtitle: l10n.gameTimerSubtitle,
                    trailing: _buildSwitch(
                      value: state.isTimerVisible,
                      onChanged: (_) =>
                          context.read<SettingsCubit>().toggleTimer(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(l10n.knowledgeBase),
                  const SizedBox(height: 16),
                  _buildLinkCard(
                    icon: Icons.history_edu_rounded,
                    title: l10n.credits,
                  ),
                  const SizedBox(height: 16),
                  _buildLinkCard(
                    icon: Icons.groups_rounded,
                    title: l10n.aboutDevelopers,
                  ),
                  const SizedBox(height: 40),
                  _buildRitualCard(l10n),
                  const SizedBox(height: 120), // Bottom nav space
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsTitle,
              style: GoogleFonts.epilogue(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.personalizeRitual,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface.withValues(alpha: 0.4),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: AppColors.onSurface.withValues(alpha: 0.3),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.obsidian,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryRed.withValues(alpha: 0.8),
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.epilogue(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: AppColors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildLinkCard({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryRed.withValues(alpha: 0.8),
            size: 24,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context, String currentLang) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.obsidian,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.read<SettingsCubit>().setLanguage('am'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: currentLang == 'am'
                    ? AppColors.primaryRed.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'አማርኛ',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: currentLang == 'am'
                      ? AppColors.primaryRed
                      : AppColors.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => context.read<SettingsCubit>().setLanguage('en'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: currentLang == 'en'
                    ? AppColors.primaryRed.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'EN',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: currentLang == 'en'
                      ? AppColors.primaryRed
                      : AppColors.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: AppColors.primaryRed,
      inactiveTrackColor: AppColors.obsidian,
    );
  }

  Widget _buildRitualCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(36),
        image: DecorationImage(
          image: const AssetImage(
            'assets/ritualist_avatar.png',
          ), // Fallback pattern
          opacity: 0.05,
          colorFilter: ColorFilter.mode(
            AppColors.primaryRed.withValues(alpha: 0.1),
            BlendMode.srcIn,
          ),
          alignment: Alignment.bottomRight,
          fit: BoxFit.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ritualContinues,
            style: GoogleFonts.epilogue(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: AppColors.gold.withValues(alpha: 0.9),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.ritualContinuesSubtitle,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              color: AppColors.onSurface.withValues(alpha: 0.5),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
