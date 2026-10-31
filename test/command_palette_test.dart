import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_profile/components/command_palette.dart';
import 'package:my_profile/components/matrix_rain_overlay.dart';
import 'package:my_profile/components/terminal/terminal_commands.dart';
import 'package:my_profile/core/sections.dart';

Future<void> _open(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: Builder(
      builder: (c) => TextButton(
        onPressed: () => showCommandPalette(c, const TerminalContext()),
        child: const Text('open'),
      ),
    ),
  ));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('empty filter shows all sections plus cv and contact',
      (tester) async {
    await _open(tester);
    for (final s in Section.values) {
      expect(find.text(s.label), findsOneWidget);
    }
    expect(find.text('cv'), findsOneWidget);
    expect(find.text('contact'), findsOneWidget);
  });

  testWidgets('filter is case-insensitive substring', (tester) async {
    await _open(tester);
    await tester.enterText(find.byType(TextField), 'PROJ');
    await tester.pump();
    expect(find.text(Section.projects.label), findsOneWidget);
    expect(find.text(Section.home.label), findsNothing);
    expect(find.text('cv'), findsNothing);
    expect(find.text('contact'), findsNothing);
  });

  testWidgets('Esc closes', (tester) async {
    await _open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('Ctrl+K fires while a TextField has focus', (tester) async {
    var fired = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
                fired++,
          },
          child: const TextField(autofocus: true),
        ),
      ),
    ));
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.control);
    expect(fired, 1);
  });

  group('konamiAdvance', () {
    const seq = [
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
    test('full sequence returns 10', () {
      var p = 0;
      for (final k in seq) {
        p = konamiAdvance(p, k);
      }
      expect(p, 10);
    });
    test('wrong key resets; ArrowUp restarts at 1', () {
      expect(konamiAdvance(4, LogicalKeyboardKey.keyX), 0);
      expect(konamiAdvance(4, LogicalKeyboardKey.arrowUp), 1);
      expect(konamiAdvance(0, LogicalKeyboardKey.arrowUp), 1);
      expect(konamiAdvance(1, LogicalKeyboardKey.arrowUp), 2);
    });
  });
}
