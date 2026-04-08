import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/receipt_flow_ui_constants.dart';
import '../../../core/theme/receipt_flow_colors.dart';
import '../application/receipt_flow_cubit.dart';

class ReceiptCameraScreen extends StatefulWidget {
  const ReceiptCameraScreen({super.key});

  @override
  State<ReceiptCameraScreen> createState() => _ReceiptCameraScreenState();
}

class _ReceiptCameraScreenState extends State<ReceiptCameraScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptFlowCubit>();
    final flashLabel = context.watch<ReceiptFlowCubit>().state.flashLabel;

    return BlocListener<ReceiptFlowCubit, ReceiptFlowState>(
      listenWhen: (ReceiptFlowState previous, ReceiptFlowState current) =>
          current.pickErrorMessage != null &&
          current.pickErrorMessage != previous.pickErrorMessage,
      listener: (BuildContext context, ReceiptFlowState state) {
        final String? message = state.pickErrorMessage;
        if (message == null || !context.mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        context.read<ReceiptFlowCubit>().clearPickError();
      },
      child: Scaffold(
        backgroundColor: ReceiptFlowColors.cameraBackground,
        body: Column(
          children: [
            _CameraTopBar(
              onBack: () => Navigator.of(context).maybePop(),
              onHelp: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Справка — в разработке')),
                );
              },
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const _FakeReceiptBackground(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth * 0.82;
                      final h = constraints.maxHeight * 0.62;
                      return SizedBox(
                        width: w,
                        height: h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const _YellowCornerFrame(),
                            AnimatedBuilder(
                              animation: _scanController,
                              builder: (context, child) {
                                final t = _scanController.value;
                                final top = 12 + t * (h * 0.35);
                                return Positioned(
                                  top: top,
                                  left: 16,
                                  right: 16,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: ReceiptFlowColors.cameraAccent
                                          .withValues(alpha: 0.85),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ReceiptFlowColors.cameraAccent
                                              .withValues(alpha: 0.5),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Text(
                        'Выровняйте чек в рамке',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _CameraBottomBar(
              flashLabel: flashLabel,
              onGallery: () => cubit.pickFromGallery(),
              onCapture: () => cubit.captureWithCamera(),
              onFlash: () => cubit.cycleFlash(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraTopBar extends StatelessWidget {
  const _CameraTopBar({required this.onBack, required this.onHelp});

  final VoidCallback onBack;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
            ),
            const Expanded(
              child: Text(
                'Чек',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: onHelp,
              icon: const Icon(Icons.help_outline_rounded),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeReceiptBackground extends StatelessWidget {
  const _FakeReceiptBackground();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            width: constraints.maxWidth * 0.88,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomPaint(
              painter: _ReceiptSilhouettePainter(),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Text(
                    'RECEIPT',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint zig = Paint()..color = const Color(0xFF3D3D3D);
    const double tooth = 6;
    for (double x = 0; x < size.width; x += tooth * 2) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + tooth, tooth)
        ..lineTo(x + tooth * 2, 0);
      canvas.drawPath(path, zig);
    }
    for (double x = 0; x < size.width; x += tooth * 2) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + tooth, size.height - tooth)
        ..lineTo(x + tooth * 2, size.height);
      canvas.drawPath(path, zig);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _YellowCornerFrame extends StatelessWidget {
  const _YellowCornerFrame();

  @override
  Widget build(BuildContext context) {
    const len = ReceiptFlowUiConstants.cornerBracketLength;
    const t = ReceiptFlowUiConstants.cornerBracketThickness;
    const c = ReceiptFlowColors.cameraAccent;

    Widget corner(Alignment a, double rot) {
      return Align(
        alignment: a,
        child: Transform.rotate(
          angle: rot,
          child: SizedBox(
            width: len,
            height: len,
            child: CustomPaint(
              painter: _LCornerPainter(color: c, thickness: t),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        corner(Alignment.topLeft, 0),
        corner(Alignment.topRight, 1.5708),
        corner(Alignment.bottomRight, 3.14159),
        corner(Alignment.bottomLeft, -1.5708),
      ],
    );
  }
}

class _LCornerPainter extends CustomPainter {
  _LCornerPainter({required this.color, required this.thickness});

  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..lineTo(0, 0)
        ..lineTo(size.width, 0),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CameraBottomBar extends StatelessWidget {
  const _CameraBottomBar({
    required this.flashLabel,
    required this.onGallery,
    required this.onCapture,
    required this.onFlash,
  });

  final String flashLabel;
  final VoidCallback onGallery;
  final VoidCallback onCapture;
  final VoidCallback onFlash;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ReceiptFlowColors.cameraBackground,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _SideControl(
            icon: Icons.photo_library_outlined,
            label: 'GALLERY',
            onTap: onGallery,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ReceiptFlowColors.cameraAccent.withValues(
                        alpha: 0.45,
                      ),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: ReceiptFlowColors.cameraAccent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onCapture,
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.photo_camera_rounded,
                        color: Color(0xFF1A1A1A),
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _SideControl(
            icon: Icons.flash_on_rounded,
            label: flashLabel,
            onTap: onFlash,
          ),
        ],
      ),
    );
  }
}

class _SideControl extends StatelessWidget {
  const _SideControl({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF2E2E2E),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
