import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/home/presentation/widgets/connect_section.dart';
import 'package:hidden_word/features/home/presentation/widgets/game_config_section.dart';
import 'package:hidden_word/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:hidden_word/features/home/presentation/widgets/home_hero_section.dart';
import 'package:hidden_word/features/home/presentation/widgets/theme_selection_grid.dart';
import 'package:hidden_word/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final currentIndex = (state is HomeLoaded) ? state.currentTabIndex : 0;
        final selectedTheme = (state is HomeLoaded) ? state.selectedTheme : 'Food';

        return Scaffold(
          backgroundColor: AppColors.obsidian,
          extendBodyBehindAppBar: true,
          extendBody: true,
          bottomNavigationBar: const HomeBottomNavBar(),
          body: (state is HomeLoading)
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                )
              : IndexedStack(
                  index: currentIndex,
                  children: [
                    _HomeSection(
                      selectedTheme: selectedTheme,
                      homeLoaded: state as HomeLoaded,
                    ),
                    const ConnectSection(),
                    const _PlaceholderSection(title: 'RULES'),
                    const SettingsPage(),
                  ],
                ),
        );
      },
    );
  }
}

class _HomeSection extends StatelessWidget {
  final String selectedTheme;
  final HomeLoaded homeLoaded;
  const _HomeSection({required this.selectedTheme, required this.homeLoaded});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroundGlows(),
        _buildEclipseArc(),
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const HomeHeroSection(),
                  const SizedBox(height: 48),
                  ThemeSelectionGrid(currentTheme: selectedTheme),
                  const SizedBox(height: 32),
                  GameConfigSection(state: homeLoaded),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundGlows() {
    return Positioned(
      left: -100,
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

  Widget _buildEclipseArc() {
    return Positioned(
      right: -80,
      top: 100,
      child: Opacity(
        opacity: 0.15,
        child: Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.onSurface.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.onSurface.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderSection extends StatelessWidget {
  final String title;
  const _PlaceholderSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.epilogue(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface.withOpacity(0.2),
        ),
      ),
    );
  }
}
