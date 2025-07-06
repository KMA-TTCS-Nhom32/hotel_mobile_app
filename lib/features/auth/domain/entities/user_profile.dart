import 'package:equatable/equatable.dart';

/// Enum representing user role
enum UserRole {
  /// Regular user/customer
  user,

  /// Staff member (hotel employee)
  staff,

  /// Administrator with full access
  admin,
}

/// Enum representing user gender
enum UserGender {
  /// Male
  male,

  /// Female
  female,
}

/// Enum representing account identifier type
enum AccountIdentifierType {
  /// Email-based account
  email,

  /// Phone-based account
  phone,
}

/// Represents the user profile information
class UserProfile extends Equatable {
  /// Unique identifier for the user
  final String id;

  /// Name of the user
  final String name;

  /// Email address of the user (can be null if phone-based account)
  final String? email;

  /// Phone number of the user (can be null if email-based account)
  final String? phone;

  /// URL to the user's avatar/profile image (if available)
  final String? avatarUrl;

  /// User role (e.g., 'customer', 'admin', etc.)
  final UserRole role;

  /// Whether the user's email is verified
  final bool isEmailVerified;

  /// Whether the user's phone is verified
  final bool isPhoneVerified;

  /// Type of identifier used for this account
  final AccountIdentifierType identifierType;

  /// Whether the user account is active
  final bool isActive;

  /// Whether the user account is blocked
  final bool isBlocked;

  /// User's birth date (if provided)
  final DateTime? birthDate;

  /// User's gender (if provided)
  final UserGender? gender;

  /// User's loyalty points
  final int loyaltyPoints;

  /// Creates a UserProfile instance
  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.identifierType,
    required this.isActive,
    required this.isBlocked,
    this.birthDate,
    this.gender,
    this.loyaltyPoints = 0,
  });

  /// Get full name (alias for name)
  String get fullName => name;

  /// Get phone number (alias for phone) for backward compatibility
  String? get phoneNumber => phone;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    avatarUrl,
    role,
    isEmailVerified,
    isPhoneVerified,
    identifierType,
    isActive,
    isBlocked,
    birthDate,
    gender,
    loyaltyPoints,
  ];

  /// Create a copy of this UserProfile with some fields modified
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    AccountIdentifierType? identifierType,
    bool? isActive,
    bool? isBlocked,
    DateTime? birthDate,
    UserGender? gender,
    int? loyaltyPoints,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      identifierType: identifierType ?? this.identifierType,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    );
  }
}
