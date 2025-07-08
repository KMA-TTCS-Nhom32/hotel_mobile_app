import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/utils/logger.dart';
import '../domain/entities/branch.dart';
import '../domain/entities/province.dart';
import '../domain/entities/paginated_response.dart';
import '../domain/entities/featured_hotel.dart';
import '../data/repositories/home_repository.dart';

/// Enum representing the state of the home controller
enum HomeState { initial, loading, success, error }

/// Provider for the home repository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return serviceLocator<HomeRepository>();
});

/// Provider for the latest branches (featured hotels)
final latestBranchesProvider = FutureProvider<List<Branch>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return await repository.getLatestBranches();
});

/// Provider for provinces (destinations)
final provincesProvider = FutureProvider<PaginatedResponse<Province>>((
  ref,
) async {
  final repository = ref.watch(homeRepositoryProvider);
  final provinces = await repository.getProvinces();

  // Auto-select the first province if we have provinces and none is currently selected
  if (provinces.data.isNotEmpty &&
      ref.read(selectedProvinceIdProvider) == null) {
    // Use a microtask to avoid changing state during the build phase
    Future.microtask(() {
      ref.read(selectedProvinceIdProvider.notifier).state =
          provinces.data.first.id;
    });
  }

  return provinces;
});

/// Provider for the currently selected province
final selectedProvinceIdProvider = StateProvider<String?>((ref) => null);

/// Provider for branches by selected province
final branchesByProvinceProvider = FutureProvider<PaginatedResponse<Branch>?>((
  ref,
) async {
  final selectedProvinceId = ref.watch(selectedProvinceIdProvider);
  if (selectedProvinceId == null) return null;

  final repository = ref.watch(homeRepositoryProvider);
  return await repository.getBranchesByProvince(provinceId: selectedProvinceId);
});

/// Controller for managing the refresh of data
class HomeRefreshController extends StateNotifier<bool> {
  final Ref _ref;
  final AppLogger _logger = AppLogger();

  HomeRefreshController(this._ref) : super(false);

  /// Refresh all data
  Future<void> refreshAll() async {
    _logger.d('Refreshing all home data');
    state = true;

    try {
      // Invalidate all cached data to force refresh
      final latestBranchesResult = await _ref.refresh(
        latestBranchesProvider.future,
      );
      _logger.d(
        'Latest branches refreshed: ${latestBranchesResult.length} items',
      );

      final provincesResult = await _ref.refresh(provincesProvider.future);
      _logger.d('Provinces refreshed: ${provincesResult.data.length} items');

      // Select first province if none is selected and provinces are available
      if (provincesResult.data.isNotEmpty &&
          _ref.read(selectedProvinceIdProvider) == null) {
        selectFirstProvince();
      }

      final selectedProvinceId = _ref.read(selectedProvinceIdProvider);
      if (selectedProvinceId != null) {
        final branchesResult = await _ref.refresh(
          branchesByProvinceProvider.future,
        );
        if (branchesResult != null) {
          _logger.d(
            'Branches for province refreshed: ${branchesResult.data.length} items',
          );
        }
      }

      _logger.d('Successfully refreshed all home data');
    } catch (e) {
      _logger.e('Error refreshing home data', e);
    } finally {
      state = false;
    }
  }

  /// Explicitly select the first province from the loaded provinces
  void selectFirstProvince() {
    final provinces = _ref.read(provincesProvider).value?.data;
    if (provinces != null && provinces.isNotEmpty) {
      _logger.d('Auto-selecting first province: ${provinces.first.name}');
      _ref.read(selectedProvinceIdProvider.notifier).state = provinces.first.id;
    }
  }
}

/// Provider for the home refresh controller
final homeRefreshControllerProvider =
    StateNotifierProvider<HomeRefreshController, bool>((ref) {
      return HomeRefreshController(ref);
    });

/// Class representing the home controller state
class HomeControllerState {
  final HomeState state;
  final List<FeaturedHotel> hotels;
  final String? errorMessage;
  final Object? error;

  const HomeControllerState({
    required this.state,
    this.hotels = const [],
    this.errorMessage,
    this.error,
  });

  /// Create a copy of this state with the provided values
  HomeControllerState copyWith({
    HomeState? state,
    List<FeaturedHotel>? hotels,
    String? errorMessage,
    Object? error,
  }) {
    return HomeControllerState(
      state: state ?? this.state,
      hotels: hotels ?? this.hotels,
      errorMessage: errorMessage ?? this.errorMessage,
      error: error ?? this.error,
    );
  }

  /// Helper method for when pattern matching
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<FeaturedHotel> hotels) success,
    required T Function(String? message, Object? error) error,
  }) {
    switch (state) {
      case HomeState.initial:
        return initial();
      case HomeState.loading:
        return loading();
      case HomeState.success:
        return success(hotels);
      case HomeState.error:
        return error(errorMessage, this.error);
    }
  }
}

/// Home controller for managing the home screen
class HomeController extends StateNotifier<HomeControllerState> {
  final Ref _ref;
  final AppLogger _logger = AppLogger();

  HomeController(this._ref)
    : super(const HomeControllerState(state: HomeState.initial));

  /// Fetch featured hotels
  Future<void> fetchFeaturedHotels() async {
    _logger.d('Fetching featured hotels');
    state = state.copyWith(state: HomeState.loading);

    try {
      final repository = _ref.read(homeRepositoryProvider);
      final branches = await repository.getLatestBranches();

      // Convert branches to featured hotels
      final featuredHotels =
          branches
              .map(
                (branch) => FeaturedHotel(
                  id: branch.id,
                  name: branch.name,
                  description: branch.description,
                  imageUrl: branch.thumbnail.url,
                  rating: branch.rating ?? 4.0,
                  price: 0.0, // Price not available in API
                  location: branch.province?.name ?? branch.address,
                ),
              )
              .toList();

      state = state.copyWith(state: HomeState.success, hotels: featuredHotels);

      _logger.d(
        'Successfully fetched ${featuredHotels.length} featured hotels',
      );
    } catch (e) {
      _logger.e('Error fetching featured hotels', e);
      state = state.copyWith(
        state: HomeState.error,
        errorMessage: 'Failed to load hotels: ${e.toString()}',
        error: e,
      );
    }
  }
}

/// Provider for the home controller
final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeControllerState>((ref) {
      return HomeController(ref);
    });
