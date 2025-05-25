import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/index.dart';
import 'features/navigation/presentation/pages/main_navigation_screen.dart';

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

  // Initialize LocaleProvider
  final localeProvider = LocaleProvider();
  await localeProvider.init();

  runApp(
    ChangeNotifierProvider<LocaleProvider>(
      create: (_) => localeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Get current locale from provider
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'AHomeVilla Hotel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Localization configuration
      locale: localeProvider.locale,
      supportedLocales: LocalizationConfig.supportedLocales,
      localizationsDelegates: LocalizationConfig.localizationsDelegates,
      localeResolutionCallback: LocalizationConfig.localeResolutionCallback,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default to light theme
      home: const MainNavigationScreen(),
    );
  }
}
