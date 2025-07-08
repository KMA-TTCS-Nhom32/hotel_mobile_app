import '../../../../core/di/service_locator.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/branch.dart';
import '../../domain/entities/province.dart';
import '../../domain/entities/paginated_response.dart';

/// Repository for home-related API requests
class HomeRepository {
  final ApiService _apiService;
  final AppLogger _logger = AppLogger();

  HomeRepository({ApiService? apiService})
    : _apiService = apiService ?? serviceLocator<ApiService>();

  /// Fetch latest hotel branches
  Future<List<Branch>> getLatestBranches({int limit = 3}) async {
    try {
      _logger.d('Fetching latest branches with limit: $limit');
      final response = await _apiService.get('/branches/latest?limit=$limit');

      final List<Branch> branches =
          (response.data as List<dynamic>)
              .map((json) => Branch.fromJson(json as Map<String, dynamic>))
              .toList();

      _logger.d('Fetched ${branches.length} latest branches');
      return branches;
    } catch (e) {
      _logger.e('Failed to fetch latest branches', e);
      rethrow;
    }
  }

  /// Fetch provinces with pagination
  Future<PaginatedResponse<Province>> getProvinces({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      _logger.d('Fetching provinces - page: $page, pageSize: $pageSize');
      final response = await _apiService.get(
        '/provinces',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      final result = PaginatedResponse<Province>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Province.fromJson(json),
      );

      _logger.d('Fetched ${result.data.length} provinces');
      return result;
    } catch (e) {
      _logger.e('Failed to fetch provinces', e);
      rethrow;
    }
  }

  /// Fetch branches by province ID with pagination
  Future<PaginatedResponse<Branch>> getBranchesByProvince({
    required String provinceId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      _logger.d(
        'Fetching branches for province $provinceId - page: $page, pageSize: $pageSize',
      );

      // Create filter JSON string for the API - this is what the backend expects
      final filtersJson = '{"provinceId":"$provinceId"}';

      final response = await _apiService.get(
        '/branches',
        queryParameters: {
          'filters': filtersJson,
          'page': page,
          'pageSize': pageSize,
        },
      );

      final result = PaginatedResponse<Branch>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Branch.fromJson(json),
      );

      _logger.d(
        'Fetched ${result.data.length} branches for province $provinceId',
      );
      return result;
    } catch (e) {
      _logger.e('Failed to fetch branches for province $provinceId', e);
      rethrow;
    }
  }
}
