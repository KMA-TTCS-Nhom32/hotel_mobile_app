import '../../domain/entities/user_profile.dart';

/// Data model for user profile response from API
class UserProfileDto {
  /// User ID
  final String id;

  /// Name of the user
  final String name;

  /// Email address
  final String? email;

  /// Phone number
  final String? phone;

  /// Avatar data (can be complex or URL)
  final dynamic avatar;

  /// User role as string
  final String role;

  /// Email verification status
  final bool verifiedEmail;

  /// Phone verification status
  final bool verifiedPhone;

  /// Account identifier type
  final String identifierType;

  /// Is user active
  final bool isActive;

  /// Is user blocked
  final bool isBlocked;

  /// User's birth date
  final DateTime? birthDate;

  /// User's gender
  final String? gender;

  /// User's loyalty points
  final int loyaltyPoints;

  /// Creates a UserProfileDto instance
  const UserProfileDto({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    required this.role,
    required this.verifiedEmail,
    required this.verifiedPhone,
    required this.identifierType,
    required this.isActive,
    required this.isBlocked,
    this.birthDate,
    this.gender,
    this.loyaltyPoints = 0,
  });

  /// Factory constructor to create a UserProfileDto from JSON
  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'],
      role: json['role'] as String,
      verifiedEmail: json['verified_email'] as bool? ?? false,
      verifiedPhone: json['verified_phone'] as bool? ?? false,
      identifierType: json['identifier_type'] as String? ?? 'EMAIL',
      isActive: json['is_active'] as bool? ?? true,
      isBlocked: json['is_blocked'] as bool? ?? false,
      birthDate:
          json['birth_date'] != null
              ? DateTime.parse(json['birth_date'] as String)
              : null,
      gender: json['gender'] as String?,
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
    );
  }

  /// Convert DTO to domain entity
  UserProfile toEntity() {
    // Convert string role to enum
    UserRole userRole;
    switch (role.toUpperCase()) {
      case 'ADMIN':
        userRole = UserRole.admin;
        break;
      case 'STAFF':
        userRole = UserRole.staff;
        break;
      default:
        userRole = UserRole.user;
        break;
    }

    // Convert string gender to enum
    UserGender? userGender;
    if (gender != null) {
      switch (gender!.toUpperCase()) {
        case 'MALE':
          userGender = UserGender.male;
          break;
        case 'FEMALE':
          userGender = UserGender.female;
          break;
        default:
          userGender = null;
          break;
      }
    }

    // Convert string identifier type to enum
    AccountIdentifierType identifierTypeEnum;
    switch (identifierType.toUpperCase()) {
      case 'PHONE':
        identifierTypeEnum = AccountIdentifierType.phone;
        break;
      default:
        identifierTypeEnum = AccountIdentifierType.email;
        break;
    }

    // Extract avatar URL if available
    String? avatarUrl;
    if (avatar != null) {
      // If avatar is a string, use directly
      if (avatar is String) {
        avatarUrl = avatar as String;
      }
      // If avatar is a map/json object, extract url property
      else if (avatar is Map) {
        avatarUrl = avatar['url'] as String?;
      }
    }

    return UserProfile(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      role: userRole,
      isEmailVerified: verifiedEmail,
      isPhoneVerified: verifiedPhone,
      identifierType: identifierTypeEnum,
      isActive: isActive,
      isBlocked: isBlocked,
      birthDate: birthDate,
      gender: userGender,
      loyaltyPoints: loyaltyPoints,
    );
  }
}
