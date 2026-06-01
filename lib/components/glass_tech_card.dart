import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:ui';

import '../../../core/app_colors.dart';

class TechCardDecoration extends CustomPainter {
  final Color color;
  final double borderWidth;

  TechCardDecoration({required this.color, this.borderWidth = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    const cornerSize = 15.0;
    const cutSize = 8.0;

    // Top Left - Technical Corner
    path.moveTo(0, cornerSize);
    path.lineTo(0, 0);
    path.lineTo(cornerSize, 0);

    // Top Right - Technical Corner
    path.moveTo(size.width - cornerSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerSize);

    // Bottom Right - Diagonal Cut
    path.moveTo(size.width, size.height - cornerSize);
    path.lineTo(size.width, size.height - cutSize);
    path.lineTo(size.width - cutSize, size.height);
    path.lineTo(size.width - cornerSize, size.height);

    // Bottom Left - Technical Corner
    path.moveTo(cornerSize, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerSize);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlassTechCard extends StatefulWidget {
  final Widget child;
  final bool isHovered;

  const GlassTechCard({super.key, required this.child, this.isHovered = false});

  @override
  State<GlassTechCard> createState() => _GlassTechCardState();
}

class _GlassTechCardState extends State<GlassTechCard> {
  double rotateX = 0;
  double rotateY = 0;
  Offset mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return MouseRegion(
      onHover: (event) {
        if (!widget.isHovered || isMobile) return;
        final size = context.size!;
        final centerX = size.width / 2;
        final centerY = size.height / 2;
        setState(() {
          rotateY = (event.localPosition.dx - centerX) / centerX * 0.08;
          rotateX = (centerY - event.localPosition.dy) / centerY * 0.08;
          mousePos = event.localPosition;
        });
      },
      onExit: (_) => setState(() {
        rotateX = 0;
        rotateY = 0;
        mousePos = Offset.zero;
      }),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002) // Perspective
          ..rotateX(rotateX)
          ..rotateY(rotateY),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: widget.isHovered && !isMobile
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: 300.ms,
                decoration: BoxDecoration(
                  color: widget.isHovered
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.surface.withValues(alpha: 0.4),
                  border: Border.all(
                    color: widget.isHovered
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.hasBoundedWidth ? constraints.maxWidth : 300.0;
                    final height = constraints.hasBoundedHeight ? constraints.maxHeight : 200.0;
                    final size = Size(width, height);
                    return Stack(
                      children: [
                        CustomPaint(
                          size: Size.infinite,
                          painter: TechCardDecoration(
                            color: widget.isHovered
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        
                        // Dynamic Specular Shine / Glass light reflection highlight
                        if (widget.isHovered && !isMobile)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment(
                                      (mousePos.dx / (size.width > 0 ? size.width : 1)) * 2 - 1,
                                      (mousePos.dy / (size.height > 0 ? size.height : 1)) * 2 - 1,
                                    ),
                                    radius: 0.7,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.12),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                        widget.child,
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
