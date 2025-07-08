import 'package:equatable/equatable.dart';

/// Model representing a Province
class Province extends Equatable {
  final String id;
  final String name; // Vietnamese name by default
  final String zipCode;
  final String slug;
  final List<ProvinceTranslation> translations;
  final int? branchCount;

  const Province({
    required this.id,
    required this.name,
    required this.zipCode,
    required this.slug,
    this.translations = const [],
    this.branchCount,
  });

  /// Get the province name in a specific language, defaults to Vietnamese
  String getLocalizedName(String languageCode) {
    if (languageCode.toLowerCase() == 'en') {
      final enTranslation = translations.firstWhere(
        (t) => t.language.toLowerCase() == 'en',
        orElse: () => const ProvinceTranslation(language: 'en', name: ''),
      );
      return enTranslation.name.isNotEmpty ? enTranslation.name : name;
    }
    return name;
  }

  /// Create a Province from JSON data
  factory Province.fromJson(Map<String, dynamic> json) {
    final countData = json['_count'] as Map<String, dynamic>?;

    return Province(
      id: json['id'] as String,
      name: json['name'] as String,
      zipCode: json['zip_code'] as String,
      slug: json['slug'] as String,
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map(
                (e) => ProvinceTranslation.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      branchCount: countData?['branches'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    zipCode,
    slug,
    translations,
    branchCount,
  ];
}

/// Model representing a translation of a province name
class ProvinceTranslation extends Equatable {
  final String language;
  final String name;

  const ProvinceTranslation({required this.language, required this.name});

  /// Create a ProvinceTranslation from JSON data
  factory ProvinceTranslation.fromJson(Map<String, dynamic> json) {
    return ProvinceTranslation(
      language: json['language'] as String,
      name: json['name'] as String,
    );
  }

  @override
  List<Object?> get props => [language, name];
}
