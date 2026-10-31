import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';

const _konami = [
  LogicalKeyboardKey.arrowUp,
  LogicalKeyboardKey.arrowUp,
  LogicalKeyboardKey.arrowDown,
  LogicalKeyboardKey.arrowDown,
  LogicalKeyboardKey.arrowLeft,
  LogicalKeyboardKey.arrowRight,
  LogicalKeyboardKey.arrowLeft,
  LogicalKeyboardKey.arrowRight,
  LogicalKeyboardKey.keyB,
  LogicalKeyboardKey.keyA,
];

/// Returns new progress; 10 means complete (caller resets to 0).
int konamiAdvance(int progress, LogicalKeyboardKey key) {
  if (progress < 0 || progress >= _konami.length) progress = 0;
  if (key == _konami[progress]) return progress + 1;
  return key == _konami[0] ? 1 : 0;
}

class MatrixRainOverlay extends StatefulWidget {
  const MatrixRainOverlay({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<MatrixRainOverlay> createState() => _MatrixRainOverlayState();
}

class _MatrixRainOverlayState extends State<MatrixRainOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    });

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: SizedBox.expand(
          child: CustomPaint(painter: _RainPainter(_c)),
        ),
      ),
    );
  }
}

class _RainPainter extends CustomPainter {
  _RainPainter(this.t) : super(repaint: t);

  final Animation<double> t;
  static const _cell = 16.0;
  static const _glyphs = 'ｱｲｳｴｵｶｷｸｹｺ0123456789';
  static const _trail = 12;
  // One painter per (glyph, trail shade): at most 22*12 entries.
  static final _cache = <String, TextPainter>{};

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size,
        Paint()..color = Colors.black.withValues(alpha: 0.3));
    final tick = (t.value * 5 * 12).floor(); // ~12 fps over 5 s
    final cols = (size.width / _cell).ceil();
    final rows = (size.height / _cell).ceil();
    for (var c = 0; c < cols; c++) {
      final r = Random(c);
      final speed = 1 + r.nextInt(2);
      final offset = r.nextInt(rows + _trail);
      final head = (offset + tick * speed) % (rows + _trail);
      for (var i = 0; i < _trail; i++) {
        final row = head - i;
        if (row < 0 || row >= rows) continue;
        final g = _glyphs[(c * 7 + row * 3 + tick ~/ 3) % _glyphs.length];
        final tp = _cache.putIfAbsent(
            '$g$i',
            () => TextPainter(
                  text: TextSpan(
                    text: g,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          AppColors.primary.withValues(alpha: 1 - i / _trail),
                    ),
                  ),
                  textDirection: TextDirection.ltr,
                )..layout());
        tp.paint(canvas, Offset(c * _cell, row * _cell));
      }
    }
  }

  @override
  bool shouldRepaint(_RainPainter old) => false; // repaint driven by animation
}
