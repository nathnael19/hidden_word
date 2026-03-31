import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    const duration = Duration(seconds: 4);
    const interval = Duration(milliseconds: 50);
    int elapsed = 0;

    _timer = Timer.periodic(interval, (timer) {
      elapsed += interval.inMilliseconds;
      setState(() {
        _progress = elapsed / duration.inMilliseconds;
      });

      if (elapsed >= duration.inMilliseconds) {
        timer.cancel();
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset('assets/splash_bg.png', fit: BoxFit.cover),

          // Dark Gradient Overlay for cinematic feel
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  AppColors.obsidian.withOpacity(0.8),
                  AppColors.obsidian,
                ],
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // ??? Logo Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildQuestionBox('ስ'),
                    _buildQuestionBox('ው'),
                    _buildQuestionBox('ር'),
                    const SizedBox(width: 12),
                    _buildQuestionBox('ቃ'),
                    _buildQuestionBox('ል'),
                  ],
                ),

                const SizedBox(height: 24),

                // SEWUR KAL
                Text(
                  'SEWUR KAL',
                  style: GoogleFonts.epilogue(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gold,
                    letterSpacing: 8,
                  ),
                ),

                // Red Accent Line
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 48),

                // Tagline
                Text(
                  'The digital ritual of social deduction.\nTrust no one, unveil the hidden.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    color: AppColors.onSurface.withOpacity(0.7),
                    height: 1.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const Spacer(flex: 2),

                // Initialising Ritual Progress
                _buildLoadingSection(),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionBox(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 42,
      height: 52,
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.epilogue(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Progress Bar
        Container(
          width: double.infinity,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(1),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryRed, AppColors.gold],
                ),
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Initialising Ritual Text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'INITIALISING RITUAL',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface.withOpacity(0.8),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            _buildAnimatedDots(),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedDots() {
    return Row(
      children: List.generate(3, (index) {
        return Opacity(
          opacity: (_progress * 20 % 3).floor() == index ? 1.0 : 0.3,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.onSurface,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
