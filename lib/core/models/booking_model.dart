import 'dart:convert';
import 'package:decimal/decimal.dart';

import 'base_model.dart';
import 'room_model.dart';
import 'user_model.dart';

// Enums
enum BookingType { hourly, nightly, daily }

enum BookingCreateType { onlineBooking, atHotel }

enum BookingStatus {
  pending,
  waitingForCheckIn,
  checkedIn,
  cancelled,
  completed,
  refunded,
  rejected,
}

enum PaymentStatus { unpaid, paid, failed, refunded }

enum PaymentMethod { cash, banking, zalopay, momo, vnPay, vietQr }

// Booking model
class BookingModel extends BaseModel {
  final String code;
  final BookingType type;
  final BookingCreateType createType;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final String roomId;
  final HotelRoomModel? room;
  final String? promotionCode;
  final Decimal totalAmount;
  final BookingStatus status;
  final String? cancelReason;
  final PaymentMethod? paymentMethod;
  final int numberOfGuests;
  final int adults;
  final int children;
  final int infants;
  final String? specialRequests;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final PaymentStatus paymentStatus;
  final Map<String, dynamic>? paymentDetails;
  final Map<String, dynamic>? refundDetails;
  final String userId;
  final UserModel? user;
  final Map<String, dynamic>? guestDetails;
  final bool isBusinessTrip;

