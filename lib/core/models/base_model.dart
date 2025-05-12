import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  // Common properties that all models have
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final DateTime? deletedAt;

  const BaseModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
  });

  // Method to convert model to Map for API requests
  Map<String, dynamic> toJson();

  // Method to copy model with updated properties
  BaseModel copyWith();

  @override
  List<Object?> get props => [id, createdAt, updatedAt, isDeleted, deletedAt];
}
