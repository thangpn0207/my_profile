import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/terminal/terminal_panel.dart';
import 'package:responsive_framework/responsive_framework.dart';

class _FakeStorage implements Storage {
  final _m = <String, dynamic>{};
  @override
  dynamic read(String key) => _m[key];
  @override
  Future<void> write(String key, dynamic value) async => _m[key] = value;
  @override
  Future<void> delete(String key) async => _m.remove(key);
  @override
  Future<void> clear() async => _m.clear();
  @override
  Future<void> close() async {}
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  setUp(() => HydratedBloc.storage = _FakeStorage());

  Future<void> pump(WidgetTester t) async {
    await t.pumpWidget(BlocProvider(
      create: (_) => MyInfoBloc(),
      child: MaterialApp(
        builder: (c, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: double.infinity, name: DESKTOP),
          ],
        ),
        home: const Scaffold(body: TerminalPanel()),
      ),
    ));
  }

  testWidgets('input hint visible before focus', (t) async {
    await pump(t);
    expect(find.text("type 'help'  ·  ⌘K / Ctrl+K to jump"), findsOneWidget);
  });

  testWidgets('typing help prints commands', (t) async {
    await pump(t);
    await t.enterText(find.byType(TextField), 'help');
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pump();
    expect(find.textContaining('whoami'), findsWidgets);
  });

  testWidgets('tapping projects chip echoes command', (t) async {
    await pump(t);
    await t.tap(find.widgetWithText(ActionChip, 'projects'));
    await t.pump();
    expect(find.text(r'$ projects'), findsOneWidget);
  });

  Future<void> submit(WidgetTester t, String v) async {
    await t.enterText(find.byType(TextField), v);
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pump();
  }

  String field(WidgetTester t) =>
      t.widget<TextField>(find.byType(TextField)).controller!.text;

  testWidgets('whoami without data says not loaded', (t) async {
    await pump(t);
    await submit(t, 'whoami');
    expect(find.text('data not loaded yet'), findsOneWidget);
  });

  testWidgets('whitespace-only Enter adds nothing and clears field', (t) async {
    await pump(t);
    final before = find.byType(Text).evaluate().length;
    await submit(t, '   ');
    expect(find.byType(Text).evaluate().length, before);
    expect(field(t), '');
  });

  testWidgets('ArrowUp/ArrowDown walk history', (t) async {
    await pump(t);
    await submit(t, 'help');
    await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await t.pump();
    expect(field(t), 'help');
    await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await t.pump();
    expect(field(t), '');
  });
}
