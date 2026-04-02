import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_state.dart';
import 'package:hidden_word/features/game/presentation/pages/secret_reveal_page.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: _buildAppBar(context),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildMissionTitle(),
                  const SizedBox(height: 48),
                  _buildSpyUnmaskedCard(state),
                  const SizedBox(height: 32),
                  _buildVictoryBanner(state.spyCaught),
                  const SizedBox(height: 32),
                  _buildSecretWordReveal(state.secretWord),
                  const SizedBox(height: 48),
                  _buildActionButtons(context),
                  const SizedBox(height: 48),
                ],
              ),
            ),
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
      title: _buildBoxedTitle(),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage('assets/ritualist_avatar.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxedTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: '??? ??'.split('').map((char) {
        if (char == ' ') return const SizedBox(width: 8);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gold, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              char,
              style: GoogleFonts.epilogue(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.gold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMissionTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MISSION CONCLUDED',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.greenAccent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.epilogue(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1,
            ),
            children: [
              const TextSpan(text: 'THE TRUTH\n'),
              TextSpan(
                text: 'REVEALED',
                style: TextStyle(color: AppColors.gold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpyUnmaskedCard(GameState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryRed.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security, color: AppColors.primaryRed, size: 14),
                const SizedBox(width: 8),
                Text(
                  'THE SPY!',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryRed,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/ritualist_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: -20,
                child: Transform.rotate(
                  angle: -0.1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      'DAWIT',
                      style: GoogleFonts.epilogue(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.obsidian,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Text(
            state.spyCaught
                ? 'Infiltrated the circle but\nwas finally unmasked.'
                : 'Infiltrated the circle and\nescaped undetected.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface.withOpacity(0.6),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVictoryBanner(bool spyCaught) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: spyCaught ? Colors.green.withOpacity(0.1) : AppColors.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: spyCaught ? Colors.green.withOpacity(0.3) : AppColors.primaryRed.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: spyCaught ? Colors.green.withOpacity(0.2) : AppColors.primaryRed.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              spyCaught ? Icons.military_tech : Icons.error_outline,
              color: spyCaught ? Colors.greenAccent : AppColors.primaryRed,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spyCaught ? 'The citizens win!' : 'The spy wins!',
                style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: spyCaught ? Colors.greenAccent : AppColors.primaryRed,
                ),
              ),
              Text(
                spyCaught ? 'JUSTICE RESTORED' : 'MISSION COMPROMISED',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: (spyCaught ? Colors.greenAccent : AppColors.primaryRed).withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecretWordReveal(String word) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'SECRET WORD',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface.withOpacity(0.3),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBoxIcon(),
              const SizedBox(width: 4),
              _buildBoxIcon(),
              const SizedBox(width: 12),
              Text(
                '($word)',
                style: GoogleFonts.epilogue(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxIcon() {
    return Container(
      width: 24,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildLargeButton(
          label: 'PLAY AGAIN',
          color: AppColors.primaryRed,
          icon: Icons.refresh,
          onTap: () {
            context.read<GameCubit>().resetGame();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SecretRevealPage()),
              (route) => false,
            );
          },
        ),
        const SizedBox(height: 16),
        _buildLargeButton(
          label: 'MAIN MENU',
          color: AppColors.surfaceContainerHigh,
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ],
    );
  }

  Widget _buildLargeButton({
    required String label,
    required Color color,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: color == AppColors.primaryRed
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 12),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
