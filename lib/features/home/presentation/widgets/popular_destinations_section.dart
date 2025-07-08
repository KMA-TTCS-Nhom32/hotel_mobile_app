import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/province.dart';

class PopularDestinationsSection extends StatefulWidget {
  final List<Province>? provinces;
  final Function(Province)? onProvinceSelected;
  final String? selectedProvinceId;

  const PopularDestinationsSection({
    this.provinces,
    this.onProvinceSelected,
    this.selectedProvinceId,
    super.key,
  });

  @override
  State<PopularDestinationsSection> createState() =>
      _PopularDestinationsSectionState();
}

class _PopularDestinationsSectionState
    extends State<PopularDestinationsSection> {
  final ScrollController _scrollController = ScrollController();
  String? _previousSelectedId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PopularDestinationsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the selected province has changed, scroll to it
    if (widget.selectedProvinceId != null &&
        widget.selectedProvinceId != _previousSelectedId &&
        widget.provinces != null) {
      _previousSelectedId = widget.selectedProvinceId;

      // Find the index of the selected province
      final selectedIndex = widget.provinces!.indexWhere(
        (province) => province.id == widget.selectedProvinceId,
      );

      if (selectedIndex >= 0) {
        // Schedule scroll after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Calculate the offset to scroll to (each card is ~148px wide including margins)
          final offset = selectedIndex * 148.0;

          // Animate to the selected card position
          _scrollController.animateTo(
            offset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sample data as fallback if API data is not available
    final sampleDestinations = [
      {
        'id': '1',
        'name': 'New York',
        'hotels': 132,
        'image':
            'https://images.pexels.com/photos/2190283/pexels-photo-2190283.jpeg',
      },
      {
        'id': '2',
        'name': 'Paris',
        'hotels': 89,
        'image':
            'https://images.pexels.com/photos/699466/pexels-photo-699466.jpeg',
      },
      {
        'id': '3',
        'name': 'Tokyo',
        'hotels': 110,
        'image':
            'https://images.pexels.com/photos/2506923/pexels-photo-2506923.jpeg',
      },
      {
        'id': '4',
        'name': 'Dubai',
        'hotels': 78,
        'image':
            'https://images.pexels.com/photos/442579/pexels-photo-442579.jpeg',
      },
    ];

    // Province images - in a real app these would be from API or asset mapping
    final provinceImages = {
      'ha-noi':
          'https://images.pexels.com/photos/2506923/pexels-photo-2506923.jpeg',
      'ho-chi-minh':
          'https://images.pexels.com/photos/699466/pexels-photo-699466.jpeg',
      'da-nang':
          'https://images.pexels.com/photos/2190283/pexels-photo-2190283.jpeg',
      'default':
          'https://images.pexels.com/photos/442579/pexels-photo-442579.jpeg',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Destinations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all destinations
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child:
              widget.provinces != null && widget.provinces!.isNotEmpty
                  ? _buildProvincesList(provinceImages, context)
                  : _buildSampleList(sampleDestinations, context),
        ),
      ],
    );
  }

  Widget _buildProvincesList(
    Map<String, String> provinceImages,
    BuildContext context,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      itemCount: widget.provinces!.length,
      itemBuilder: (context, index) {
        final province = widget.provinces![index];
        final imageUrl =
            provinceImages[province.slug.toLowerCase()] ??
            provinceImages['default']!;

        // Get localized name based on current locale
        final currentLocale = Localizations.localeOf(context).languageCode;
        final localizedName = province.getLocalizedName(currentLocale);

        return DestinationCard(
          imageUrl: imageUrl,
          name: localizedName,
          hotelCount: province.branchCount ?? 0,
          isSelected: widget.selectedProvinceId == province.id,
          onTap: () => widget.onProvinceSelected?.call(province),
        );
      },
    );
  }

  Widget _buildSampleList(
    List<Map<String, dynamic>> sampleData,
    BuildContext context,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      itemCount: sampleData.length,
      itemBuilder: (context, index) {
        final destination = sampleData[index];
        return DestinationCard(
          imageUrl: destination['image'] as String,
          name: destination['name'] as String,
          hotelCount: destination['hotels'] as int,
          onTap: () {},
        );
      },
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int hotelCount;
  final VoidCallback onTap;
  final bool isSelected;

  const DestinationCard({
    required this.imageUrl,
    required this.name,
    required this.hotelCount,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.5,
                  )
                  : null,
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Destination Image
              CustomCachedImage(
                imageUrl: imageUrl,
                width: 140,
                height: 160,
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
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Selected indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              // Destination Info
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hotelCount == 1 ? '1 hotel' : '$hotelCount hotels',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
