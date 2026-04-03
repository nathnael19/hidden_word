import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/pages/secret_reveal_page.dart';

class GameConfigSection extends StatelessWidget {
  final HomeLoaded state;
  const GameConfigSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingsGrid(context, state.timerSeconds, state.roundsCount),
        const SizedBox(height: 32),
        _buildStartAction(context, state.playersCount),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'PREPARE YOUR POKER FACE',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface.withOpacity(0.3),
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsGrid(BuildContext context, int timer, int rounds) {
    return Row(
      children: [
        Expanded(
          child: _SettingCard(
            label: 'TIMER',
            value: '${timer}s',
            icon: Icons.timer,
            iconColor: Colors.green,
            onTap: () {
              final times = [45, 60, 90, 120];
              final currentIndex = times.indexOf(timer);
              final nextIndex = (currentIndex + 1) % times.length;
              context.read<HomeCubit>().updateTimer(times[nextIndex]);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SettingCard(
            label: 'ROUNDS',
            value: '$rounds Wins',
            icon: Icons.military_tech,
            iconColor: AppColors.primaryRed,
            onTap: () {
              final roundsList = [3, 5, 7, 10];
              final currentIndex = roundsList.indexOf(rounds);
              final nextIndex = (currentIndex + 1) % roundsList.length;
              context.read<HomeCubit>().updateRounds(roundsList[nextIndex]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStartAction(BuildContext context, int count) {
    return GestureDetector(
      onTap: () async {
        final themeToCategory = {
          'Food': 'food',
          'Transport': 'transport',
          'Culture': 'culture',
          'Student': 'student',
        };
        final categoryId = themeToCategory[state.selectedTheme] ?? 'food';
        await context.read<GameCubit>().init(count, categoryId: categoryId);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecretRevealPage()),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.primaryPink.withOpacity(0.85),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 80),
              Expanded(
                child: Center(
                  child: Text(
                    'START MISSION',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withOpacity(0.8),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$count',
                      style: GoogleFonts.epilogue(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.black.withOpacity(0.8),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SettingCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.onSurface.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface.withOpacity(0.3),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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
