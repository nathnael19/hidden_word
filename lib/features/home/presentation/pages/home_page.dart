import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';

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
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.gold));
          }
          if (state is HomeLoaded) {
            return Stack(
              children: [
                // Main Content
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAppBar(),
                          const SizedBox(height: 32),
                          _buildHeader(),
                          const SizedBox(height: 48),
                          _buildThemeSection(context, state.selectedTheme),
                          const SizedBox(height: 40),
                          _buildStartButton(),
                          const SizedBox(height: 120), // Padding for BottomNav
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Bottom Nav
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _BottomNavBar(),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.sort, color: AppColors.onSurface.withOpacity(0.8), size: 28),
        // Amharic Logo ስውር ቃል
        Row(
          children: [
            _buildSmallLogoBox('ስ'),
            _buildSmallLogoBox('ው'),
            _buildSmallLogoBox('ር'),
            const SizedBox(width: 4),
            _buildSmallLogoBox('ቃ'),
            _buildSmallLogoBox('ል'),
          ],
        ),
        Icon(Icons.settings_outlined, color: AppColors.onSurface.withOpacity(0.8), size: 28),
      ],
    );
  }

  Widget _buildSmallLogoBox(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.onSurface.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: GoogleFonts.epilogue(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Decorative Arc Background
        Positioned(
          right: -60,
          top: -20,
          child: Opacity(
            opacity: 0.1,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 2),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'THE HIDDEN WORD',
              style: GoogleFonts.manrope(
                color: AppColors.gold,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Large Amharic Logo
            Row(
              children: [
                _buildHeaderLogoBox('ስ'),
                _buildHeaderLogoBox('ው'),
                _buildHeaderLogoBox('ር'),
                const SizedBox(width: 12),
                _buildHeaderLogoBox('ቃ', color: AppColors.primaryRed.withOpacity(0.4)),
                _buildHeaderLogoBox('ል', color: AppColors.primaryRed.withOpacity(0.4)),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Find the spy among you. Speak\ncarefully, trust no one.',
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                color: AppColors.onSurface.withOpacity(0.7),
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderLogoBox(String text, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        border: Border.all(color: color ?? AppColors.onSurface, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.epilogue(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: color ?? AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, String currentTheme) {
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
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface.withOpacity(0.3),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            _ThemeCard(
              title: 'Food',
              keywords: 'Injera, Kitfo,\ncoffee...',
              icon: Icons.restaurant,
              isSelected: currentTheme == 'Food',
              onTap: () => context.read<HomeCubit>().selectTheme('Food'),
            ),
            _ThemeCard(
              title: 'Transport',
              keywords: 'Anbessa, Bajaj,\nRide...',
              icon: Icons.directions_bus,
              isSelected: currentTheme == 'Transport',
              hasStatus: true,
              onTap: () => context.read<HomeCubit>().selectTheme('Transport'),
            ),
            _ThemeCard(
              title: 'Culture',
              keywords: 'Meskel, Timket,\nGenna...',
              icon: Icons.celebration,
              isSelected: currentTheme == 'Culture',
              onTap: () => context.read<HomeCubit>().selectTheme('Culture'),
            ),
            _ThemeCard(
              title: 'Student',
              keywords: 'Campus, Exams,\nDorm...',
              icon: Icons.school,
              isSelected: currentTheme == 'Student',
              onTap: () => context.read<HomeCubit>().selectTheme('Student'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'START GAME',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'READY TO FIND THE ',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface.withOpacity(0.4),
              ),
            ),
            Text(
              'SECRET WORD?',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.gold.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String title;
  final String keywords;
  final IconData icon;
  final bool isSelected;
  final bool hasStatus;
  final VoidCallback onTap;

  const _ThemeCard({
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
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: AppColors.primaryRed.withOpacity(0.4), width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: isSelected ? AppColors.primaryRed : AppColors.onSurface.withOpacity(0.6), size: 32),
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
                    color: AppColors.onSurface.withOpacity(0.4),
                    height: 1.4,
                  ),
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
                    color: AppColors.primaryRed,
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
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            left: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.8),
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

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, Icons.home_filled, 'HOME', true),
          _buildNavItem(context, Icons.history, 'HISTORY', false),
          _buildNavItem(context, Icons.menu_book_rounded, 'RULES', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primaryRed : AppColors.onSurface.withOpacity(0.4),
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isActive ? AppColors.onSurface : AppColors.onSurface.withOpacity(0.4),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
