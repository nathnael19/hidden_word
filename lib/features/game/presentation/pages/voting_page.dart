import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/game/presentation/pages/results_page.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/l10n/app_localizations.dart';

class VotingPage extends StatelessWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {
          if (state.phase == GamePhase.results) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ResultsPage()),
            );
          }
        },
        builder: (context, state) {
          final mpState = context.watch<MultiplayerCubit>().state;
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(l10n),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        _buildVotingStatus(l10n),
                        const SizedBox(height: 40),
                        _buildPlayerGrid(
                          context,
                          state,
                          mpState.playerName,
                          l10n,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _buildBottomBranding(l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.votingStatus,
                    style: GoogleFonts.epilogue(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.whoIsTheSpy,
                    style: GoogleFonts.epilogue(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              _buildDecisionIndicator(l10n),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withOpacity(0.05),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionIndicator(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.decisionInProgress,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.gold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotingStatus(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryRed.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.playersVoting,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.secretContinues,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppColors.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerGrid(
    BuildContext context,
    GameState state,
    String localName,
    AppLocalizations l10n,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: MediaQuery.of(context).size.width < 380 ? 0.8 : 0.85,
      ),
      itemCount: state.connectedPlayers.length,
      itemBuilder: (context, index) {
        final playerName = state.connectedPlayers[index];
        final isSelf = playerName == localName;
        final isVoted = state.votedPlayerIndex == index;

        return _VoteCard(
          name: playerName,
          isSelf: isSelf,
          isVoted: isVoted,
          onVote: isSelf || state.isVotingReady
              ? null
              : () => context.read<GameCubit>().selectVote(index),
          l10n: l10n,
        );
      },
    );
  }

  Widget _buildBottomBranding(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BoxedChar(char: l10n.appTitlePart1[0], size: 24),
          const SizedBox(width: 8),
          Text(
            l10n.appTitle,
            style: GoogleFonts.epilogue(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface.withOpacity(0.2),
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxedChar extends StatelessWidget {
  final String char;
  final double size;
  const _BoxedChar({required this.char, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryRed.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          char,
          style: GoogleFonts.epilogue(
            fontSize: size * 0.6,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryRed,
          ),
        ),
      ),
    );
  }
}

class _VoteCard extends StatelessWidget {
  final String name;
  final bool isSelf;
  final bool isVoted;
  final VoidCallback? onVote;
  final AppLocalizations l10n;

  const _VoteCard({
    required this.name,
    required this.isSelf,
    required this.isVoted,
    this.onVote,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onVote,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isVoted
              ? AppColors.primaryRed.withOpacity(0.1)
              : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isVoted
                ? AppColors.primaryRed
                : Colors.white.withOpacity(0.05),
            width: isVoted ? 2 : 1,
          ),
          boxShadow: isVoted
              ? [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  Icons.person_outline_rounded,
                  size: 32,
                  color: isVoted
                      ? AppColors.primaryRed
                      : AppColors.onSurface.withOpacity(0.3),
                ),
                if (isVoted)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.primaryRed,
                      child: Icon(Icons.check, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isSelf ? "$name (${l10n.badgeHost})" : name,
              style: GoogleFonts.epilogue(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            if (!isSelf)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isVoted
                      ? AppColors.primaryRed
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isVoted ? l10n.votedSelected : l10n.votedSelect,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isVoted
                        ? Colors.white
                        : AppColors.onSurface.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
