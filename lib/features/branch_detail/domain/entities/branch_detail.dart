import 'package:hotel_mobile_app/core/utils/logger.dart';
import 'package:hotel_mobile_app/features/home/domain/entities/branch.dart';

class NearbyPlace {
  final String name;
  final String distance;

  NearbyPlace({required this.name, required this.distance});

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    return NearbyPlace(
      name: json['name'] as String,
      distance: json['distance'] as String,
    );
  }

  /// Get localized name based on the branch translations
  String getLocalizedName(
    String locale,
    List<Map<String, dynamic>> branchTranslations,
  ) {
    if (branchTranslations.isEmpty) {
      return name;
    }

    try {
      // Find the branch translation for this locale
      final branchTranslation = branchTranslations.firstWhere(
        (t) => t['language'] == locale,
        orElse: () => {'nearBy': []},
      );

      // Get the nearby places from the translation
      final nearbyPlaces = branchTranslation['nearBy'] as List? ?? [];

      // Find a matching nearby place by comparing distances as they should be unique
      final matchingPlace = nearbyPlaces.firstWhere(
        (place) => place['distance'] == distance,
        orElse: () => {'name': name},
      );

      return matchingPlace['name'] as String? ?? name;
    } catch (e) {
      return name; // Fallback to default name if anything fails
    }
  }
}

class Amenity {
  final String id;
  final String name;
  final String? slug;
  final String? iconUrl;
  final String type;
  final List<Map<String, dynamic>> translations;

  Amenity({
    required this.id,
    required this.name,
    this.slug,
    this.iconUrl,
    required this.type,
    this.translations = const [],
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> translationsList =
        (json['translations'] as List?)
            ?.map((t) => t as Map<String, dynamic>)
            .toList() ??
        [];

    return Amenity(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      iconUrl: json['icon']?['url'] as String?,
      type: json['type'] as String,
      translations: translationsList,
    );
  }

  /// Get localized name based on current locale
  String getLocalizedName(String locale) {
    if (translations.isEmpty) {
      return name;
    }

    final translation = translations.firstWhere(
      (t) => t['language'] == locale,
      orElse: () => {'name': name},
    );

    return translation['name'] as String? ?? name;
  }
}

class Room {
  final String id;
  final String name;
  final String description;
  final double price;
  final int capacity;
  final List<String> imageUrls;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.capacity,
    required this.imageUrls,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    final logger = AppLogger();
    try {
      logger.d('Parsing Room from JSON: ${json['id']}');

      // Check price field type
      final priceValue = json['price'];
      logger.d(
        'Room price value: $priceValue (type: ${priceValue?.runtimeType})',
      );

      double price;
      if (priceValue == null) {
        price = 0.0;
        logger.d('Price is null, defaulting to 0.0');
      } else if (priceValue is num) {
        price = priceValue.toDouble();
      } else if (priceValue is String) {
        price = double.tryParse(priceValue) ?? 0.0;
        logger.d('Parsed string price to double: $price');
      } else {
        price = 0.0;
        logger.d('Unknown price type, defaulting to 0.0');
      }

      return Room(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: price,
        capacity: json['capacity'] as int? ?? 2,
        imageUrls:
            (json['images'] as List?)
                ?.map((img) => img['url'] as String)
                .toList() ??
            [],
      );
    } catch (e, stackTrace) {
      logger.e('Error in Room.fromJson', e, stackTrace);
      logger.d('JSON data: $json');
      rethrow;
    }
  }
}

class BranchDetail extends Branch {
  final List<Amenity> amenities;
  final List<Room> rooms;
  final List<NearbyPlace> nearbyPlaces;

  BranchDetail({
    required super.id,
    required super.name,
    required super.description,
    required super.address,
    required super.provinceId,
    required super.province,
    required super.thumbnail,
    required super.images,
    required super.slug,
    required super.phone,
    required super.isActive,
    required super.rating,
    required super.translations,
    required super.availableLanguages,
    required this.amenities,
    required this.rooms,
    required this.nearbyPlaces,
  });

  /// Get localized nearby place name based on current locale
  String getLocalizedNearbyPlaceName(String locale, NearbyPlace place) {
    final List<Map<String, dynamic>> translationsList =
        translations
            .map((t) => {'language': t.language, 'nearBy': t.nearBy})
            .toList();

    return place.getLocalizedName(locale, translationsList);
  }

  factory BranchDetail.fromJson(Map<String, dynamic> json) {
    final logger = AppLogger();
    try {
      logger.d('Parsing BranchDetail from JSON: id=${json['id']}');

      final branch = Branch.fromJson(json);
      logger.d('Successfully created base Branch object');

      // Parse amenities
      final amenitiesList = json['amenities'] as List?;
      logger.d('Amenities list: ${amenitiesList?.length ?? 'null'}');

      final List<Amenity> amenities =
          amenitiesList
              ?.map((amenity) {
                try {
                  return Amenity.fromJson(amenity);
                } catch (e) {
                  logger.d('Error parsing amenity: $e');
                  return null;
                }
              })
              .whereType<Amenity>()
              .toList() ??
          [];

      logger.d('Successfully parsed ${amenities.length} amenities');

      // Parse rooms
      final roomsList = json['rooms'] as List?;
      logger.d('Rooms list: ${roomsList?.length ?? 'null'}');

      final List<Room> rooms =
          roomsList
              ?.map((room) {
                try {
                  return Room.fromJson(room);
                } catch (e) {
                  logger.d('Error parsing room: $e');
                  return null;
                }
              })
              .whereType<Room>()
              .toList() ??
          [];

      logger.d('Successfully parsed ${rooms.length} rooms');

      // Parse nearby places
      final nearbyList = json['nearBy'] as List?;
      logger.d('NearBy list: ${nearbyList?.length ?? 'null'}');

      final List<NearbyPlace> nearbyPlaces =
          nearbyList
              ?.map((place) {
                try {
                  return NearbyPlace.fromJson(place);
                } catch (e) {
                  logger.d('Error parsing nearby place: $e');
                  return null;
                }
              })
              .whereType<NearbyPlace>()
              .toList() ??
          [];

      logger.d('Successfully parsed ${nearbyPlaces.length} nearby places');

      return BranchDetail(
        id: branch.id,
        name: branch.name,
        description: branch.description,
        address: branch.address,
        provinceId: branch.provinceId,
        province: branch.province,
        thumbnail: branch.thumbnail,
        images: branch.images,
        slug: branch.slug,
        phone: branch.phone,
        isActive: branch.isActive,
        rating: branch.rating,
        translations: branch.translations,
        availableLanguages: branch.availableLanguages,
        amenities: amenities,
        rooms: rooms,
        nearbyPlaces: nearbyPlaces,
      );
    } catch (e, stackTrace) {
      logger.e('Error in BranchDetail.fromJson', e, stackTrace);
      rethrow;
    }
  }
}