  const BookingModel({
    required super.id,
    required this.code,
    required this.type,
    required this.createType,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.roomId,
    this.room,
    this.promotionCode,
    required this.totalAmount,
    this.status = BookingStatus.pending,
    this.cancelReason,
    this.paymentMethod,
    required this.numberOfGuests,
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    this.specialRequests,
    this.checkInTime,
    this.checkOutTime,
    this.paymentStatus = PaymentStatus.unpaid,
    this.paymentDetails,
    this.refundDetails,
    required this.userId,
    this.user,
    this.guestDetails,
    this.isBusinessTrip = false,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Parse room if available
    HotelRoomModel? room;
    if (json['room'] != null) {
      room = HotelRoomModel.fromJson(json['room']);
    }

    // Parse user if available
    UserModel? user;
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }

    return BookingModel(
      id: json['id'],
      code: json['code'],
      type: _parseBookingType(json['type']),
      createType: _parseBookingCreateType(json['create_type']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      roomId: json['roomId'],
      room: room,
      promotionCode: json['promotion_code'],
      totalAmount: _parseDecimal(json['total_amount']),
      status: _parseBookingStatus(json['status']),
      cancelReason: json['cancel_reason'],
      paymentMethod: _parsePaymentMethod(json['payment_method']),
      numberOfGuests: json['number_of_guests'],
      adults: json['adults'] ?? 1,
      children: json['children'] ?? 0,
      infants: json['infants'] ?? 0,
      specialRequests: json['special_requests'],
      checkInTime:
          json['check_in_time'] != null
              ? DateTime.parse(json['check_in_time'])
              : null,
      checkOutTime:
          json['check_out_time'] != null
              ? DateTime.parse(json['check_out_time'])
              : null,
      paymentStatus: _parsePaymentStatus(json['payment_status']),
      paymentDetails:
          json['payment_details'] != null
              ? (json['payment_details'] is String
                  ? jsonDecode(json['payment_details'])
                  : json['payment_details'])
              : null,
      refundDetails:
          json['refund_details'] != null
              ? (json['refund_details'] is String
                  ? jsonDecode(json['refund_details'])
                  : json['refund_details'])
              : null,
      userId: json['userId'],
      user: user,
      guestDetails:
          json['guest_details'] != null
              ? (json['guest_details'] is String
                  ? jsonDecode(json['guest_details'])
                  : json['guest_details'])
              : null,
      isBusinessTrip: json['is_business_trip'] ?? false,
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

  static BookingCreateType _parseBookingCreateType(String? type) {
    if (type == null) return BookingCreateType.onlineBooking;
    switch (type.toUpperCase()) {
      case 'AT_HOTEL':
        return BookingCreateType.atHotel;
      case 'ONLINE_BOOKING':
      default:
        return BookingCreateType.onlineBooking;
    }
  }

  static BookingStatus _parseBookingStatus(String? status) {
    if (status == null) return BookingStatus.pending;
    switch (status.toUpperCase()) {
      case 'WAITING_FOR_CHECK_IN':
        return BookingStatus.waitingForCheckIn;
      case 'CHECKED_IN':
        return BookingStatus.checkedIn;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      case 'COMPLETED':
        return BookingStatus.completed;
      case 'REFUNDED':
        return BookingStatus.refunded;
      case 'REJECTED':
        return BookingStatus.rejected;
      case 'PENDING':
      default:
        return BookingStatus.pending;
    }
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    if (status == null) return PaymentStatus.unpaid;
    switch (status.toUpperCase()) {
      case 'PAID':
        return PaymentStatus.paid;
      case 'FAILED':
        return PaymentStatus.failed;
      case 'REFUNDED':
        return PaymentStatus.refunded;
      case 'UNPAID':
      default:
        return PaymentStatus.unpaid;
    }
  }

  static PaymentMethod? _parsePaymentMethod(String? method) {
    if (method == null) return null;
    switch (method.toUpperCase()) {
      case 'CASH':
        return PaymentMethod.cash;
      case 'BANKING':
        return PaymentMethod.banking;
      case 'ZALOPAY':
        return PaymentMethod.zalopay;
      case 'MOMO':
        return PaymentMethod.momo;
      case 'VN_PAY':
        return PaymentMethod.vnPay;
      case 'VIET_QR':
        return PaymentMethod.vietQr;
      default:
        return null;
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
      'code': code,
      'type': type.toString().split('.').last.toUpperCase(),
      'create_type': createType.toString().split('.').last.toUpperCase(),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'roomId': roomId,
      'promotion_code': promotionCode,
      'total_amount': totalAmount.toString(),
      'status': status.toString().split('.').last.toUpperCase(),
      'cancel_reason': cancelReason,
      'payment_method': paymentMethod?.toString().split('.').last.toUpperCase(),
      'number_of_guests': numberOfGuests,
      'adults': adults,
      'children': children,
      'infants': infants,
      'special_requests': specialRequests,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'payment_status': paymentStatus.toString().split('.').last.toUpperCase(),
      'payment_details':
          paymentDetails != null ? jsonEncode(paymentDetails) : null,
      'refund_details':
          refundDetails != null ? jsonEncode(refundDetails) : null,
      'userId': userId,
      'guest_details': guestDetails != null ? jsonEncode(guestDetails) : null,
      'is_business_trip': isBusinessTrip,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  BookingModel copyWith({
    String? id,
    String? code,
    BookingType? type,
    BookingCreateType? createType,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    String? roomId,
    HotelRoomModel? room,
    String? promotionCode,
    Decimal? totalAmount,
    BookingStatus? status,
    String? cancelReason,
    PaymentMethod? paymentMethod,
    int? numberOfGuests,
    int? adults,
    int? children,
    int? infants,
    String? specialRequests,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    PaymentStatus? paymentStatus,
    Map<String, dynamic>? paymentDetails,
    Map<String, dynamic>? refundDetails,
    String? userId,
    UserModel? user,
    Map<String, dynamic>? guestDetails,
    bool? isBusinessTrip,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      createType: createType ?? this.createType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      roomId: roomId ?? this.roomId,
      room: room ?? this.room,
      promotionCode: promotionCode ?? this.promotionCode,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
      specialRequests: specialRequests ?? this.specialRequests,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      refundDetails: refundDetails ?? this.refundDetails,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      guestDetails: guestDetails ?? this.guestDetails,
      isBusinessTrip: isBusinessTrip ?? this.isBusinessTrip,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
