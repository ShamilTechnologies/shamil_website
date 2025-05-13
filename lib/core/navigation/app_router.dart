import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamil_web/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  // Private constructor
  AppRouter._();

  // Define route constants for better management
  static const String homePath = '/';
  // Add other paths if needed (e.g., /provider-join, /privacy-policy)
  // static const String providerJoinPath = '/join';

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: homePath, // Start at the home page
    debugLogDiagnostics: true, // Log routing events in debug mode
    routes: <RouteBase>[
      GoRoute(
        path: homePath,
        name: 'home', // Optional name for navigation by name
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen(); // Main landing page
        },
        // Add sub-routes if your home page has sections navigated via URL
        // routes: <RouteBase>[
        //   // Example: If you had a separate page for providers
        //   // GoRoute(
        //   //   path: 'join', // becomes /join
        //   //   name: 'provider-join',
        //   //   builder: (BuildContext context, GoRouterState state) {
        //   //     return const ProviderJoinScreen();
        //   //   },
        //   // ),
        // ],
      ),
      // Add other top-level routes here
      // GoRoute(
      //   path: providerJoinPath,
      //   name: 'provider-join-alt', // Example alternative route
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const ProviderJoinScreen(); // Placeholder
      //   },
      // ),
    ],
    // Optional: Error handling for unknown routes
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('Error: ${state.error?.message ?? 'Page not found'}'),
      ),
    ),
  );
}