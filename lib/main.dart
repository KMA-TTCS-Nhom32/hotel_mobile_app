import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/index.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/locale_provider.dart';
import 'features/navigation/presentation/pages/main_navigation_screen_riverpod.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/controller/auth_state.dart';

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
  // Run the app with ProviderScope for Riverpod with overrides
  runApp(ProviderScope(overrides: appProviderOverrides, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Helper method to determine the home screen based on auth state
  Widget _buildHomeScreen(AuthState state) {
    if (state is AuthAuthenticatedState) {
      return const MainNavigationScreenRiverpod();
    } else if (state is AuthLoadingState) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current locale from Riverpod (exported in app_providers.dart)
    final locale = ref.watch(localeNotifierProvider);

    // Get authentication state from Riverpod
    final authState = ref.watch(authControllerProvider);

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
      // Home is determined by auth state
      home: _buildHomeScreen(authState),
    );
  }
}
