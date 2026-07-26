class ReviewModel {
  final String id;
  final String destinationId;
  final String userId;
  final String reviewerName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.destinationId,
    required this.userId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
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
}