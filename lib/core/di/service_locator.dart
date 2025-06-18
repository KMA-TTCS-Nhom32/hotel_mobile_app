import 'package:get_it/get_it.dart';

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
  // Example:
  // serviceLocator.registerSingleton<ApiService>(ApiServiceImpl());
}

void _registerRepositories() {
  // Example:
  // serviceLocator.registerSingleton<UserRepository>(
  //   UserRepositoryImpl(apiService: serviceLocator<ApiService>()),
  // );
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
