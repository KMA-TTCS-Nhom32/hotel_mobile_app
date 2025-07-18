import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../features/branch_detail/presentation/pages/branch_detail_screen.dart';
import '../../domain/entities/branch.dart' as hotel_branch;

class FeaturedHotelsCarousel extends StatelessWidget {
  final List<hotel_branch.Branch>? branchesList;

  const FeaturedHotelsCarousel({this.branchesList, super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data as fallback
    final sampleData = [
      {
        'id': '1',
        'name': 'Grand Plaza Hotel',
        'location': 'Downtown',
        'price': '\$120',
        'rating': 4.7,
        'image':
            'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg',
      },
      {
        'id': '2',
        'name': 'Ocean View Resort',
        'location': 'Beachfront',
        'price': '\$180',
        'rating': 4.9,
        'image':
            'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg',
      },
      {
        'id': '3',
        'name': 'Mountain Retreat',
        'location': 'Highland Park',
        'price': '\$150',
        'rating': 4.5,
        'image':
            'https://images.pexels.com/photos/2034335/pexels-photo-2034335.jpeg',
      },
    ];

    final List<dynamic> itemsToShow =
        branchesList?.isNotEmpty == true ? branchesList! : sampleData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Hotels',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all hotels
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CarouselSlider.builder(
          itemCount: itemsToShow.length,
          itemBuilder: (context, index, realIndex) {
            final bool isApiData = branchesList?.isNotEmpty == true;
            final dynamic item = itemsToShow[index];

            // Get data based on whether we're using API data or sample data
            // Get current locale for localization
            final currentLocale = Localizations.localeOf(context).languageCode;

            final String imageUrl =
                isApiData ? item.thumbnail.url : item['image'] as String;
            final String name =
                isApiData
                    ? item.getLocalizedName(currentLocale)
                    : item['name'] as String;
            final String location =
                isApiData
                    ? (item.province?.getLocalizedName(currentLocale) ??
                        item.getLocalizedAddress(currentLocale))
                    : item['location'] as String;
            final String price =
                isApiData ? 'Contact for price' : item['price'] as String;
            final dynamic rating = isApiData ? item.rating : item['rating'];

            return GestureDetector(
              onTap: () {
                // Navigate to hotel details
                if (isApiData && item is hotel_branch.Branch) {
                  // Create logger instance
                  final logger = AppLogger();

                  // Debug info about the branch ID
                  logger.d('Carousel: Tapped branch ID: "${item.id}"');
                  logger.d(
                    'Carousel: Branch ID type: ${item.id.runtimeType}, length: ${item.id.length}',
                  );

                  // Check for potential issues with the branch ID
                  if (item.id.contains(' ')) {
                    logger.w('Carousel: Warning - Branch ID contains spaces');
                  }

                  // Sanitize the branch ID before navigation
                  final sanitizedId = item.id.trim();
                  if (item.id != sanitizedId) {
                    logger.w(
                      'Carousel: Branch ID needed trimming - original: "${item.id}", sanitized: "$sanitizedId"',
                    );
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              BranchDetailScreen(branchId: sanitizedId),
                    ),
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Hotel Image
                      CustomCachedImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 220,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha((0.7 * 255).toInt()),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Hotel Info
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Tooltip(
                              message:
                                  isApiData
                                      ? item.getLocalizedDescription(
                                        currentLocale,
                                      )
                                      : 'Sample hotel description',
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
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating != null
                                          ? rating.toString()
                                          : 'N/A',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  price,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  (0.2 * 255).toInt(),
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 220,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: true,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
          ),
        ),
      ],
    );
  }
}
