import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RevealScope extends InheritedWidget {
  const RevealScope({super.key, required this.revealed, required super.child});

  final bool revealed;

  static bool? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RevealScope>()?.revealed;

  static bool of(BuildContext context) => maybeOf(context) ?? false;

  @override
  bool updateShouldNotify(RevealScope old) => revealed != old.revealed;
}

/// Fades/slides [child] in once its top enters the viewport. The child stays
/// laid out (opacity 0) until then so scroll extents are stable.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  bool _revealed = false;
  ScrollPosition? _position;
  ScrollableState? _scrollable;

  /// Nearest enclosing vertical Scrollable that can actually scroll (skips
  /// shrink-wrapped, non-scrollable inner lists such as the project grid).
  ScrollableState? _findScrollable() {
    var s = Scrollable.maybeOf(context);
    while (s != null &&
        (s.position.physics is NeverScrollableScrollPhysics ||
            axisDirectionToAxis(s.axisDirection) != Axis.vertical)) {
      s = Scrollable.maybeOf(s.context);
    }
    return s;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_revealed) return;
    _scrollable = _findScrollable();
    final position = _scrollable?.position;
    if (position == null || MediaQuery.disableAnimationsOf(context)) {
      _revealed = true;
      return;
    }
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position..addListener(_check);
      WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    }
  }

  void _check() {
    if (!mounted || _revealed) return;
    final box = context.findRenderObject() as RenderBox?;
    final viewport = _scrollable?.context.findRenderObject() as RenderBox?;
    if (box == null || viewport == null || !box.hasSize || !viewport.hasSize) {
      return;
    }
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = viewport.localToGlobal(Offset(0, viewport.size.height)).dy;
    if (top < bottom - 40) {
      _position?.removeListener(_check);
      _position = null;
      setState(() => _revealed = true);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return RevealScope(
      revealed: _revealed,
      child: reduced
          ? widget.child
          : widget.child
              .animate(target: _revealed ? 1 : 0)
              .fadeIn(duration: 500.ms, delay: widget.delay)
              .slideY(begin: .08, end: 0),
    );
  }
}
