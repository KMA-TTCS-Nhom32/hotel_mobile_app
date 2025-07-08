import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations_exports.dart';
import '../../../../core/utils/logger.dart';
import '../../../../features/branch_detail/presentation/pages/branch_detail_screen.dart';
import '../../controller/home_controller.dart';
import '../../domain/entities/branch.dart';
import '../widgets/featured_hotels_carousel.dart';
import '../widgets/popular_destinations_section.dart';
import '../widgets/quick_booking_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    // Allow the widget to initialize first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if provinces are already loaded and auto-select if needed
      final provincesAsync = ref.read(provincesProvider);
      if (provincesAsync.hasValue &&
          ref.read(selectedProvinceIdProvider) == null) {
        ref.read(homeRefreshControllerProvider.notifier).selectFirstProvince();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();
    final refreshState = ref.watch(homeRefreshControllerProvider);

    // Watch our providers
    final latestBranchesAsync = ref.watch(latestBranchesProvider);
    final provincesAsync = ref.watch(provincesProvider);
    final selectedProvinceId = ref.watch(selectedProvinceIdProvider);
    final branchesByProvinceAsync =
        selectedProvinceId != null
            ? ref.watch(branchesByProvinceProvider)
            : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigation to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigation to notifications screen
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh all data
            await ref.read(homeRefreshControllerProvider.notifier).refreshAll();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.homeWelcome(AppLocalizations.of(context)!.guest),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const QuickBookingSection(),
                    const SizedBox(height: 16),

                    // Featured hotels carousel with API data
                    latestBranchesAsync.when(
                      data: (branches) {
                        logger.d('Loaded ${branches.length} branches');
                        return FeaturedHotelsCarousel(branchesList: branches);
                      },
                      loading:
                          () => const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      error: (error, stack) {
                        logger.e('Error loading branches', error);
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Text('Error loading featured hotels'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Popular destinations with API data
                    provincesAsync.when(
                      data: (paginatedProvinces) {
                        final provinces = paginatedProvinces.data;
                        logger.d('Loaded ${provinces.length} provinces');
                        return PopularDestinationsSection(
                          provinces: provinces,
                          selectedProvinceId: selectedProvinceId,
                          onProvinceSelected: (province) {
                            // Update selected province
                            ref
                                .read(selectedProvinceIdProvider.notifier)
                                .state = province.id;
                            logger.d('Selected province: ${province.name}');
                          },
                        );
                      },
                      loading:
                          () => const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      error: (error, stack) {
                        logger.e('Error loading provinces', error);
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Text('Error loading destinations'),
                          ),
                        );
                      },
                    ),

                    // Branches by province (when a province is selected)
                    if (selectedProvinceId != null &&
                        branchesByProvinceAsync != null)
                      branchesByProvinceAsync.when(
                        data: (paginatedBranches) {
                          if (paginatedBranches == null) {
                            return const SizedBox.shrink();
                          }
                          final branches = paginatedBranches.data;
                          return Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          // Get province name from the selected province
                                          final province = provincesAsync
                                              .value
                                              ?.data
                                              .firstWhere(
                                                (p) =>
                                                    p.id == selectedProvinceId,
                                              );
                                          final currentLocale =
                                              Localizations.localeOf(
                                                context,
                                              ).languageCode;
                                          final provinceName =
                                              province?.getLocalizedName(
                                                currentLocale,
                                              ) ??
                                              '';

                                          return Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.hotelsInProvince(provinceName),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Clear selection
                                          ref
                                              .read(
                                                selectedProvinceIdProvider
                                                    .notifier,
                                              )
                                              .state = null;
                                        },
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.clearButton,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                branches.isEmpty
                                    ? Center(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.noHotelsFound,
                                      ),
                                    )
                                    : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      itemCount: branches.length,
                                      itemBuilder: (context, index) {
                                        final branch = branches[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: _ProvinceHotelCard(
                                            branch: branch,
                                          ),
                                        );
                                      },
                                    ),
                              ],
                            ),
                          );
                        },
                        loading:
                            () => const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        error: (error, stack) {
                          logger.e('Error loading branches by province', error);
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.0),
                              child: Text(
                                'Error loading hotels for this location',
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Global loading overlay when refreshing
              if (refreshState)
                Container(
                  color: Colors.black.withAlpha((0.3 * 255).toInt()),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card widget to display hotels in a province
class _ProvinceHotelCard extends StatelessWidget {
  final Branch branch;

  const _ProvinceHotelCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    // Get current locale for localization
    final currentLocale = Localizations.localeOf(context).languageCode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Create logger instance
          final logger = AppLogger();

          // Debug info about the branch ID
          logger.d('Province list: Tapped branch ID: "${branch.id}"');
          logger.d(
            'Province list: Branch ID type: ${branch.id.runtimeType}, length: ${branch.id.length}',
          );

          // Check for potential issues with the branch ID
          if (branch.id.contains(' ')) {
            logger.w('Province list: Warning - Branch ID contains spaces');
          }

          // Sanitize the branch ID before navigation
          final sanitizedId = branch.id.trim();
          if (branch.id != sanitizedId) {
            logger.w(
              'Province list: Branch ID needed trimming - original: "${branch.id}", sanitized: "$sanitizedId"',
            );
          }

          // Navigate to branch detail screen with sanitized ID
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BranchDetailScreen(branchId: sanitizedId),
            ),
          );
        },
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/placeholder.txt',
                    image: branch.thumbnail.url,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Hotel details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel name with tooltip showing description
                      Tooltip(
                        message: branch.getLocalizedDescription(currentLocale),
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        waitDuration: const Duration(milliseconds: 500),
                        showDuration: const Duration(seconds: 3),
                        child: Text(
                          branch.getLocalizedName(currentLocale),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              branch.getLocalizedAddress(currentLocale),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Rating and Price Row
                      Row(
                        children: [
                          // Rating
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            branch.rating?.toStringAsFixed(1) ?? 'N/A',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          // Price placeholder (we'll need to add pricing data later)
                          Text(
                            'From \$100',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
