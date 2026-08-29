class ReviewEntity {
  final String id;
  final String destinationId;
  final String userId;
  final String reviewerName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.destinationId,
    required this.userId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}