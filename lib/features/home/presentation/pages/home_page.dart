import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/home/presentation/widgets/connect_section.dart';
import 'package:hidden_word/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:hidden_word/features/home/presentation/widgets/launcher_hero_section.dart';
import 'package:hidden_word/features/home/presentation/widgets/game_card.dart';
import 'package:hidden_word/features/game/presentation/pages/hidden_word_setup_page.dart';
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
                    const _GamePickerSection(),
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

class _GamePickerSection extends StatelessWidget {
  const _GamePickerSection();

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
                  const LauncherHeroSection(),
                  const SizedBox(height: 40),
                  Text(
                    'SELECT OPERATION',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface.withOpacity(0.3),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GameCard(
                    title: 'Hidden Word',
                    subtitle: 'Find the spy before they figure out the secret word.',
                    icon: Icons.security_rounded,
                    accentColor: AppColors.primaryPink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HiddenWordSetupPage()),
                      );
                    },
                  ),
                  GameCard(
                    title: 'Spyfall',
                    subtitle: 'Everyone knows the location except the spy.',
                    icon: Icons.location_on_rounded,
                    accentColor: Colors.blueAccent,
                    isComingSoon: true,
                    onTap: () {},
                  ),
                  GameCard(
                    title: 'Undercover',
                    subtitle: 'Describe your word without giving it away.',
                    icon: Icons.visibility_off_rounded,
                    accentColor: Colors.purpleAccent,
                    isComingSoon: true,
                    onTap: () {},
                  ),
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

