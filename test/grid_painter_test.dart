import 'package:flutter_test/flutter_test.dart';
import 'package:my_profile/components/tech_grid_background.dart';

void main() {
  test('GridPainter repaints only when animation or pointer changes', () {
    final a = GridPainter(0.1, const Offset(1, 2));
    expect(a.shouldRepaint(GridPainter(0.1, const Offset(1, 2))), isFalse);
    expect(a.shouldRepaint(GridPainter(0.1, const Offset(3, 2))), isTrue);
    expect(a.shouldRepaint(GridPainter(0.1, null)), isTrue);
    expect(a.shouldRepaint(GridPainter(0.2, const Offset(1, 2))), isTrue);
  });
}
