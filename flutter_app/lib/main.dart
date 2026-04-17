import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_tts_flutter/core/theme/app_theme.dart';
import 'package:mock_tts_flutter/core/router/app_router.dart';
import 'package:mock_tts_flutter/features/tts/presentation/providers/tts_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: VoxAIApp()));
}

class VoxAIApp extends ConsumerWidget {
  const VoxAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'VoxAI - Text to Speech',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
