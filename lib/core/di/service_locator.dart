import 'package:get_it/get_it.dart';

import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/branch_detail/data/repositories/branch_detail_repository.dart';

/// Global service locator instance
final GetIt serviceLocator = GetIt.instance;

/// Initializes service locator with all dependencies
Future<void> initializeServiceLocator() async {
  // Register services as singletons
  _registerServices();

  // Register repositories as singletons
  _registerRepositories();

  // Setup auth interceptor
  _setupAuthInterceptor();

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

  // Home repository
  serviceLocator.registerSingleton(
    HomeRepository(apiService: serviceLocator<ApiService>()),
  );

  // Branch detail repository
  serviceLocator.registerSingleton<BranchDetailRepository>(
    BranchDetailRepositoryImpl(serviceLocator<ApiService>()),
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

/// Setup auth interceptor with token refresh functionality
void _setupAuthInterceptor() {
  final apiService = serviceLocator<ApiService>();
  final authRepository = serviceLocator<AuthRepository>();

  // Create a function to handle refresh failures
  final onRefreshFailed = () {
    // Force logout and clear tokens
    authRepository.clearToken();

    // Note: We can't access Riverpod providers directly from here
    // The actual UI navigation will be handled by authControllerProvider
    // watching for state changes and redirecting accordingly
  };

  // Add auth interceptor to Dio instance
  apiService.addAuthInterceptor(authRepository, onRefreshFailed);
}
