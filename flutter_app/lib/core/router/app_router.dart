import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_tts_flutter/features/auth/presentation/screens/splash_screen.dart';
import 'package:mock_tts_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:mock_tts_flutter/features/tts/presentation/screens/home_screen.dart';
import 'package:mock_tts_flutter/features/tts/presentation/screens/audio_player_screen.dart';
import 'package:mock_tts_flutter/features/tts/presentation/screens/audio_library_screen.dart';
import 'package:mock_tts_flutter/features/tts/presentation/screens/favorites_screen.dart';
import 'package:mock_tts_flutter/features/tts/presentation/screens/settings_screen.dart';
import 'package:mock_tts_flutter/features/tts/presentation/screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Shell route for bottom navigation
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AudioLibraryScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const FavoritesScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/player/:id',
        builder: (context, state) {
          final audioId = state.pathParameters['id']!;
          return AudioPlayerScreen(audioId: audioId);
        },
      ),
    ],
  );
});
