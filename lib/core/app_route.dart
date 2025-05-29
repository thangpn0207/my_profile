import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';

/// Centralized routing configuration for the application
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// The route configuration
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      // Add more routes here as your app grows
      // Example:
      // GoRoute(
      //   path: '/profile',
      //   name: 'profile',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const ProfileScreen();
      //   },
      // ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
}

/// Error page widget
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text('Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall)
        ])));
  }
}
