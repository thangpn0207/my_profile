import 'package:flutter/material.dart';
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
}
