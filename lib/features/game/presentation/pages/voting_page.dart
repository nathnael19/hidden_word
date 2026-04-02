import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/game/presentation/pages/results_page.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';

class VotingPage extends StatelessWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          return SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      _buildHeader(),
                      const SizedBox(height: 48),
                      Expanded(
                        child: _buildVotingGrid(context, state),
                      ),
                      const SizedBox(height: 180), // Space for bottom status card
                    ],
                  ),
                ),
                _buildStatusDashboard(context, state),
                if (state.isVotingReady) _buildWaitingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaitingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
            const SizedBox(height: 24),
            Text(
              'WAITING FOR OTHERS...',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.gold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              '2',
              style: GoogleFonts.epilogue(
                fontSize: 160,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // spacer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SECRET ACTIVE',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.greenAccent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Who is the\nspy?',
              textAlign: TextAlign.center,
              style: GoogleFonts.epilogue(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'TRUST NO ONE. VOTE WISELY.',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryRed.withOpacity(0.6),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVotingGrid(BuildContext context, GameState state) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.65,
      ),
      itemCount: state.totalPlayers,
      itemBuilder: (context, index) {
        final targetName = state.connectedPlayers.isNotEmpty ? state.connectedPlayers[index % state.connectedPlayers.length] : 'Unknown';
        final isSelected = state.votedPlayerIndex == index;
        return _VotingCard(
          name: targetName,
          isSelected: isSelected,
          onTap: () {
            context.read<GameCubit>().selectVote(index);
            final mp = context.read<MultiplayerCubit>();
            final st = mp.state;
            if (st.status == MultiplayerStatus.hosting ||
                st.status == MultiplayerStatus.connected) {
              mp.submitVote(st.playerName, targetName);
            } else {
              final spies = context.read<GameCubit>().state.spyPlayerNames;
              final caught =
                  spies.isNotEmpty && spies.contains(targetName);
              context.read<GameCubit>().startResults(caught, targetName);
            }
          },
        );
      },
    );
  }

  Widget _buildStatusDashboard(BuildContext context, GameState state) {
    final minutes = (state.timerSeconds / 60).floor();
    final seconds = (state.timerSeconds % 60).toString().padLeft(2, '0');

    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withOpacity(0.95),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VOTING STATUS',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PLAYERS ARE MAKING THEIR MOVE',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$minutes:$seconds',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Progress Bar
            Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: 6,
                  width: (MediaQuery.of(context).size.width - 96) * (state.timerSeconds / 45),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.3),
                        blurRadius: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Mini Voted Avatars
                _buildMiniAvatars(),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'DECISION IN PROGRESS',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniAvatars() {
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          _buildMiniAvatar(0),
          Positioned(left: 18, child: _buildMiniAvatar(11)),
          Positioned(
            left: 36,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.obsidian, width: 2),
              ),
              child: Center(
                child: Text(
                  '+1',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAvatar(int index) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.obsidian, width: 2),
        image: const DecorationImage(
          image: AssetImage('assets/ritualist_avatar.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _VotingCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _VotingCard({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.white.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/ritualist_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                name,
                style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF8B0000) : Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Center(
                  child: Text(
                    isSelected ? 'VOTE CAST' : 'VOTE',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : AppColors.onSurface.withOpacity(0.4),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
