import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/home/presentation/pages/home_page.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/l10n/app_localizations.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          final isSpyVictory = !state.spyCaught;
          final primaryColor = isSpyVictory
              ? AppColors.primaryRed
              : Colors.greenAccent;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  _buildMissionHeader(primaryColor, l10n),
                  const SizedBox(height: 40),
                  _buildVictorCard(isSpyVictory, l10n),
                  const SizedBox(height: 48),
                  _buildResultsSummary(state, isSpyVictory, l10n),
                  const SizedBox(height: 64),
                  _buildActionButtons(context, l10n),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMissionHeader(Color color, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.missionComplete,
          style: GoogleFonts.epilogue(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.truthRevealed,
          style: GoogleFonts.epilogue(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildVictorCard(bool isSpyVictory, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: (isSpyVictory ? AppColors.primaryRed : Colors.greenAccent)
              .withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isSpyVictory ? AppColors.primaryRed : Colors.greenAccent)
                .withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isSpyVictory ? Icons.vpn_key_rounded : Icons.gavel_rounded,
            size: 64,
            color: isSpyVictory ? AppColors.primaryRed : Colors.greenAccent,
          ),
          const SizedBox(height: 24),
          Text(
            isSpyVictory ? l10n.spyWins : l10n.citizensWin,
            style: GoogleFonts.epilogue(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSpyVictory ? l10n.missionFailed : l10n.justicePrevailed,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface.withOpacity(0.4),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSummary(
    GameState state,
    bool isSpyVictory,
    AppLocalizations l10n,
  ) {
    final spyNamesStr = state.spyPlayerNames.join(", ");

    final resultDesc = isSpyVictory
        ? l10n.spyEscapedDesc(state.majorityVotedName ?? l10n.unknown)
        : l10n.spyCaughtDesc(spyNamesStr);

    return Column(
      children: [
        _buildSummaryRow(l10n.spyLabel, spyNamesStr, AppColors.primaryRed),
        const SizedBox(height: 16),
        _buildSummaryRow(
          l10n.secretWordLabel,
          state.secretWord,
          AppColors.gold,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            resultDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.6,
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface.withOpacity(0.3),
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.epilogue(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    final isHost =
        context.read<MultiplayerCubit>().state.status ==
        MultiplayerStatus.hosting;

    return Column(
      children: [
        if (isHost)
          GestureDetector(
            onTap: () => context.read<GameCubit>().resetGame(),
            child: Container(
              width: double.infinity,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  l10n.playAgain,
                  style: GoogleFonts.epilogue(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            context.read<MultiplayerCubit>().stopMultiplayer();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
          child: Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(
              child: Text(
                l10n.mainMenu,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
