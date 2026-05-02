import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/home/presentation/widgets/game_config_section.dart';
import 'package:hidden_word/features/home/presentation/widgets/theme_selection_grid.dart';

class HiddenWordSetupPage extends StatelessWidget {
  const HiddenWordSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SETUP MISSION',
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.gold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBackgroundGlows(),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is! HomeLoaded) return const SizedBox();
              
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Hidden Word',
                          style: GoogleFonts.epilogue(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Configure your mission parameters before starting the operation.',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            color: AppColors.onSurface.withOpacity(0.5),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ThemeSelectionGrid(currentTheme: state.selectedTheme),
                        const SizedBox(height: 32),
                        GameConfigSection(state: state),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlows() {
    return Positioned(
      right: -100,
      top: 100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primaryPink.withOpacity(0.08),
              AppColors.primaryPink.withOpacity(0.02),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
