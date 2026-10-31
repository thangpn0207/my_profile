import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_profile/components/glitch_text.dart';

void main() {
  testWidgets('ghost layers are excluded from semantics', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: GlitchText('PROJECT_LOGS', style: TextStyle())));
    await tester.pump(const Duration(milliseconds: 50));
    // Mid-jitter: main + 2 ghost Texts exist, but only one is semantic.
    expect(find.text('PROJECT_LOGS'), findsNWidgets(3));
    expect(find.bySemanticsLabel('PROJECT_LOGS'), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
