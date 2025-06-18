// Export providers
export 'navigation_provider.dart';
export '../localization/locale_provider.dart';
export '../../features/home/controller/home_controller.dart';

/// This file collects all the providers used in the app
/// for easier imports and organization
/// 
/// Instead of importing each provider individually, you can import
/// this file and access all providers from here.
/// 
/// Example:
/// ```dart
/// // Import this file
/// import 'package:hotel_mobile_app/core/providers/app_providers.dart';
/// 
/// // Use providers
/// final currentTab = ref.watch(navigationProvider);
/// final locale = ref.watch(localeNotifierProvider);
/// ```
