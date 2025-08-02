import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moviedb_app/config/router/app_router.dart';
import 'package:moviedb_app/config/theme/app_theme.dart';
import 'package:moviedb_app/presentation/providers/theme/theme_provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(
      const ProviderScope(child: MainApp())
    );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isDarkMode: themeMode).getAppTheme,
    );
  }
}
