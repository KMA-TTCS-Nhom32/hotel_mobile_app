import 'package:decimal/decimal.dart';
import 'base_model.dart';
import 'room_model.dart';
import 'booking_model.dart';

// Enums
enum DiscountType { percentage, fixedAmount }

// Promotion model
class PromotionModel extends BaseModel {
  final String code;
  final BookingType appliedType;
  final DiscountType discountType;
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;
  final int? minHours;
  final int? minNights;
  final int? minDays;
  final List<String>? appliedRoomIds;

  const PromotionModel({
    required super.id,
    required this.code,
    required this.appliedType,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    this.minHours,
    this.minNights,
    this.minDays,
    this.appliedRoomIds,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    // Parse applied room IDs if available
    List<String>? appliedRoomIds;
    if (json['applied_rooms'] != null) {
      appliedRoomIds =
          (json['applied_rooms'] as List)
              .map((room) => room['id'] as String)
              .toList();
    }

    return PromotionModel(
      id: json['id'],
      code: json['code'],
      appliedType: _parseBookingType(json['applied_type']),
      discountType: _parseDiscountType(json['discount_type']),
      discountValue: json['discount_value'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      minHours: json['min_hours'],
      minNights: json['min_nights'],
      minDays: json['min_days'],
      appliedRoomIds: appliedRoomIds,
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
  static BookingType _parseBookingType(String? type) {
    if (type == null) return BookingType.nightly;
    switch (type.toUpperCase()) {
      case 'HOURLY':
        return BookingType.hourly;
      case 'DAILY':
        return BookingType.daily;
      case 'NIGHTLY':
      default:
        return BookingType.nightly;
    }
  }

  static DiscountType _parseDiscountType(String? type) {
    if (type == null) return DiscountType.percentage;
    switch (type.toUpperCase()) {
      case 'FIXED_AMOUNT':
        return DiscountType.fixedAmount;
      case 'PERCENTAGE':
      default:
        return DiscountType.percentage;
    }
  }

  // Calculate discount for a given price
  Decimal calculateDiscount(Decimal originalPrice) {
    if (discountType == DiscountType.percentage) {
      // Calculate percentage discount (e.g., 20% off)
      final percentageDecimal =
          Decimal.parse(discountValue.toString()) / Decimal.fromInt(100);
      return originalPrice * percentageDecimal;
    } else {
      // Fixed amount discount (e.g., $50 off)
      final discountAmount = Decimal.parse(discountValue.toString());
      return discountAmount > originalPrice ? originalPrice : discountAmount;
    }
  }

  // Calculate final price after discount
  Decimal calculateFinalPrice(Decimal originalPrice) {
    final discount = calculateDiscount(originalPrice);
    return originalPrice - discount;
  }

  // Check if promotion is currently valid
  bool isValid() {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && !isDeleted!;
  }

  // Check if promotion is applicable to a specific room
  bool isApplicableToRoom(String roomId) {
    if (appliedRoomIds == null || appliedRoomIds!.isEmpty) {
      return true; // Applicable to all rooms if no specific rooms are defined
    }
    return appliedRoomIds!.contains(roomId);
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'applied_type': appliedType.toString().split('.').last.toUpperCase(),
      'discount_type': discountType.toString().split('.').last.toUpperCase(),
      'discount_value': discountValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'min_hours': minHours,
      'min_nights': minNights,
      'min_days': minDays,
      'applied_rooms': appliedRoomIds?.map((id) => {'id': id}).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  PromotionModel copyWith({
    String? id,
    String? code,
    BookingType? appliedType,
    DiscountType? discountType,
    double? discountValue,
    DateTime? startDate,
    DateTime? endDate,
    int? minHours,
    int? minNights,
    int? minDays,
    List<String>? appliedRoomIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      code: code ?? this.code,
      appliedType: appliedType ?? this.appliedType,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minHours: minHours ?? this.minHours,
      minNights: minNights ?? this.minNights,
      minDays: minDays ?? this.minDays,
      appliedRoomIds: appliedRoomIds ?? this.appliedRoomIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
