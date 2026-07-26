import 'package:flutter/material.dart';
import '../../core/widgets/view_state.dart';
import '../../data/models/review_model.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/destination_repository.dart';
import '../../core/errors/failure.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewRepository _reviewRepository;
  final DestinationRepository _destinationRepository;
  ReviewProvider(this._reviewRepository, this._destinationRepository);

  ViewState<List<ReviewModel>> reviewsState = const ViewLoading();

  Future<void> loadReviews(String destinationId) async {
    reviewsState = const ViewLoading();
    notifyListeners();
    try {
      final data = await _reviewRepository.getForDestination(destinationId);
      reviewsState = data.isEmpty
          ? const ViewEmpty(message: 'No reviews yet. Be the first!')
          : ViewLoaded(data);
    } on Failure catch (f) {
      reviewsState = ViewFailed(f.message);
    }
    notifyListeners();
  }

  Future<bool> submitReview({
    required String destinationId,
    required String userId,
    required String reviewerName,
    required int rating,
    required String comment,
  }) async {
    try {
      final review = ReviewModel(
        id: '${userId}_$destinationId',
        destinationId: destinationId,
        userId: userId,
        reviewerName: reviewerName,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
      await _reviewRepository.addOrUpdateReview(review);
      await _recalculateAggregate(destinationId);
      await loadReviews(destinationId);
      return true;
    } on Failure catch (_) {
      return false;
    }
  }

  Future<bool> deleteReview(String destinationId, String userId) async {
    try {
      await _reviewRepository.deleteReview(userId, destinationId);
      await _recalculateAggregate(destinationId);
      await loadReviews(destinationId);
      return true;
    } on Failure catch (_) {
      return false;
    }
  }

  Future<void> _recalculateAggregate(String destinationId) async {
    final reviews = await _reviewRepository.getForDestination(destinationId);
    final count = reviews.length;
    final avg = count == 0
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / count;
    await _destinationRepository.updateDestination(destinationId, {
      'averageRating': avg,
      'reviewCount': count,
    });
  }
}