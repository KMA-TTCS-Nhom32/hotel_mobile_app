import 'package:flutter/foundation.dart';

/// Represents a featured hotel on the home screen
@immutable
class FeaturedHotel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final double price;
  final String location;

  const FeaturedHotel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.location,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeaturedHotel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          rating == other.rating &&
          price == other.price &&
          location == other.location;
  @override
  int get hashCode =>
      Object.hash(id, name, description, imageUrl, rating, price, location);
}
