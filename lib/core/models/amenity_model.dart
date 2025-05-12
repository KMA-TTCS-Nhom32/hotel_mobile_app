import 'dart:convert';
import 'base_model.dart';

// Enums
enum AmenityType { room, property, service }

// Amenity model
class AmenityModel extends BaseModel {
  final String name;
  final String slug;
  final Map<String, dynamic> icon;
  final AmenityType type;

  const AmenityModel({
    required super.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.type,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'] is String ? jsonDecode(json['icon']) : json['icon'],
      type: _parseAmenityType(json['type']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Helper method to parse enum from API
  static AmenityType _parseAmenityType(String? type) {
    if (type == null) return AmenityType.room;
    switch (type.toUpperCase()) {
      case 'PROPERTY':
        return AmenityType.property;
      case 'SERVICE':
        return AmenityType.service;
      case 'ROOM':
      default:
        return AmenityType.room;
    }
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon is String ? icon : jsonEncode(icon),
      'type': type.toString().split('.').last.toUpperCase(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  AmenityModel copyWith({
    String? id,
    String? name,
    String? slug,
    Map<String, dynamic>? icon,
    AmenityType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return AmenityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
