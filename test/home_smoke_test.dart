import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_profile/components/matrix_rain_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/terminal/terminal_panel.dart';
import 'package:my_profile/screens/home/home_screen.dart';
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
  testWidgets('HomeScreen renders terminal at desktop size', (t) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    HydratedBloc.storage = _FakeStorage();
    t.view.physicalSize = const Size(1440, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);

    final bloc = MyInfoBloc();
    addTearDown(() => t.runAsync(bloc.close));
    await t.pumpWidget(BlocProvider.value(
      value: bloc,
      child: MaterialApp(
        builder: (c, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: double.infinity, name: DESKTOP),
          ],
        ),
        home: const Scaffold(body: HomeScreen()),
      ),
    ));
    bloc.add(OnInit());
    await t.runAsync(() => bloc.stream
        .firstWhere((s) => s.loadingState == LoadingState.loaded)
        .timeout(const Duration(seconds: 5)));
    await t.pump(const Duration(seconds: 1));

    expect(find.byType(TerminalPanel), findsOneWidget);
    expect(t.takeException(), isNull);

    Future<void> konami() async {
      for (final k in [
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
      ]) {
        await t.sendKeyEvent(k);
      }
      await t.pump();
    }

    // Typing in the terminal must not trigger the easter egg.
    await t.tap(find.byType(TextField));
    await t.pump();
    await konami();
    expect(find.byType(MatrixRainOverlay), findsNothing);

    FocusManager.instance.primaryFocus?.unfocus();
    await t.pump();
    await konami();
    expect(find.byType(MatrixRainOverlay), findsOneWidget);
    await t.pump(const Duration(seconds: 6));
    expect(find.byType(MatrixRainOverlay), findsNothing);

    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 6));
  });
}
