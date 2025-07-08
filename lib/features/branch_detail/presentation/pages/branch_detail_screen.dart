import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_mobile_app/core/localization/app_localizations_exports.dart';
import 'package:hotel_mobile_app/core/utils/logger.dart';
import 'package:hotel_mobile_app/features/branch_detail/controller/branch_detail_controller.dart';
import 'package:hotel_mobile_app/features/branch_detail/domain/entities/branch_detail.dart';
import 'package:hotel_mobile_app/features/branch_detail/presentation/widgets/amenity_grid.dart';
import 'package:hotel_mobile_app/features/branch_detail/presentation/widgets/nearby_places_list.dart';
import 'package:hotel_mobile_app/features/branch_detail/presentation/widgets/room_preview_card.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchDetailScreen extends ConsumerWidget {
  final String branchId;

  const BranchDetailScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = AppLogger();
    final branchDetailAsync = ref.watch(branchDetailProvider(branchId));

    return Scaffold(
      body: branchDetailAsync.when(
        data: (branchDetail) {
          return _buildDetailContent(context, branchDetail);
        },
        loading:
            () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.loading),
                ],
              ),
            ),
        error: (error, stackTrace) {
          // Use AppLogger for all logging
          logger.e('Error loading branch detail', error, stackTrace);
          logger.d('Error in BranchDetailScreen: $error');
          logger.d('BranchID that failed: "$branchId"');

          // Get the current locale for translations
          final localizations = AppLocalizations.of(context)!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.failedToLoadHotelDetails,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                // Show the error message in debug mode
                if (kDebugMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Error: ${error.toString()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Refresh the data
                    final _ = ref.refresh(branchDetailProvider(branchId));
                  },
                  child: Text(localizations.retry),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, BranchDetail branchDetail) {
    final currentLocale = Localizations.localeOf(context).languageCode;

    return CustomScrollView(
      slivers: [
        // App bar with image gallery
        _buildSliverAppBar(context, branchDetail),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel name and rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        branchDetail.getLocalizedName(currentLocale),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (branchDetail.rating ?? 0.0).toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        RatingBar.builder(
                          initialRating: branchDetail.rating ?? 0.0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ignoreGestures: true,
                          itemBuilder:
                              (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (_) {},
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Address with icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        branchDetail.getLocalizedAddress(currentLocale),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Phone with icon and call action
                InkWell(
                  onTap: () => _launchPhoneCall(branchDetail.phone),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        branchDetail.phone,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  AppLocalizations.of(context)!.about,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  branchDetail.getLocalizedDescription(currentLocale),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                // Amenities section
                Text(
                  AppLocalizations.of(context)!.amenities,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                // const SizedBox(height: 8),
                AmenityGrid(amenities: branchDetail.amenities),

                const SizedBox(height: 24),

                // Nearby places
                if (branchDetail.nearbyPlaces.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.nearbyPlaces,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  NearbyPlacesList(
                    nearbyPlaces: branchDetail.nearbyPlaces,
                    branchDetail: branchDetail,
                  ),
                  const SizedBox(height: 24),
                ],

                // Rooms section
                Text(
                  AppLocalizations.of(context)!.availableRooms,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...branchDetail.rooms.map(
                  (room) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: RoomPreviewCard(room: room),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, BranchDetail branchDetail) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image carousel
            CarouselSlider(
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
                autoPlay: true,
                enableInfiniteScroll: branchDetail.images.length > 1,
              ),
              items: [
                // First show thumbnail
                _buildCarouselItem(branchDetail.thumbnail.url),
                // Then show other images
                ...branchDetail.images.map(
                  (image) => _buildCarouselItem(image.url),
                ),
              ],
            ),

            // Gradient overlay for better visibility of back button and title
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // Share functionality
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Favorite functionality
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget:
          (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.error_outline, size: 50)),
          ),
    );
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
