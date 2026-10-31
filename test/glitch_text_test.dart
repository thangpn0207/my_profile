import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_profile/components/glitch_text.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('ghost layers are excluded from semantics', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    // Breakpoints resolve after the first frame, so mount them first.
    Widget app(Widget home) => MaterialApp(
          builder: (c, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 450, name: MOBILE),
              Breakpoint(start: 451, end: double.infinity, name: DESKTOP),
            ],
          ),
          home: home,
        );
    await tester.pumpWidget(app(const SizedBox()));
    await tester.pump();
    await tester
        .pumpWidget(app(const GlitchText('PROJECT_LOGS', style: TextStyle())));
    await tester.pump(const Duration(milliseconds: 50));
    // Mid-jitter: main + 2 ghost Texts exist, but only one is semantic.
    expect(find.text('PROJECT_LOGS'), findsNWidgets(3));
    expect(find.bySemanticsLabel('PROJECT_LOGS'), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
