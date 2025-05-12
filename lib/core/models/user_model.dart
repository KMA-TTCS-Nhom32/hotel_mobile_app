import 'dart:convert';
import 'base_model.dart';

// Enums
enum UserRole { user, staff, admin }

enum UserGender { male, female }

enum AccountIdentifier { email, phone }

// User model
class UserModel extends BaseModel {
  final String? email;
  final String? phone;
  final String name;
  final Map<String, dynamic>? avatar;
  final UserRole role;
  final DateTime? birthDate;
  final UserGender? gender;
  final bool verifiedEmail;
  final bool verifiedPhone;
  final AccountIdentifier identifierType;
  final bool isBlocked;
  final DateTime? blockedAt;
  final String? blockedReason;
  final bool isActive;
  final String? branchId;
  final int loyaltyPoints;

  const UserModel({
    required super.id,
    this.email,
    this.phone,
    required this.name,
    this.avatar,
    this.role = UserRole.user,
    this.birthDate,
    this.gender,
    this.verifiedEmail = false,
    this.verifiedPhone = false,
    this.identifierType = AccountIdentifier.email,
    this.isBlocked = false,
    this.blockedAt,
    this.blockedReason,
    this.isActive = true,
    this.branchId,
    this.loyaltyPoints = 0,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      name: json['name'],
      avatar:
          json['avatar'] != null
              ? json['avatar'] is String
                  ? jsonDecode(json['avatar'])
                  : json['avatar']
              : null,
      role: _parseUserRole(json['role']),
      birthDate:
          json['birth_date'] != null
              ? DateTime.parse(json['birth_date'])
              : null,
      gender: _parseUserGender(json['gender']),
      verifiedEmail: json['verified_email'] ?? false,
      verifiedPhone: json['verified_phone'] ?? false,
      identifierType: _parseAccountIdentifier(json['identifier_type']),
      isBlocked: json['is_blocked'] ?? false,
      blockedAt:
          json['blocked_at'] != null
              ? DateTime.parse(json['blocked_at'])
              : null,
      blockedReason: json['blocked_reason'],
      isActive: json['is_active'] ?? true,
      branchId: json['branchId'],
      loyaltyPoints: json['loyalty_points'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Helper methods to parse enums from API
  static UserRole _parseUserRole(String? role) {
    if (role == null) return UserRole.user;
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;
      case 'STAFF':
        return UserRole.staff;
      case 'USER':
      default:
        return UserRole.user;
    }
  }

  static UserGender? _parseUserGender(String? gender) {
    if (gender == null) return null;
    switch (gender.toUpperCase()) {
      case 'MALE':
        return UserGender.male;
      case 'FEMALE':
        return UserGender.female;
      default:
        return null;
    }
  }

  static AccountIdentifier _parseAccountIdentifier(String? identifier) {
    if (identifier == null) return AccountIdentifier.email;
    switch (identifier.toUpperCase()) {
      case 'PHONE':
        return AccountIdentifier.phone;
      case 'EMAIL':
      default:
        return AccountIdentifier.email;
    }
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'avatar': avatar != null ? jsonEncode(avatar) : null,
      'role': role.toString().split('.').last.toUpperCase(),
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender?.toString().split('.').last.toUpperCase(),
      'verified_email': verifiedEmail,
      'verified_phone': verifiedPhone,
      'identifier_type':
          identifierType.toString().split('.').last.toUpperCase(),
      'is_blocked': isBlocked,
      'blocked_at': blockedAt?.toIso8601String(),
      'blocked_reason': blockedReason,
      'is_active': isActive,
      'branchId': branchId,
      'loyalty_points': loyaltyPoints,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    Map<String, dynamic>? avatar,
    UserRole? role,
    DateTime? birthDate,
    UserGender? gender,
    bool? verifiedEmail,
    bool? verifiedPhone,
    AccountIdentifier? identifierType,
    bool? isBlocked,
    DateTime? blockedAt,
    String? blockedReason,
    bool? isActive,
    String? branchId,
    int? loyaltyPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      verifiedEmail: verifiedEmail ?? this.verifiedEmail,
      verifiedPhone: verifiedPhone ?? this.verifiedPhone,
      identifierType: identifierType ?? this.identifierType,
      isBlocked: isBlocked ?? this.isBlocked,
      blockedAt: blockedAt ?? this.blockedAt,
      blockedReason: blockedReason ?? this.blockedReason,
      isActive: isActive ?? this.isActive,
      branchId: branchId ?? this.branchId,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
