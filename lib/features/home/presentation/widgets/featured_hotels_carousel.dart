import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/featured_hotel.dart';

class FeaturedHotelsCarousel extends StatelessWidget {
  final List<FeaturedHotel>? featuredHotels;

  const FeaturedHotelsCarousel({this.featuredHotels, super.key});

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
          itemCount: featuredHotels?.length ?? sampleData.length,
          itemBuilder: (context, index, realIndex) {
            final dynamic hotel =
                featuredHotels != null
                    ? featuredHotels![index]
                    : sampleData[index];
            final String imageUrl =
                featuredHotels != null
                    ? hotel.imageUrl
                    : hotel['image'] as String;
            final String name =
                featuredHotels != null ? hotel.name : hotel['name'] as String;
            final String location =
                featuredHotels != null
                    ? hotel.location
                    : hotel['location'] as String;
            final String price =
                featuredHotels != null
                    ? '\$${hotel.price.toStringAsFixed(0)}'
                    : hotel['price'] as String;
            final double rating =
                featuredHotels != null
                    ? hotel.rating
                    : hotel['rating'] as double;

            return GestureDetector(
              onTap: () {
                // Navigate to hotel details
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
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                                Text(
                                  hotel['location'] as String,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
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
                                      hotel['rating'].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${hotel['price']} / night',
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
