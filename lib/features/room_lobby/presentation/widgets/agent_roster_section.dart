import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';

class AgentRosterSection extends StatelessWidget {
  final List<String> connectedPlayers;
  final String localPlayerName;

  const AgentRosterSection({
    super.key,
    required this.connectedPlayers,
    required this.localPlayerName,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = connectedPlayers.length + 1;
    return Column(
      children: [
        _buildPlayersHeader(totalCount),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: MediaQuery.of(context).size.width < 380 ? 0.75 : 0.85,
          ),
          itemCount: totalCount < 4 ? 4 : totalCount,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _PlayerCard(player: {'name': 'You (Host)', 'status': 'READY', 'isHost': true});
            }
            if (index < totalCount) {
              return _PlayerCard(player: {'name': connectedPlayers[index - 1], 'status': 'JOINED', 'isHost': false});
            }
            return const _WaitingSlot();
          },
        ),
      ],
    );
  }

  Widget _buildPlayersHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Agent Roster',
          style: GoogleFonts.epilogue(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count / 10',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final Map<String, dynamic> player;
  const _PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    final bool isHost = player['isHost'] ?? false;
    final bool isReady = player['status'] == 'READY' || player['status'] == 'JOINED';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHost ? AppColors.primaryRed.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          width: isHost ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (isHost)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                ),
                child: Text(
                  'HOST',
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isHost ? Icons.security_rounded : Icons.person_rounded,
                    color: isHost ? AppColors.primaryRed.withOpacity(0.8) : Colors.white.withOpacity(0.4),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  player['name'],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.epilogue(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isReady ? Colors.green : Colors.orange).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    player['status'],
                    style: GoogleFonts.manrope(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: isReady ? Colors.greenAccent : Colors.orangeAccent,
                      letterSpacing: 1,
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
}

class _WaitingSlot extends StatelessWidget {
  const _WaitingSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.03),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.radio_button_unchecked_rounded,
              color: Colors.white.withOpacity(0.1),
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ENCRYPTING...',
            style: GoogleFonts.manrope(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.1),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
