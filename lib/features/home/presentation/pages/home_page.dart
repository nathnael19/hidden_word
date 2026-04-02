import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_cubit.dart';
import 'package:hidden_word/features/home/presentation/cubit/home_state.dart';
import 'package:hidden_word/features/home/presentation/widgets/connect_section.dart';
import 'package:hidden_word/features/settings/presentation/pages/settings_page.dart';
import 'package:hidden_word/features/game/presentation/pages/secret_reveal_page.dart';
import 'package:hidden_word/features/game/presentation/cubit/game_cubit.dart';

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
        final selectedTheme = (state is HomeLoaded)
            ? state.selectedTheme
            : 'Food';

        return Scaffold(
          backgroundColor: AppColors.obsidian,
          extendBodyBehindAppBar: true,
          extendBody: true,
          bottomNavigationBar: const _BottomNavBar(),
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
                  const SizedBox(height: 32),
                  _buildHeroSection(),
                  const SizedBox(height: 48),
                  _buildThemeSection(context, selectedTheme),
                  const SizedBox(height: 24), // Reduced from 48
                  _buildConfigSection(context, homeLoaded),
                  const SizedBox(height: 140), // Space for fixed BottomNav
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

  Widget _buildConfigSection(BuildContext context, HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'READY TO FIND THE ',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface.withOpacity(0.3),
                  letterSpacing: 1,
                ),
              ),
              Text(
                'SECRET WORD?',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.gold.withOpacity(0.6),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40), // Spacing below CTA text
        _buildSectionHeader('Players'),
        const SizedBox(height: 20),
        _buildPlayerCountSelector(context, state.playersCount),
        const SizedBox(height: 24),
        _buildSettingsGrid(context, state.timerSeconds, state.roundsCount),
        const SizedBox(height: 32),
        _buildStartAction(context),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'PREPARE YOUR POKER FACE',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface.withOpacity(0.3),
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.onSurface.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCountSelector(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.onSurface.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRoundIconButton(
                icon: Icons.remove,
                onTap: () =>
                    context.read<HomeCubit>().updatePlayersCount(count - 1),
                isDisabled: count <= 3,
              ),
              Column(
                children: [
                  Text(
                    '$count',
                    style: GoogleFonts.epilogue(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'FRIENDS JOINED',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface.withOpacity(0.5),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              _buildRoundIconButton(
                icon: Icons.add,
                onTap: () =>
                    context.read<HomeCubit>().updatePlayersCount(count + 1),
                isDisabled: count >= 10,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLimitLabel('MIN 3'),
              Row(
                children: List.generate(8, (index) {
                  final dotValue = index + 3;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotValue == count
                          ? AppColors.primaryPink
                          : AppColors.onSurface.withOpacity(
                              dotValue < count ? 0.4 : 0.1,
                            ),
                    ),
                  );
                }),
              ),
              _buildLimitLabel('MAX 10'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceContainerHigh.withOpacity(
            isDisabled ? 0.3 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(isDisabled ? 0.2 : 0.8),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLimitLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 9,
        fontWeight: FontWeight.w900,
        color: AppColors.onSurface.withOpacity(0.3),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsGrid(BuildContext context, int timer, int rounds) {
    return Row(
      children: [
        Expanded(
          child: _buildSettingCard(
            label: 'TIMER',
            value: '${timer}s',
            icon: Icons.timer,
            iconColor: Colors.green,
            onTap: () {
              // Cycle through common times: 45, 60, 90, 120
              final times = [45, 60, 90, 120];
              final currentIndex = times.indexOf(timer);
              final nextIndex = (currentIndex + 1) % times.length;
              context.read<HomeCubit>().updateTimer(times[nextIndex]);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSettingCard(
            label: 'ROUNDS',
            value: '$rounds Wins',
            icon: Icons.military_tech,
            iconColor: AppColors.primaryRed,
            onTap: () {
              // Cycle through: 3, 5, 7, 10
              final roundsList = [3, 5, 7, 10];
              final currentIndex = roundsList.indexOf(rounds);
              final nextIndex = (currentIndex + 1) % roundsList.length;
              context.read<HomeCubit>().updateRounds(roundsList[nextIndex]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.onSurface.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface.withOpacity(0.3),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartAction(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final playersCount = homeLoaded.playersCount;
        // Map home theme display name -> words.json category id
        final themeToCategory = {
          'Food': 'food',
          'Transport': 'transport',
          'Culture': 'culture',
          'Student': 'student',
        };
        final categoryId = themeToCategory[homeLoaded.selectedTheme] ?? 'food';
        await context.read<GameCubit>().init(playersCount, categoryId: categoryId);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecretRevealPage()),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.primaryPink.withOpacity(0.85),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withOpacity(0.25),
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
                color: Colors.black.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: 1,
                height: 24,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            Text(
              'ጨዋታ ጀምር',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.black.withOpacity(0.7),
              size: 24,
            ),
          ],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primaryPink
                      : AppColors.onSurface.withOpacity(0.5),
                  size: 30,
                ),
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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final currentIndex = (state is HomeLoaded) ? state.currentTabIndex : 0;
        return Container(
          height: 94,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withOpacity(0.98),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                Icons.home_filled,
                'HOME',
                currentIndex == 0,
                0,
              ),
              _buildNavItem(
                context,
                Icons.sensors_rounded,
                'CONNECT',
                currentIndex == 1,
                1,
              ),
              _buildNavItem(
                context,
                Icons.menu_book_rounded,
                'RULES',
                currentIndex == 2,
                2,
              ),
              _buildNavItem(
                context,
                Icons.settings_rounded,
                'SETTINGS',
                currentIndex == 3,
                3,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<HomeCubit>().setTabIndex(index);
        if (index == 1) {
          context.read<HomeCubit>().setConnectViewMode(ConnectViewMode.main);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : AppColors.onSurface.withOpacity(0.3),
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ] else ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface.withOpacity(0.2),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
