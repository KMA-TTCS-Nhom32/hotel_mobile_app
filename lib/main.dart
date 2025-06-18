import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/index.dart';
import 'features/navigation/presentation/pages/main_navigation_screen_riverpod.dart';
import 'core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
  );

  // Initialize service locator
  await initializeServiceLocator();

  // Run the app with ProviderScope for Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current locale from Riverpod
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp(
      title: 'AHomeVilla Hotel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Localization configuration
      locale: locale,
      supportedLocales: LocalizationConfig.supportedLocales,
      localizationsDelegates: LocalizationConfig.localizationsDelegates,
      localeResolutionCallback: LocalizationConfig.localeResolutionCallback,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default to light theme
      home: const MainNavigationScreenRiverpod(),
    );
  }
}
