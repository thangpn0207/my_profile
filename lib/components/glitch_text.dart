import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Heading that jitters with red/cyan ghost layers for 400 ms on first build
/// and on desktop hover; plain [Text] otherwise.
class GlitchText extends StatefulWidget {
  const GlitchText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      if (!MediaQuery.disableAnimationsOf(context)) _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _layer(Color? color, Offset offset) => ExcludeSemantics(
        child: Transform.translate(
          offset: offset,
          child: Text(widget.text,
              style:
                  widget.style.copyWith(color: color!.withValues(alpha: 0.7))),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final main = Text(widget.text, style: widget.style);
    return MouseRegion(
      onEnter: (_) {
        if (ResponsiveBreakpoints.of(context).isDesktop &&
            !MediaQuery.disableAnimationsOf(context)) {
          _c.forward(from: 0);
        }
      },
      child: AnimatedBuilder(
        animation: _c,
        child: main,
        builder: (context, child) {
          if (!_c.isAnimating) return child!;
          // Alternate the jitter direction every ~50 ms.
          final s = (_c.value * 8).floor().isEven ? 2.0 : -2.0;
          return Stack(children: [
            _layer(Colors.red, Offset(s, 0)),
            _layer(Colors.cyan, Offset(-s, 0)),
            child!,
          ]);
        },
      ),
    );
  }
}
