import 'package:hotel_mobile_app/core/services/api_service.dart';
import 'package:hotel_mobile_app/core/utils/logger.dart';
import 'package:hotel_mobile_app/features/branch_detail/domain/entities/branch_detail.dart';

abstract class BranchDetailRepository {
  Future<BranchDetail> getBranchDetail(String branchId);
}

class BranchDetailRepositoryImpl implements BranchDetailRepository {
  final ApiService _apiService;

  BranchDetailRepositoryImpl(this._apiService);

  @override
  Future<BranchDetail> getBranchDetail(String branchId) async {
    final logger = AppLogger();
    try {
      // Trim the branch ID to handle any potential whitespace
      final trimmedId = branchId.trim();

      // Add debug logging to track the branch ID
      logger.d(
        'Getting branch detail for ID: "$trimmedId" (original ID: "$branchId")',
      );
      logger.d(
        'Branch ID type: ${branchId.runtimeType}, length: ${branchId.length}',
      );

      final response = await _apiService.get('/branches/$trimmedId');
      logger.d('API response received for branch ID: $trimmedId');

      // Check if the response data is null
      if (response.data == null) {
        logger.e('Response data is null for branch ID $trimmedId');
        throw Exception('Response data is null for branch ID $trimmedId');
      }

      // Log the data structure for debugging
      logger.d('Response data type: ${response.data.runtimeType}');

      // Try to parse the data into a BranchDetail object
      final branchDetail = BranchDetail.fromJson(response.data);
      logger.d('Successfully parsed BranchDetail for ID $trimmedId');

      return branchDetail;
    } catch (e, stackTrace) {
      logger.e('Error fetching branch detail for ID $branchId', e, stackTrace);
      rethrow;
    }
  }
}
