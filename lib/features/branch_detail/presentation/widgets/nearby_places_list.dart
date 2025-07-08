import 'package:flutter/material.dart';
import 'package:hotel_mobile_app/features/branch_detail/domain/entities/branch_detail.dart';

class NearbyPlacesList extends StatelessWidget {
  final List<NearbyPlace> nearbyPlaces;
  final BranchDetail? branchDetail;

  const NearbyPlacesList({
    super.key,
    required this.nearbyPlaces,
    this.branchDetail,
  });

  /// Get localized name for a nearby place
  String _getLocalizedPlaceName(BuildContext context, NearbyPlace place) {
    final currentLocale = Localizations.localeOf(context).languageCode;

    // If we have branch detail with translations, use them
    if (branchDetail != null) {
      return branchDetail!.getLocalizedNearbyPlaceName(currentLocale, place);
    }

    // Fallback to default name
    return place.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: nearbyPlaces.length,
        itemBuilder: (context, index) {
          final place = nearbyPlaces[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.place_outlined, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getLocalizedPlaceName(context, place),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        place.distance,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
