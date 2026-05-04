import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';

class LauncherHeroSection extends StatelessWidget {
  const LauncherHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: AppColors.primaryPink.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primaryPink,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PREMIUM ACCESS',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryPink,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Game Vault',
            style: GoogleFonts.epilogue(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select your next operation. High stakes,\nmaximum deduction required.',
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              color: AppColors.onSurface.withOpacity(0.5),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
