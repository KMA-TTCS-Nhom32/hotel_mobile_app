import 'base_model.dart';

// Enums
enum Language { en, vi }

// Province model
class ProvinceModel extends BaseModel {
  final String name;
  final String zipCode;
  final String slug;
  final Map<Language, String>? translations;

  const ProvinceModel({
    required super.id,
    required this.name,
    required this.zipCode,
    required this.slug,
    this.translations,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    // Parse translations if available
    Map<Language, String>? translations;
    if (json['translations'] != null) {
      translations = {};
      for (var translation in json['translations']) {
        final language = _parseLanguage(translation['language']);
        translations[language] = translation['name'];
      }
    }

    return ProvinceModel(
      id: json['id'],
      name: json['name'],
      zipCode: json['zip_code'],
      slug: json['slug'],
      translations: translations,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Helper method to parse language
  static Language _parseLanguage(String? language) {
    if (language == null) return Language.en;
    switch (language.toLowerCase()) {
      case 'vi':
        return Language.vi;
      case 'en':
      default:
        return Language.en;
    }
  }

  // Get translated name for a specific language
  String getTranslatedName(Language language) {
    if (translations != null && translations!.containsKey(language)) {
      return translations![language]!;
    }
    return name; // Fallback to default name
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'zip_code': zipCode,
      'slug': slug,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  ProvinceModel copyWith({
    String? id,
    String? name,
    String? zipCode,
    String? slug,
    Map<Language, String>? translations,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return ProvinceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      zipCode: zipCode ?? this.zipCode,
      slug: slug ?? this.slug,
      translations: translations ?? this.translations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
