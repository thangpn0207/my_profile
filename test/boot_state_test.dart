import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/screens/main/main_screen.dart';
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

  Future<MyInfoBloc> boot(WidgetTester t, Map<String, dynamic> seed) async {
    final storage = _FakeStorage();
    storage._m['MyInfoBloc'] = seed;
    HydratedBloc.storage = storage;
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
        home: const MainScreen(children: []),
      ),
    ));
    await t.pump(const Duration(seconds: 1));
    return bloc;
  }

  testWidgets('no boot overlay over cached data; loadingState not persisted',
      (t) async {
    final bloc = await boot(t, {
      'userInfo': {'name': 'Thang'},
      'loadingState': 'loading',
    });
    expect(bloc.state.userInfo, isNotNull);
    expect(find.text('SYSTEM_BOOTING'), findsNothing);
    expect(bloc.toJson(bloc.state)!.containsKey('loadingState'), isFalse);
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 6));
  });

  testWidgets('err state shows REBOOT which reloads data', (t) async {
    final bloc = await boot(t, {'loadingState': 'err'});
    expect(find.text('REBOOT'), findsOneWidget);
    await t.tap(find.text('REBOOT'));
    // Poll: the load may already have finished before we could subscribe.
    for (var i = 0;
        i < 50 && bloc.state.loadingState != LoadingState.loaded;
        i++) {
      await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)));
      await t.pump();
    }
    await t.pump(const Duration(seconds: 1));
    expect(bloc.state.loadingState, LoadingState.loaded);
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 6));
  });
}
