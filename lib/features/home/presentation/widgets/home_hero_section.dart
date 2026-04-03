import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE HIDDEN WORD',
          style: GoogleFonts.manrope(
            color: AppColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            Text(
              'ስውር',
              style: GoogleFonts.epilogue(
                fontSize: MediaQuery.of(context).size.width < 360 ? 32 : 36,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
                letterSpacing: 4,
              ),
            ),
            Text(
              'ቃል',
              style: GoogleFonts.epilogue(
                fontSize: MediaQuery.of(context).size.width < 360 ? 32 : 36,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryPink,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: 120,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPink.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Find the spy among you. Speak\ncarefully, trust no one.',
          style: GoogleFonts.beVietnamPro(
            fontSize: MediaQuery.of(context).size.width < 360 ? 16 : 18,
            color: AppColors.onSurface.withOpacity(0.6),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
