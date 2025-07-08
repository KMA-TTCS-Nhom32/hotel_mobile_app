import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/service_locator.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/data/repositories/auth_repository.dart';

// Export providers
export 'navigation_provider.dart';
export 'auth_providers.dart';
export '../localization/locale_provider.dart';
export '../../features/home/controller/home_controller.dart';
export '../../features/auth/controller/auth_controller.dart';

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

/// List of provider overrides for the app
final List<Override> appProviderOverrides = [
  // Override auth repository provider to use instance from service locator
  authRepositoryProvider.overrideWithValue(serviceLocator<AuthRepository>()),
];
