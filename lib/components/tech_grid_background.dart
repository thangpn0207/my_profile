import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/app_colors.dart';

class TechGridBackground extends StatefulWidget {
  const TechGridBackground({super.key, required this.pointer});

  /// Pointer position in this widget's local (painter) coordinates, or null.
  final ValueListenable<Offset?> pointer;

  @override
  State<TechGridBackground> createState() => _TechGridBackgroundState();
}

class _TechGridBackgroundState extends State<TechGridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrapped in RepaintBoundary for performance
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, widget.pointer]),
        builder: (context, child) {
          return CustomPaint(
            painter: GridPainter(_controller.value, widget.pointer.value),
            child: Container(),
          );
        },
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double animationValue;
  final Offset? pointer;
  GridPainter(this.animationValue, this.pointer);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    final offset = animationValue * spacing;

    void drawGrid(Paint p) {
      for (double i = -spacing; i < size.width + spacing; i += spacing) {
        canvas.drawLine(
          Offset(i + (offset % spacing), 0),
          Offset(i + (offset % spacing), size.height),
          p,
        );
      }
      for (double i = -spacing; i < size.height + spacing; i += spacing) {
        canvas.drawLine(
          Offset(0, i + (offset % spacing)),
          Offset(size.width, i + (offset % spacing)),
          p,
        );
      }
    }

    drawGrid(paint);

    final pointer = this.pointer;
    if (pointer != null) {
      const radius = 250.0;
      final rect = Rect.fromCircle(center: pointer, radius: radius);
      canvas.drawCircle(
        pointer,
        radius,
        Paint()
          ..shader = RadialGradient(colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0),
          ]).createShader(rect),
      );
      canvas.save();
      canvas.clipPath(Path()..addOval(rect));
      drawGrid(Paint()
        ..color = AppColors.primary.withValues(alpha: 0.18)
        ..strokeWidth = 1.0);
      canvas.restore();
    }

    // Add subtle glow spots
    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.03)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    for (int i = 0; i < 5; i++) {
      final random = math.Random(i * 100);
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 150, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.pointer != pointer;
}
