import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<List<ReviewEntity>> getForDestination(String destinationId);
  Future<void> addOrUpdateReview(ReviewEntity review);
  Future<void> deleteReview(String userId, String destinationId);
}