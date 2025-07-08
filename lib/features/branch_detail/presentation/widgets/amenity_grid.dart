import 'package:flutter/material.dart';
import 'package:hotel_mobile_app/features/branch_detail/domain/entities/branch_detail.dart';

class AmenityGrid extends StatelessWidget {
  final List<Amenity> amenities;

  const AmenityGrid({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero, // Remove any default padding
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: amenities.length,
        itemBuilder: (context, index) {
          final amenity = amenities[index];
          final currentLocale = Localizations.localeOf(context).languageCode;

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (amenity.iconUrl != null) ...[
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.network(
                        amenity.iconUrl!,
                        errorBuilder:
                            (_, __, ___) =>
                                const Icon(Icons.spa_outlined, size: 24),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else
                    const Icon(Icons.check_circle_outline, size: 24),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        amenity.getLocalizedName(currentLocale),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
