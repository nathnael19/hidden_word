import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/game/presentation/pages/discussion_page.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';

bool _isLocalPlayerSpy(GameState state, MultiplayerState mp) {
  if (state.spyPlayerNames.isEmpty) return false;
  // In a multiplayer session, check using the local player's name.
  if (mp.status == MultiplayerStatus.hosting ||
      mp.status == MultiplayerStatus.connected) {
    return state.spyPlayerNames.contains(mp.playerName);
  }
  // Single-player / offline — not in a multiplayer session.
  return false;
}

class SecretRevealPage extends StatelessWidget {
  const SecretRevealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {
          if (state.phase == GamePhase.discussion) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DiscussionPage()),
            );
          }
        },
        builder: (context, state) {
          final isWaitingForHost =
              !state.sessionActive || state.spyPlayerNames.isEmpty;

          if (isWaitingForHost) {
            return _buildWaitingForHostState();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Header: Player ID Label
                  Text(
                    'የተጫዋቾች መለያ',
                    style: GoogleFonts.epilogue(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Boxed Title
                  const _BoxedText(text: 'ሚስጥራዊ ቃል'),
                  const SizedBox(height: 32),
                  // Subtitle Label with Line
                  _buildSubHeader(),
                  const Spacer(),
                  // Central Reveal Card
                  _RevealCard(
                    isRevealed: state.isRevealed,
                    secretWord: state.secretWord,
                    isSpy: _isLocalPlayerSpy(
                      state,
                      context.read<MultiplayerCubit>().state,
                    ),
                    onTap: () => context.read<GameCubit>().toggleReveal(),
                  ),
                  const Spacer(),
                  // Player Progress Dots
                  _buildProgressDots(state.playersReadyCount, state.totalPlayers),
                  const SizedBox(height: 16),
                  // Readiness Text
                  Text(
                    '${state.playersReadyCount} of ${state.totalPlayers} ተጫዋችች ተዘጋጅተዋል',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Crimson Bottom Action
                  _buildActionButton(context, state),
                  const SizedBox(height: 16),
                  // Footer Text
                  Text(
                    'የምስጢር ቃልህን ለማንም እንዳታሳይ',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface.withOpacity(0.2),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaitingForHostState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
          const SizedBox(height: 32),
          Text(
            'WAITING FOR HOST...',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.gold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The host is configuring the game settings.',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'SECRET WORD REVEAL',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface.withOpacity(0.4),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressDots(int current, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index < current;
        final isCurrent = index == current - 1;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent
                ? Colors.greenAccent
                : isActive
                    ? Colors.green.withOpacity(0.6)
                    : AppColors.onSurface.withOpacity(0.1),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(BuildContext context, GameState state) {
    if (state.isReady) {
      return Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(
            'አስተናጋጁን በመጠበቅ ላይ...',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gold.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ),
        ],
      );
    }

    return GestureDetector(
        onTap: () {
        if (state.isRevealed) {
          context.read<GameCubit>().markAsReady();
          final mp = context.read<MultiplayerCubit>();
          final mpState = mp.state;
          if (mpState.status == MultiplayerStatus.hosting ||
              mpState.status == MultiplayerStatus.connected) {
            mp.submitReady(mpState.playerName);
          } else {
            context.read<GameCubit>().startDiscussion(isHost: true);
          }
        } else {
          context.read<GameCubit>().toggleReveal();
        }
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height < 700 ? 60 : 72,
        decoration: BoxDecoration(
          color: const Color(0xFF8B0000), // Dark Crimson/Maroon
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height < 700 ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: _BoxedText(
            text: 'ዝግጁ', // READY
            boxSize: 32,
            fontSize: 16,
            borderColor: Colors.transparent,
            isFilled: false,
          ),
        ),
      ),
    );
  }
}

class _BoxedText extends StatelessWidget {
  final String text;
  final double? boxSize;
  final double? fontSize;
  final Color? borderColor;
  final bool isFilled;

  const _BoxedText({
    required this.text,
    this.boxSize,
    this.fontSize,
    this.borderColor,
    this.isFilled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Handling Amharic groups or single chars
    final chars = text.split('');
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveBoxSize = boxSize ?? (screenWidth < 360 ? 36.0 : 48.0);
    final effectiveFontSize = fontSize ?? (screenWidth < 360 ? 18.0 : 24.0);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: chars.map((char) {
        if (char == ' ') return const SizedBox(width: 12);
        return Container(
          width: effectiveBoxSize,
          height: effectiveBoxSize,
          decoration: BoxDecoration(
            color: isFilled ? AppColors.surfaceContainerHigh : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor ?? AppColors.onSurface.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              char,
              style: GoogleFonts.epilogue(
                fontSize: effectiveFontSize,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RevealCard extends StatelessWidget {
  final bool isRevealed;
  final String secretWord;
  final bool isSpy;
  final VoidCallback onTap;

  const _RevealCard({
    required this.isRevealed,
    required this.secretWord,
    required this.isSpy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: MediaQuery.of(context).size.height < 700 
            ? MediaQuery.of(context).size.height * 0.4 
            : MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
            if (isRevealed)
              BoxShadow(
                color: (isSpy ? AppColors.primaryRed : Colors.green).withOpacity(0.1),
                blurRadius: 60,
                spreadRadius: 10,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Icon(
                isRevealed ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                size: 40,
                color: isRevealed
                    ? (isSpy ? AppColors.primaryRed : Colors.greenAccent)
                    : AppColors.primaryPink.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 48),
            if (!isRevealed) ...[
              Text(
                'ለመክፈት ይጫኑ',
                style: GoogleFonts.epilogue(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'የአርሀዎን ሚስጥራዊ ቃል ለማየት ካርዱን ይንኩ። ማንም እንደማያይዎት እርግጠኛ ይሁኑ።',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.onSurface.withOpacity(0.4),
                    height: 1.6,
                  ),
                ),
              ),
            ] else ...[
              Text(
                isSpy ? 'አንተ ሰላይ ነህ!' : 'ሚስጥራዊው ቃል',
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: (isSpy ? AppColors.primaryRed : Colors.greenAccent).withOpacity(0.8),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isSpy ? '???' : secretWord,
                style: GoogleFonts.epilogue(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
