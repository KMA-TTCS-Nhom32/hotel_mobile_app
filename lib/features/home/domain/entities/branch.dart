import 'package:equatable/equatable.dart';
import 'province.dart';

/// Model representing an image
class Image extends Equatable {
  final String url;
  final String? alternativeText;
  final int? width;
  final int? height;

  const Image({
    required this.url,
    this.alternativeText,
    this.width,
    this.height,
  });

  /// Create an Image from JSON data
  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['url'] as String,
      alternativeText: json['alternativeText'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  @override
  List<Object?> get props => [url, alternativeText, width, height];
}

/// Model representing a nearby location
class NearBy extends Equatable {
  final String name;
  final String distance;

  const NearBy({required this.name, required this.distance});

  /// Create a NearBy from JSON data
  factory NearBy.fromJson(Map<String, dynamic> json) {
    return NearBy(
      name: json['name'] as String,
      distance: json['distance'] as String,
    );
  }

  @override
  List<Object?> get props => [name, distance];
}

/// Model representing a branch translation
class BranchTranslation extends Equatable {
  final String language;
  final String name;
  final String description;
  final String address;
  final List<NearBy> nearBy;

  const BranchTranslation({
    required this.language,
    required this.name,
    required this.description,
    required this.address,
    this.nearBy = const [],
  });

  /// Create a BranchTranslation from JSON data
  factory BranchTranslation.fromJson(Map<String, dynamic> json) {
    return BranchTranslation(
      language: json['language'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      nearBy:
          (json['nearBy'] as List<dynamic>?)
              ?.map((e) => NearBy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [language, name, description, address, nearBy];
}

/// Model representing a hotel branch
class Branch extends Equatable {
  final String id;
  final Image thumbnail;
  final List<Image> images;
  final String name; // Vietnamese name by default
  final String slug;
  final String description; // Vietnamese description by default
  final String phone;
  final bool isActive;
  final String address; // Vietnamese address by default
  final double? rating;
  final String provinceId;
  final Province? province;
  final List<BranchTranslation> translations;
  final List<String> availableLanguages;

  const Branch({
    required this.id,
    required this.thumbnail,
    this.images = const [],
    required this.name,
    required this.slug,
    required this.description,
    required this.phone,
    required this.isActive,
    required this.address,
    this.rating,
    required this.provinceId,
    this.province,
    this.translations = const [],
    this.availableLanguages = const [],
  });

  /// Get the branch name in a specific language, defaults to Vietnamese
  String getLocalizedName(String languageCode) {
    if (languageCode.toLowerCase() == 'en') {
      final enTranslation = translations.firstWhere(
        (t) => t.language.toLowerCase() == 'en',
        orElse:
            () => BranchTranslation(
              language: 'en',
              name: '',
              description: '',
              address: '',
            ),
      );
      return enTranslation.name.isNotEmpty ? enTranslation.name : name;
    }
    return name;
  }

  /// Get the branch description in a specific language, defaults to Vietnamese
  String getLocalizedDescription(String languageCode) {
    if (languageCode.toLowerCase() == 'en') {
      final enTranslation = translations.firstWhere(
        (t) => t.language.toLowerCase() == 'en',
        orElse:
            () => BranchTranslation(
              language: 'en',
              name: '',
              description: '',
              address: '',
            ),
      );
      return enTranslation.description.isNotEmpty
          ? enTranslation.description
          : description;
    }
    return description;
  }

  /// Get the branch address in a specific language, defaults to Vietnamese
  String getLocalizedAddress(String languageCode) {
    if (languageCode.toLowerCase() == 'en') {
      final enTranslation = translations.firstWhere(
        (t) => t.language.toLowerCase() == 'en',
        orElse:
            () => BranchTranslation(
              language: 'en',
              name: '',
              description: '',
              address: '',
            ),
      );
      return enTranslation.address.isNotEmpty ? enTranslation.address : address;
    }
    return address;
  }

  /// Create a Branch from JSON data
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as String,
      thumbnail: Image.fromJson(json['thumbnail'] as Map<String, dynamic>),
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      phone: json['phone'] as String,
      isActive: json['is_active'] as bool,
      address: json['address'] as String,
      rating: json['rating'] as double?,
      provinceId: json['provinceId'] as String,
      province:
          json['province'] != null
              ? Province.fromJson(json['province'] as Map<String, dynamic>)
              : null,
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map(
                (e) => BranchTranslation.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      availableLanguages:
          (json['availableLanguages'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    thumbnail,
    images,
    name,
    slug,
    description,
    phone,
    isActive,
    address,
    rating,
    provinceId,
    province,
    translations,
    availableLanguages,
  ];
}
