import 'dart:convert';
import 'base_model.dart';
import 'amenity_model.dart';

// Hotel Branch model
class HotelBranchModel extends BaseModel {
  final Map<String, dynamic> thumbnail;
  final List<Map<String, dynamic>> images;
  final String name;
  final String slug;
  final String description;
  final String phone;
  final bool isActive;
  final String address;
  final Map<String, dynamic>? location;
  final String provinceId;
  final double? rating;
  final List<Map<String, dynamic>> nearBy;
  final List<AmenityModel>? amenities;

  const HotelBranchModel({
    required super.id,
    required this.thumbnail,
    required this.images,
    required this.name,
    required this.slug,
    required this.description,
    required this.phone,
    this.isActive = true,
    required this.address,
    this.location,
    required this.provinceId,
    this.rating,
    this.nearBy = const [],
    this.amenities,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory HotelBranchModel.fromJson(Map<String, dynamic> json) {
    // Parse amenities if available
    List<AmenityModel>? amenities;
    if (json['amenities'] != null) {
      amenities =
          (json['amenities'] as List)
              .map((amenity) => AmenityModel.fromJson(amenity))
              .toList();
    }

    return HotelBranchModel(
      id: json['id'],
      thumbnail:
          json['thumbnail'] is String
              ? jsonDecode(json['thumbnail'])
              : json['thumbnail'],
      images: _parseJsonList(json['images']),
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      phone: json['phone'],
      isActive: json['is_active'] ?? true,
      address: json['address'],
      location:
          json['location'] != null
              ? (json['location'] is String
                  ? jsonDecode(json['location'])
                  : json['location'])
              : {"latitude": "0", "longitude": "0"},
      provinceId: json['provinceId'],
      rating: json['rating']?.toDouble(),
      nearBy: _parseJsonList(json['nearBy']),
      amenities: amenities,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Helper method to parse JSON list
  static List<Map<String, dynamic>> _parseJsonList(dynamic jsonList) {
    if (jsonList == null) return [];

    if (jsonList is String) {
      // If it's a JSON string, parse it first
      final decoded = jsonDecode(jsonList);
      if (decoded is! List) return [];
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } else if (jsonList is List) {
      // If it's already a list, convert items to Map<String, dynamic>
      return jsonList.map((item) {
        if (item is String) {
          // If the item is a string, parse it
          return jsonDecode(item) as Map<String, dynamic>;
        } else {
          // Otherwise, assume it's already a Map
          return item as Map<String, dynamic>;
        }
      }).toList();
    }

    return [];
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail is String ? thumbnail : jsonEncode(thumbnail),
      'images':
          images.map((img) => img is String ? img : jsonEncode(img)).toList(),
      'name': name,
      'slug': slug,
      'description': description,
      'phone': phone,
      'is_active': isActive,
      'address': address,
      'location':
          location != null
              ? (location is String ? location : jsonEncode(location))
              : null,
      'provinceId': provinceId,
      'rating': rating,
      'nearBy':
          nearBy
              .map((item) => item is String ? item : jsonEncode(item))
              .toList(),
      'amenities': amenities?.map((amenity) => amenity.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  HotelBranchModel copyWith({
    String? id,
    Map<String, dynamic>? thumbnail,
    List<Map<String, dynamic>>? images,
    String? name,
    String? slug,
    String? description,
    String? phone,
    bool? isActive,
    String? address,
    Map<String, dynamic>? location,
    String? provinceId,
    double? rating,
    List<Map<String, dynamic>>? nearBy,
    List<AmenityModel>? amenities,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return HotelBranchModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      address: address ?? this.address,
      location: location ?? this.location,
      provinceId: provinceId ?? this.provinceId,
      rating: rating ?? this.rating,
      nearBy: nearBy ?? this.nearBy,
      amenities: amenities ?? this.amenities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
