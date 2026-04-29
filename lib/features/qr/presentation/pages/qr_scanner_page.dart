import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_word/core/style/app_colors.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_cubit.dart';
import 'package:hidden_word/features/multiplayer/presentation/cubit/multiplayer_state.dart';
import 'package:hidden_word/features/qr/services/qr_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Full-screen QR scanner for joining a game session.
///
/// On a valid scan: vibrates, connects via [MultiplayerCubit.connectByQr],
/// then pops back to the join screen. Duplicate scans are ignored via [_scanned].
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _scanned = false;
  bool _torchOn = false;
  bool _connecting = false;
  String? _errorMessage;
  Timer? _errorTimer;

  @override
  void dispose() {
    _controller.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    if (_scanned || _connecting) return;

    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;

    final data = QrService.decode(raw);
    if (data == null) {
      _showError('Invalid QR code — scan a Hidden Word room code');
      return;
    }

    setState(() {
      _scanned = true;
      _connecting = true;
      _errorMessage = null;
    });

    HapticFeedback.mediumImpact();
    await _controller.stop();

    if (!mounted) return;
    await context.read<MultiplayerCubit>().connectByQr(data);

    if (!mounted) return;
    final status = context.read<MultiplayerCubit>().state.status;

    if (status == MultiplayerStatus.error) {
      final msg =
          context.read<MultiplayerCubit>().state.errorMessage ??
          'Could not reach the host. Make sure you\'re on the same network.';
      setState(() {
        _connecting = false;
        _scanned = false;
        _errorMessage = msg;
      });
      await _controller.start();
    } else {
      // Successfully connected — go back to join screen, the existing
      // BlocListener<GameCubit> will handle further navigation.
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _showError(String message) {
    _errorTimer?.cancel();
    setState(() => _errorMessage = message);
    _errorTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _errorMessage = null);
    });
  }

  void _toggleTorch() {
    setState(() => _torchOn = !_torchOn);
    _controller.toggleTorch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Stack(
        children: [
          // Camera feed
          MobileScanner(controller: _controller, onDetect: _onBarcodeDetected),

          // Darkened overlay with scan window cut-out
          _ScanOverlay(),

          // Top chrome
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ChromeButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'SCAN TO JOIN',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 2,
                    ),
                  ),
                  _ChromeButton(
                    icon: _torchOn
                        ? Icons.flashlight_on_rounded
                        : Icons.flashlight_off_rounded,
                    onTap: _toggleTorch,
                    active: _torchOn,
                  ),
                ],
              ),
            ),
          ),

          // Bottom info panel
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Error banner
                    if (_errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            color: Colors.redAccent.shade100,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Connecting indicator
                    if (_connecting)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.greenAccent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Connecting to room...',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.greenAccent.shade100,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // Instruction hint
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Point your camera at the host\'s QR code',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                            height: 1.4,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark overlay with a square cut-out to guide scanning.
class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const windowSize = 240.0;
    final left = (size.width - windowSize) / 2;
    final top = (size.height - windowSize) / 2 - 40;

    return Stack(
      children: [
        // Four dark quadrants
        Positioned(top: 0, left: 0, right: 0, height: top, child: _darkPane()),
        Positioned(
          top: top,
          left: 0,
          width: left,
          height: windowSize,
          child: _darkPane(),
        ),
        Positioned(
          top: top,
          right: 0,
          width: left,
          height: windowSize,
          child: _darkPane(),
        ),
        Positioned(
          top: top + windowSize,
          left: 0,
          right: 0,
          bottom: 0,
          child: _darkPane(),
        ),

        // Corner markers
        Positioned(
          top: top,
          left: left,
          child: _ScanCorners(size: windowSize),
        ),

        // Scan line animation
        Positioned(
          top: top,
          left: left,
          child: _ScanLine(windowSize: windowSize),
        ),
      ],
    );
  }

  Widget _darkPane() => Container(color: Colors.black.withOpacity(0.65));
}

/// Animated scan line that sweeps top to bottom inside the scan window.
class _ScanLine extends StatefulWidget {
  final double windowSize;
  const _ScanLine({required this.windowSize});

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0,
      end: widget.windowSize - 2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.windowSize,
      height: widget.windowSize,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, _) => Stack(
          children: [
            Positioned(
              top: _anim.value,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.primaryPink.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws the four L-shaped corner markers around the scan window.
class _ScanCorners extends StatelessWidget {
  final double size;
  const _ScanCorners({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CornerPainter()),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryPink
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 24.0;
    const r = 6.0;

    // Top-left
    canvas.drawLine(Offset(r, 0), Offset(len, 0), paint);
    canvas.drawLine(Offset(0, r), Offset(0, len), paint);
    canvas.drawArc(
      const Rect.fromLTWH(0, 0, r * 2, r * 2),
      3.14,
      -1.57,
      false,
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(size.width - len, 0),
      Offset(size.width - r, 0),
      paint,
    );
    canvas.drawLine(Offset(size.width, r), Offset(size.width, len), paint);
    canvas.drawArc(
      Rect.fromLTWH(size.width - r * 2, 0, r * 2, r * 2),
      4.71,
      -1.57,
      false,
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - len),
      Offset(0, size.height - r),
      paint,
    );
    canvas.drawLine(Offset(r, size.height), Offset(len, size.height), paint);
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - r * 2, r * 2, r * 2),
      1.57,
      -1.57,
      false,
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height - len),
      Offset(size.width, size.height - r),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - len, size.height),
      Offset(size.width - r, size.height),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(size.width - r * 2, size.height - r * 2, r * 2, r * 2),
      0,
      -1.57,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Small circular button used in the scanner chrome.
class _ChromeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _ChromeButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primaryPink.withOpacity(0.2)
              : Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
          border: Border.all(
            color: active
                ? AppColors.primaryPink.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? AppColors.primaryPink : Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}
