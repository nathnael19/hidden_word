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
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const _HomeAppBar(),
      bottomNavigationBar: const _BottomNavBar(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          if (state is HomeLoaded) {
            return Stack(
              children: [
                // Cinematic Background Elements (behind scroll view)
                _buildBackgroundGlows(),
                _buildEclipseArc(),

                // Main Content
                SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 54),
                          _buildHeroSection(),
                          const SizedBox(height: 54),
                          _buildThemeSection(context, state.selectedTheme),
                          _buildStartButton(),
                          const SizedBox(
                            height: 140,
                          ), // Space for fixed BottomNav
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
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

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE HIDDEN WORD',
          style: GoogleFonts.manrope(
            color: AppColors.gold,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        // Hero Split-Color Amharic Logo (NO BORDERS)
        Row(
          children: [
            Text(
              'ስውር',
              style: GoogleFonts.epilogue(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ቃል',
              style: GoogleFonts.epilogue(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryPink,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Divider with Pink Gradient
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
            fontSize: 18,
            color: AppColors.onSurface.withOpacity(0.6),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface.withOpacity(0.2),
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
          childAspectRatio: 1.2,
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
                color: AppColors.primaryRed.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
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
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'READY TO FIND THE ',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface.withOpacity(0.3),
              ),
            ),
            Text(
              'SECRET WORD?',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.gold.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    // Custom Top App Bar with fixed position
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Icon(
          Icons.sort,
          color: AppColors.onSurface.withOpacity(0.7),
          size: 24,
        ),
      ),

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ስውር',
            style: GoogleFonts.epilogue(
              // fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'ቃል',
            style: GoogleFonts.epilogue(
              // fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPink,
            ),
          ),
        ],
      ),
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
          color: AppColors.surfaceContainerHigh.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(
                  color: AppColors.primaryPink.withOpacity(0.3),
                  width: 1.5,
                )
              : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primaryPink
                      : AppColors.onSurface.withOpacity(0.5),
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

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, Icons.home_filled, 'HOME', true),
          _buildNavItem(context, Icons.history_rounded, 'HISTORY', false),
          _buildNavItem(context, Icons.menu_book_rounded, 'RULES', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                )
              : null,
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive
                    ? AppColors.primaryRed
                    : AppColors.onSurface.withOpacity(0.3),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isActive
                      ? AppColors.onSurface
                      : AppColors.onSurface.withOpacity(0.3),
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
