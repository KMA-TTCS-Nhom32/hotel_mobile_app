import 'dart:convert';
import 'package:decimal/decimal.dart';

import 'base_model.dart';
import 'amenity_model.dart';

// Enums
enum HotelRoomStatus { available, booked, occupied, maintenance }

enum HotelRoomType { standard, superior, deluxe }

enum HotelRoomBedType { single, double, queen, king }

// Room Detail model
class RoomDetailModel extends BaseModel {
  final String name;
  final String slug;
  final String description;
  final String branchId;
  final Map<String, dynamic> thumbnail;
  final List<Map<String, dynamic>> images;
  final HotelRoomType roomType;
  final HotelRoomBedType bedType;
  final int area;
  final List<AmenityModel>? amenities;
  final Decimal basePricePerHour;
  final Decimal? specialPricePerHour;
  final Decimal basePricePerNight;
  final Decimal? specialPricePerNight;
  final Decimal basePricePerDay;
  final Decimal? specialPricePerDay;
  final int maxAdults;
  final int maxChildren;
  final int quantity;
  final bool isAvailable;
  final double? rating;

  const RoomDetailModel({
    required super.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.branchId,
    required this.thumbnail,
    required this.images,
    required this.roomType,
    required this.bedType,
    required this.area,
    this.amenities,
    required this.basePricePerHour,
    this.specialPricePerHour,
    required this.basePricePerNight,
    this.specialPricePerNight,
    required this.basePricePerDay,
    this.specialPricePerDay,
    this.maxAdults = 2,
    this.maxChildren = 2,
    this.quantity = 1,
    this.isAvailable = false,
    this.rating,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory RoomDetailModel.fromJson(Map<String, dynamic> json) {
    // Parse amenities if available
    List<AmenityModel>? amenities;
    if (json['amenities'] != null) {
      amenities =
          (json['amenities'] as List)
              .map((amenity) => AmenityModel.fromJson(amenity))
              .toList();
    }

    return RoomDetailModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      branchId: json['branchId'],
      thumbnail:
          json['thumbnail'] is String
              ? jsonDecode(json['thumbnail'])
              : json['thumbnail'],
      images: _parseJsonList(json['images']),
      roomType: _parseRoomType(json['room_type']),
      bedType: _parseBedType(json['bed_type']),
      area: json['area'],
      amenities: amenities,
      basePricePerHour: _parseDecimal(json['base_price_per_hour']),
      specialPricePerHour:
          json['special_price_per_hour'] != null
              ? _parseDecimal(json['special_price_per_hour'])
              : null,
      basePricePerNight: _parseDecimal(json['base_price_per_night']),
      specialPricePerNight:
          json['special_price_per_night'] != null
              ? _parseDecimal(json['special_price_per_night'])
              : null,
      basePricePerDay: _parseDecimal(json['base_price_per_day']),
      specialPricePerDay:
          json['special_price_per_day'] != null
              ? _parseDecimal(json['special_price_per_day'])
              : null,
      maxAdults: json['max_adults'] ?? 2,
      maxChildren: json['max_children'] ?? 2,
      quantity: json['quantity'] ?? 1,
      isAvailable: json['is_available'] ?? false,
      rating: json['rating']?.toDouble(),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Helper methods
  static List<Map<String, dynamic>> _parseJsonList(dynamic jsonList) {
    if (jsonList == null) return [];

    if (jsonList is String) {
      final decoded = jsonDecode(jsonList);
      if (decoded is! List) return [];
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } else if (jsonList is List) {
      return jsonList.map((item) {
        if (item is String) {
          return jsonDecode(item) as Map<String, dynamic>;
        } else {
          return item as Map<String, dynamic>;
        }
      }).toList();
    }

    return [];
  }

  static HotelRoomType _parseRoomType(String? type) {
    if (type == null) return HotelRoomType.standard;
    switch (type.toUpperCase()) {
      case 'SUPERIOR':
        return HotelRoomType.superior;
      case 'DELUXE':
        return HotelRoomType.deluxe;
      case 'STANDARD':
      default:
        return HotelRoomType.standard;
    }
  }

  static HotelRoomBedType _parseBedType(String? type) {
    if (type == null) return HotelRoomBedType.single;
    switch (type.toUpperCase()) {
      case 'DOUBLE':
        return HotelRoomBedType.double;
      case 'QUEEN':
        return HotelRoomBedType.queen;
      case 'KING':
        return HotelRoomBedType.king;
      case 'SINGLE':
      default:
        return HotelRoomBedType.single;
    }
  }

  static Decimal _parseDecimal(dynamic value) {
    if (value == null) return Decimal.zero;
    if (value is String) {
      return Decimal.parse(value);
    } else if (value is num) {
      return Decimal.parse(value.toString());
    }
    return Decimal.zero;
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'branchId': branchId,
      'thumbnail': thumbnail is String ? thumbnail : jsonEncode(thumbnail),
      'images':
          images.map((img) => img is String ? img : jsonEncode(img)).toList(),
      'room_type': roomType.toString().split('.').last.toUpperCase(),
      'bed_type': bedType.toString().split('.').last.toUpperCase(),
      'area': area,
      'amenities': amenities?.map((amenity) => amenity.toJson()).toList(),
      'base_price_per_hour': basePricePerHour.toString(),
      'special_price_per_hour': specialPricePerHour?.toString(),
      'base_price_per_night': basePricePerNight.toString(),
      'special_price_per_night': specialPricePerNight?.toString(),
      'base_price_per_day': basePricePerDay.toString(),
      'special_price_per_day': specialPricePerDay?.toString(),
      'max_adults': maxAdults,
      'max_children': maxChildren,
      'quantity': quantity,
      'is_available': isAvailable,
      'rating': rating,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  RoomDetailModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? branchId,
    Map<String, dynamic>? thumbnail,
    List<Map<String, dynamic>>? images,
    HotelRoomType? roomType,
    HotelRoomBedType? bedType,
    int? area,
    List<AmenityModel>? amenities,
    Decimal? basePricePerHour,
    Decimal? specialPricePerHour,
    Decimal? basePricePerNight,
    Decimal? specialPricePerNight,
    Decimal? basePricePerDay,
    Decimal? specialPricePerDay,
    int? maxAdults,
    int? maxChildren,
    int? quantity,
    bool? isAvailable,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return RoomDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      branchId: branchId ?? this.branchId,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      roomType: roomType ?? this.roomType,
      bedType: bedType ?? this.bedType,
      area: area ?? this.area,
      amenities: amenities ?? this.amenities,
      basePricePerHour: basePricePerHour ?? this.basePricePerHour,
      specialPricePerHour: specialPricePerHour ?? this.specialPricePerHour,
      basePricePerNight: basePricePerNight ?? this.basePricePerNight,
      specialPricePerNight: specialPricePerNight ?? this.specialPricePerNight,
      basePricePerDay: basePricePerDay ?? this.basePricePerDay,
      specialPricePerDay: specialPricePerDay ?? this.specialPricePerDay,
      maxAdults: maxAdults ?? this.maxAdults,
      maxChildren: maxChildren ?? this.maxChildren,
      quantity: quantity ?? this.quantity,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

// Hotel Room model
class HotelRoomModel extends BaseModel {
  final String name;
  final String slug;
  final HotelRoomStatus status;
  final String detailId;
  final RoomDetailModel? detail;

  const HotelRoomModel({
    required super.id,
    required this.name,
    required this.slug,
    required this.status,
    required this.detailId,
    this.detail,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory HotelRoomModel.fromJson(Map<String, dynamic> json) {
    // Parse room detail if available
    RoomDetailModel? detail;
    if (json['detail'] != null) {
      detail = RoomDetailModel.fromJson(json['detail']);
    }

    return HotelRoomModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      status: _parseRoomStatus(json['status']),
      detailId: json['detailId'],
      detail: detail,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Helper method to parse room status
  static HotelRoomStatus _parseRoomStatus(String? status) {
    if (status == null) return HotelRoomStatus.available;
    switch (status.toUpperCase()) {
      case 'BOOKED':
        return HotelRoomStatus.booked;
      case 'OCCUPIED':
        return HotelRoomStatus.occupied;
      case 'MAINTENANCE':
        return HotelRoomStatus.maintenance;
      case 'AVAILABLE':
      default:
        return HotelRoomStatus.available;
    }
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'status': status.toString().split('.').last.toUpperCase(),
      'detailId': detailId,
      'detail': detail?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  HotelRoomModel copyWith({
    String? id,
    String? name,
    String? slug,
    HotelRoomStatus? status,
    String? detailId,
    RoomDetailModel? detail,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return HotelRoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      status: status ?? this.status,
      detailId: detailId ?? this.detailId,
      detail: detail ?? this.detail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
