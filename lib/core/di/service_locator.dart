import 'package:get_it/get_it.dart';

import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

/// Global service locator instance
final GetIt serviceLocator = GetIt.instance;

/// Initializes service locator with all dependencies
Future<void> initializeServiceLocator() async {
  // Register services as singletons
  _registerServices();

  // Register repositories as singletons
  _registerRepositories();

  // Register controllers as lazy singletons
  _registerControllers();

  // Register use cases as factories
  _registerUseCases();
}

void _registerServices() {
  // API service for network requests
  serviceLocator.registerSingleton<ApiService>(ApiService());

  // Secure storage for sensitive data
  serviceLocator.registerSingleton<SecureStorageService>(
    SecureStorageService(),
  );
}

void _registerRepositories() {
  // Auth repository
  serviceLocator.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      serviceLocator<ApiService>(),
      serviceLocator<SecureStorageService>(),
    ),
  );
}

void _registerControllers() {
  // Example:
  // serviceLocator.registerLazySingleton<AuthController>(
  //   () => AuthController(userRepository: serviceLocator<UserRepository>()),
  // );
}

void _registerUseCases() {
  // Example:
  // serviceLocator.registerFactory<LoginUseCase>(
  //   () => LoginUseCase(userRepository: serviceLocator<UserRepository>()),
  // );
}
