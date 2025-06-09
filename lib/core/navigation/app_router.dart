// lib/core/navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamil_web/features/home/presentation/screens/home_screen.dart';
import 'package:shamil_web/features/providers/presentation/screens/provider_services_screen.dart';
import 'package:shamil_web/features/demo/simplified_dashboard_demo_screen.dart'; // Import the demo screen

class AppRouter {
  AppRouter._();

  static const String homePath = '/';
  static const String providerServicesPath = '/provider-services';
  static const String providerDashboardDemoPath = '/provider-dashboard-demo'; // New path

  static final GoRouter router = GoRouter(
    initialLocation: homePath,
    debugLogDiagnostics: true,
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
          return const ProviderServicesScreen();
        },
      ),
      // New Route for the Demo Screen
      GoRoute(
        path: providerDashboardDemoPath,
        name: 'provider-dashboard-demo',
        builder: (BuildContext context, GoRouterState state) {
          return const SimplifiedDashboardDemoScreen();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('Error: ${state.error?.message ?? 'Page not found'}'),
      ),
    ),
  );
}