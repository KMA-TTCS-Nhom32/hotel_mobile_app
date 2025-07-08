import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hotel_mobile_app/core/localization/app_localizations_exports.dart';
import 'package:hotel_mobile_app/features/branch_detail/domain/entities/branch_detail.dart';

class RoomPreviewCard extends StatelessWidget {
  final Room room;

  const RoomPreviewCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate to room detail or booking screen
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child:
                      room.imageUrls.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: room.imageUrls.first,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(
                                      Icons.hotel,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          )
                          : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.hotel,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                ),
              ),

              // Room details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Room name
                        Expanded(
                          child: Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${room.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.perNight,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Room capacity
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${room.capacity} ${room.capacity > 1 ? AppLocalizations.of(context)!.guests : AppLocalizations.of(context)!.guest}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Book now button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to booking screen
                        },
                        child: Text(AppLocalizations.of(context)!.bookNow),
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
