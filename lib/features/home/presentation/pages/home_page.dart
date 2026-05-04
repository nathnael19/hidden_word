import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/home/presentation/widgets/game_card.dart';
import 'package:hidden_word/features/home/presentation/widgets/launcher_hero_section.dart';
import 'package:hidden_word/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:hidden_word/features/home/presentation/widgets/connect_section.dart';
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
        if (state is HomeLoading) {
          return const Scaffold(
            backgroundColor: AppColors.obsidian,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink),
            ),
          );
        }

        final currentIndex = (state is HomeLoaded) ? state.currentTabIndex : 0;

        return Scaffold(
          backgroundColor: AppColors.obsidian,
          body: _buildBody(state, currentIndex),
          bottomNavigationBar: const HomeBottomNavBar(),
        );
      },
    );
  }

  Widget _buildBody(HomeState state, int currentIndex) {
    return IndexedStack(
      index: currentIndex,
      children: [
        _buildVaultTab(),
        const ConnectSection(),
        _buildRulesTab(),
        const SettingsPage(),
      ],
    );
  }

  Widget _buildVaultTab() {
    return Stack(
      children: [
        _buildBackgroundGlows(),
        SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: LauncherHeroSection(),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.4,
                  ),
                  delegate: SliverChildListDelegate([
                    GameCard(
                      title: 'HIDDEN WORD',
                      subtitle: 'UNCOVER THE TRAITOR',
                      description: 'Find the secret word while spotting the spy among you.',
                      icon: Icons.security_rounded,
                      accentColor: AppColors.primaryPink,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HiddenWordSetupPage(),
                          ),
                        );
                      },
                    ),
                    const GameCard(
                      title: 'SPYFALL',
                      subtitle: 'COMING SOON',
                      description: 'A classic game of social deduction in a variety of locations.',
                      icon: Icons.location_on_rounded,
                      accentColor: AppColors.gold,
                      isLocked: true,
                    ),
                    const GameCard(
                      title: 'UNDERCOVER',
                      subtitle: 'COMING SOON',
                      description: 'Can you survive the interrogation without blowing your cover?',
                      icon: Icons.visibility_off_rounded,
                      accentColor: AppColors.primaryRed,
                      isLocked: true,
                    ),
                  ]),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRulesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, color: AppColors.gold, size: 64),
          const SizedBox(height: 24),
          Text(
            'Rules Manual',
            style: GoogleFonts.epilogue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'COMING SOON TO YOUR HUD',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface.withOpacity(0.3),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlows() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryPink.withOpacity(0.1),
                  AppColors.primaryPink.withOpacity(0.01),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withOpacity(0.05),
                  AppColors.gold.withOpacity(0.01),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
