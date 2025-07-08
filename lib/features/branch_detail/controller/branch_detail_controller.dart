import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_mobile_app/core/di/service_locator.dart';
import 'package:hotel_mobile_app/core/utils/logger.dart';
import 'package:hotel_mobile_app/features/branch_detail/data/repositories/branch_detail_repository.dart';
import 'package:hotel_mobile_app/features/branch_detail/domain/entities/branch_detail.dart';

// Provider for the branch detail repository
final branchDetailRepositoryProvider = Provider<BranchDetailRepository>((ref) {
  return serviceLocator<BranchDetailRepository>();
});

// Provider to fetch branch detail by ID
final branchDetailProvider = FutureProvider.family<BranchDetail, String>((
  ref,
  branchId,
) async {
  final repository = ref.read(branchDetailRepositoryProvider);
  final logger = AppLogger();
  try {
    // Clean up branch ID to handle any potential issues
    final sanitizedBranchId = branchId.trim();

    logger.d('Starting to fetch branch detail for ID: "$sanitizedBranchId"');
    logger.d(
      'Original branch ID: "$branchId", Length: ${branchId.length}, Type: ${branchId.runtimeType}',
    );

    // Check if the branch ID has any issues
    if (branchId != sanitizedBranchId) {
      logger.w(
        'Branch ID needed trimming - original: "$branchId", sanitized: "$sanitizedBranchId"',
      );
    }

    if (sanitizedBranchId.isEmpty) {
      logger.e('Empty branch ID provided after sanitization');
      throw Exception('Invalid branch ID: Empty ID after sanitization');
    }

    final result = await repository.getBranchDetail(sanitizedBranchId);
    logger.d('Successfully fetched branch detail for ID: $sanitizedBranchId');
    return result;
  } catch (e, stackTrace) {
    logger.e('Error fetching branch detail for ID: "$branchId"', e, stackTrace);

    // Additional debug info
    logger.d('Branch ID that failed: "$branchId"');
    logger.d(
      'Branch ID type: ${branchId.runtimeType}, length: ${branchId.length}',
    );

    if (branchId.contains(' ')) {
      logger.w('Warning: Branch ID contains spaces');
    }

    throw e;
  }
});
