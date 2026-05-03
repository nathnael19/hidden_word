import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/home/presentation/pages/home_page.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:hidden_word/features/settings/presentation/cubit/settings_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Agent Code Name')),
      );
      return;
    }

    final settingsCubit = context.read<SettingsCubit>();
    settingsCubit.setPlayerName(_nameController.text.trim());
    settingsCubit.completeOnboarding();
    
    // Also update MultiplayerCubit immediately
    context.read<MultiplayerCubit>().setPlayerName(_nameController.text.trim());

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with blur
          Opacity(
            opacity: 0.6,
            child: Image.asset(
              'assets/splash_bg.png', // Fallback to splash bg for now
              fit: BoxFit.cover,
            ),
          ),
          
          // Dark Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  AppColors.obsidian.withOpacity(0.8),
                  AppColors.obsidian,
                ],
              ),
            ),
          ),

          PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStep1(),
              _buildStep2(),
              _buildStep3(),
            ],
          ),

          // Bottom Navigation
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Column(
              children: [
                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => _buildIndicator(index)),
                ),
                const SizedBox(height: 32),
                
                // Action Button
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryRed, AppColors.gold],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRed.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _currentPage == 2 ? 'INITIALIZE PROTOCOL' : 'CONTINUE',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 4,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.gold : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECRUITMENT\nIN PROGRESS',
            style: GoogleFonts.epilogue(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColors.gold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'The digital ritual of social deduction is starting. We need agents who can see through the shadows.',
            style: GoogleFonts.manrope(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IDENTITY\nASSIGNMENT',
            style: GoogleFonts.epilogue(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColors.gold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Every agent needs a code name. Choose yours carefully, or generate a random one.',
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 40),
          
          // Name Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    style: GoogleFonts.epilogue(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'AGENT CODE NAME',
                      hintStyle: GoogleFonts.epilogue(
                        color: Colors.white.withOpacity(0.2),
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _randomizeName,
                  icon: const Icon(Icons.refresh_rounded, color: AppColors.gold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _randomizeName() {
    final names = ['SHADOW', 'ECHO', 'SILENT', 'SPECTER', 'GHOST', 'VIPER', 'NOVA', 'RAVEN', 'CIPHER', 'ORACLE'];
    final suffixes = ['AGENT', 'OPERATOR', 'WALKER', 'BLADE', 'SOUL', 'MIND'];
    final rand = DateTime.now().millisecond;
    final name = names[rand % names.length];
    final suffix = suffixes[(rand ~/ names.length) % suffixes.length];
    final id = (rand % 900) + 100;
    
    setState(() {
      _nameController.text = '$name $suffix $id';
    });
    HapticFeedback.mediumImpact();
  }

  Widget _buildStep3() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LINGUISTIC\nPROTOCOLS',
                style: GoogleFonts.epilogue(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Choose the language for your mission instructions.',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 40),
              
              _buildLanguageOption(
                'English',
                'en',
                state.language == 'en',
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                'አማርኛ',
                'am',
                state.language == 'am',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String title, String code, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsCubit>().setLanguage(code);
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                color: isSelected ? AppColors.gold : Colors.white,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.gold),
          ],
        ),
      ),
    );
  }
}
