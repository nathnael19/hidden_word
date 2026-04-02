import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_cubit.dart';
import 'package:hidden_word/features/room_lobby/presentation/cubit/room_lobby_state.dart';

class RoomLobbyPage extends StatefulWidget {
  const RoomLobbyPage({super.key});

  @override
  State<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends State<RoomLobbyPage> {
  @override
  void initState() {
    super.initState();
    context.read<RoomLobbyCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: _buildAppBar(),
      body: BlocBuilder<RoomLobbyCubit, RoomLobbyState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildSettingsCard(context, state),
                const SizedBox(height: 32),
                _buildInviteSection(state.roomId),
                const SizedBox(height: 40),
                _buildPlayersHeader(state.players.length),
                const SizedBox(height: 24),
                _buildPlayersGrid(state.players),
                const SizedBox(height: 48),
                _buildStartButton(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white70),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ስውር',
            style: GoogleFonts.epilogue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'ቃል',
            style: GoogleFonts.epilogue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPink,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceContainerHigh,
            backgroundImage: const AssetImage('assets/ritualist_avatar.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'THE THRONE',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white24,
                letterSpacing: 2,
              ),
            ),
            _buildConnectionBadge(),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'ስውር',
              style: GoogleFonts.epilogue(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ቅዱሳን',
              style: GoogleFonts.epilogue(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryRed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'CONNECTION STABLE',
            style: GoogleFonts.manrope(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: Colors.green,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, RoomLobbyState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.visibility_off_outlined, 'NUMBER OF SPIES'),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSpyButton(context, 1, state.spyCount == 1),
              const SizedBox(width: 12),
              _buildSpyButton(context, 2, state.spyCount == 2),
              const SizedBox(width: 12),
              _buildSpyButton(context, 3, state.spyCount == 3),
            ],
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(Icons.category_outlined, 'WORD CATEGORIES'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              _buildCategoryChip(
                context,
                'Traditional Food',
                state.selectedCategories.contains('Traditional Food'),
              ),
              _buildCategoryChip(
                context,
                'Heritage Sites',
                state.selectedCategories.contains('Heritage Sites'),
              ),
              _buildCategoryChip(
                context,
                'Ethiopian Culture',
                state.selectedCategories.contains('Ethiopian Culture'),
              ),
              _buildCategoryChip(
                context,
                'Sports',
                state.selectedCategories.contains('Sports'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildTimerTile(context, state.isTimerEnabled),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white24),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.white24,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSpyButton(BuildContext context, int count, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<RoomLobbyCubit>().updateSpyCount(count),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryRed
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: isSelected ? Border.all(color: Colors.white24) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$count ${count == 1 ? 'Spy' : 'Spies'}',
            style: GoogleFonts.epilogue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => context.read<RoomLobbyCubit>().toggleCategory(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check_circle, size: 14, color: Colors.black),
            if (isSelected) const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerTile(BuildContext context, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.gold, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '60s Discussion Timer',
                  style: GoogleFonts.epilogue(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Keep the pressure high',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: Colors.white30,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (val) => context.read<RoomLobbyCubit>().toggleTimer(val),
            activeThumbColor: AppColors.primaryRed,
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection(String roomId) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ROOM ID',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white24,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  roomId,
                  style: GoogleFonts.epilogue(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.copy_rounded,
                      size: 12,
                      color: AppColors.primaryPink,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'COPY LINK',
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Image.network(
            'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=H7K9',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'ተጫዋቾች',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($count/10)',
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white30,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AWAITING CONNECTIONS...',
              style: GoogleFonts.manrope(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: Colors.green,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayersGrid(List<Map<String, dynamic>> players) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: 6, // 4 players + 2 waiting slots
      itemBuilder: (context, index) {
        if (index < players.length) {
          return _buildPlayerCard(players[index]);
        }
        return _buildWaitingSlot();
      },
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player) {
    final bool isHost = player['isHost'] ?? false;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: isHost
            ? Border.all(
                color: AppColors.primaryPink.withOpacity(0.5),
                width: 1.5,
              )
            : null,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (isHost)
            Positioned(
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'HOST',
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white10,
                  backgroundImage: const AssetImage(
                    'assets/ritualist_avatar.png',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  player['name'],
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  player['status'],
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: player['status'] == 'READY'
                        ? Colors.green
                        : Colors.white24,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingSlot() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add_alt_1_outlined,
            color: Colors.white12,
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            'WAITING...',
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Colors.white12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withOpacity(0.6),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Text(
              'ጀምር (START GAME)',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ALL PLAYERS MUST BE READY BEFORE THE HUNT BEGINS',
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
