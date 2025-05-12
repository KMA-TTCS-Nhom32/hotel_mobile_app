import 'base_model.dart';
import 'user_model.dart';
import 'room_model.dart';

// Review model
class ReviewModel extends BaseModel {
  final int ratingServices;
  final int ratingCleanliness;
  final int ratingComfort;
  final bool isAnonymousReview;
  final String? comment;
  final String roomId;
  final HotelRoomModel? room;
  final String userId;
  final UserModel? user;

  const ReviewModel({
    required super.id,
    required this.ratingServices,
    required this.ratingCleanliness,
    required this.ratingComfort,
    this.isAnonymousReview = false,
    this.comment,
    required this.roomId,
    this.room,
    required this.userId,
    this.user,
    super.createdAt,
    super.updatedAt,
    super.isDeleted,
    super.deletedAt,
  });

  // Factory constructor from API json
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    // Parse related models if available
    HotelRoomModel? room;
    if (json['room'] != null) {
      room = HotelRoomModel.fromJson(json['room']);
    }

    UserModel? user;
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }

    return ReviewModel(
      id: json['id'],
      ratingServices: json['rating_services'],
      ratingCleanliness: json['rating_cleanliness'],
      ratingComfort: json['rating_comfort'],
      isAnonymousReview: json['is_anonymous_review'] ?? false,
      comment: json['comment'],
      roomId: json['roomId'],
      room: room,
      userId: json['userId'],
      user: user,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  // Get the average rating
  double get averageRating {
    return (ratingServices + ratingCleanliness + ratingComfort) / 3;
  }

  // Convert model to json for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating_services': ratingServices,
      'rating_cleanliness': ratingCleanliness,
      'rating_comfort': ratingComfort,
      'is_anonymous_review': isAnonymousReview,
      'comment': comment,
      'roomId': roomId,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of this model with updated fields
  @override
  ReviewModel copyWith({
    String? id,
    int? ratingServices,
    int? ratingCleanliness,
    int? ratingComfort,
    bool? isAnonymousReview,
    String? comment,
    String? roomId,
    HotelRoomModel? room,
    String? userId,
    UserModel? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      ratingServices: ratingServices ?? this.ratingServices,
      ratingCleanliness: ratingCleanliness ?? this.ratingCleanliness,
      ratingComfort: ratingComfort ?? this.ratingComfort,
      isAnonymousReview: isAnonymousReview ?? this.isAnonymousReview,
      comment: comment ?? this.comment,
      roomId: roomId ?? this.roomId,
      room: room ?? this.room,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
