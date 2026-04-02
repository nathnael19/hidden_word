import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/game/presentation/pages/voting_page.dart';

class DiscussionPage extends StatelessWidget {
  const DiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: _buildAppBar(context),
      body: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {
          if (state.timerSeconds == 0 && state.phase == GamePhase.discussion) {
            context.read<GameCubit>().startVoting();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const VotingPage()),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildPhaseHeader(),
                    const SizedBox(height: 48),
                    _buildTimerSection(state.timerSeconds),
                    const SizedBox(height: 64),
                    _buildActivePlayersSection(context, state.totalPlayers),
                    const SizedBox(height: 120), // Placeholder for bottom bar
                  ],
                ),
              ),
              // Peeking Bottom Sheet logic
              _buildPeekingToolbar(context, state),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.onSurface),
        onPressed: () {},
      ),
      centerTitle: true,
      title: const _SmallBoxedTitle(),
      actions: [
        _buildLiveSessionPill(),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildLiveSessionPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 14, color: AppColors.primaryRed.withOpacity(0.8)),
          const SizedBox(width: 6),
          Text(
            'LIVE SESSION',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseHeader() {
    return Column(
      children: [
        Text(
          'DISCUSSION PHASE',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface.withOpacity(0.4),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Who is the Spy?',
          style: GoogleFonts.epilogue(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSection(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    final progress = seconds / 105; // Total duration assumed 105s

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: AppColors.onSurface.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(
              seconds < 30 ? AppColors.primaryRed : AppColors.primaryPink.withOpacity(0.8),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '0$minutes:$remainingSeconds',
              style: GoogleFonts.manrope(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              'TIME LEFT',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface.withOpacity(0.3),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivePlayersSection(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVE PLAYERS',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface.withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count ONLINE',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemCount: count,
            itemBuilder: (context, index) {
              return _PlayerCard(
                name: ['Lidya', 'Amanuel', 'Dawit', 'Hana', 'Abel', 'Sara'][index % 6],
                isHost: index == 1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeekingToolbar(BuildContext context, GameState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: state.isPeeking ? 60 : 0,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: state.isPeeking
                ? Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'YOUR WORD IS:',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface.withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.secretWord,
                        style: GoogleFonts.epilogue(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.gold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) {
              if (!state.isPeeking) {
                context.read<GameCubit>().togglePeeking();
              }
            },
            onTapUp: (_) {
              if (state.isPeeking) {
                context.read<GameCubit>().togglePeeking();
              }
            },
            onTapCancel: () {
              if (state.isPeeking) {
                context.read<GameCubit>().togglePeeking();
              }
            },
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFB00020), // Crimson start
                    Color(0xFFFF8B94), // Pink end
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.remove_red_eye, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'TAP TO PEEK WORD',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBoxedTitle extends StatelessWidget {
  const _SmallBoxedTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: 'ሚስጥራዊ '.split('').map((char) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryRed, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              char,
              style: GoogleFonts.epilogue(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final String name;
  final bool isHost;

  const _PlayerCard({required this.name, this.isHost = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          if (isHost)
            const Positioned(
              top: 12,
              right: 12,
              child: Icon(Icons.stars, color: AppColors.gold, size: 16),
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/ritualist_avatar.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surfaceContainerHigh, width: 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
