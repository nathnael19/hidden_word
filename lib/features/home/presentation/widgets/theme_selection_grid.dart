import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';

class ThemeSelectionGrid extends StatelessWidget {
  final String currentTheme;
  const ThemeSelectionGrid({super.key, required this.currentTheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Theme',
              style: GoogleFonts.epilogue(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              'REQUIRED',
              style: GoogleFonts.manrope(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface.withOpacity(0.2),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: MediaQuery.of(context).size.width < 360 ? 1.0 : 1.1,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final themes = [
              {'title': 'Food', 'keywords': 'Injera, Kitfo,\ncoffee...', 'icon': Icons.restaurant},
              {'title': 'Transport', 'keywords': 'Anbessa, Bajaj,\nRide...', 'icon': Icons.directions_bus, 'hasStatus': true},
              {'title': 'Culture', 'keywords': 'Meskel, Timket,\nGenna...', 'icon': Icons.celebration},
              {'title': 'Student', 'keywords': 'Campus, Exams,\nDorm...', 'icon': Icons.school},
            ];
            final theme = themes[index];
            return ThemeCard(
              title: theme['title'] as String,
              keywords: theme['keywords'] as String,
              icon: theme['icon'] as IconData,
              isSelected: currentTheme == theme['title'],
              hasStatus: theme['hasStatus'] == true,
              onTap: () => context.read<HomeCubit>().selectTheme(theme['title'] as String),
            );
          },
        ),
      ],
    );
  }
}

class ThemeCard extends StatelessWidget {
  final String title;
  final String keywords;
  final IconData icon;
  final bool isSelected;
  final bool hasStatus;
  final VoidCallback onTap;

  const ThemeCard({
    super.key,
    required this.title,
    required this.keywords,
    required this.icon,
    required this.isSelected,
    this.hasStatus = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: AppColors.primaryPink.withOpacity(0.3), width: 1.5)
              : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primaryPink : AppColors.onSurface.withOpacity(0.5),
                  size: 30,
                ),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.epilogue(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  keywords,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: AppColors.onSurface.withOpacity(0.3),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (hasStatus && !isSelected)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 12,
                            left: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.6),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
