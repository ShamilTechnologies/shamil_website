import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamil_web/features/home/presentation/screens/home_screen.dart';
// Ensure this path is correct and the ProviderServicesScreen is defined as updated above
import 'package:shamil_web/features/providers/presentation/screens/provider_services_screen.dart';

class AppRouter {
  AppRouter._();

  static const String homePath = '/';
  static const String providerServicesPath = '/provider-services';

  static final GoRouter router = GoRouter(
    initialLocation: homePath,
    debugLogDiagnostics: true, // Useful for debugging navigation issues
    routes: <RouteBase>[
      GoRoute(
        path: homePath,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: providerServicesPath,
        name: 'provider-services',
        builder: (BuildContext context, GoRouterState state) {
          // This now navigates to the ProviderServicesScreen which handles its own loading state
          return const ProviderServicesScreen();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold( // Basic error page
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('Error: ${state.error?.message ?? 'Page not found'}'),
      ),
    ),
  );
}