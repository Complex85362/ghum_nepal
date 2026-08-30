import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.destinationId,
    required super.userId,
    required super.reviewerName,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      id: id,
      destinationId: map['destinationId'] ?? '',
      userId: map['userId'] ?? '',
      reviewerName: map['reviewerName'] ?? 'Anonymous',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destinationId': destinationId,
      'userId': userId,
      'reviewerName': reviewerName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      destinationId: entity.destinationId,
      userId: entity.userId,
      reviewerName: entity.reviewerName,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
    );
  }
}