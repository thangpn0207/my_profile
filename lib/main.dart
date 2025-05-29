import 'dart:ui_web';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'bloc/my_info_bloc.dart';
import 'core/app_route.dart';
import 'core/app_theme.dart';

void main() async {
  setUrlStrategy(const HashUrlStrategy()); // ✅ fix lỗi trắng trang
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyInfoBloc(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Pham Ngoc Thang',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
      ),
    );
    ;
  }
}
