import 'package:flutter/material.dart';
import '../../../../core/result/result.dart';
import '../../../../core/widgets/view_state.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/usecases/get_reviews_usecase.dart';
import '../../domain/usecases/submit_review_usecase.dart';
import '../../domain/usecases/delete_review_usecase.dart';
import '../../../destination/domain/usecases/update_destination_usecase.dart';

class ReviewProvider extends ChangeNotifier {
  final GetReviewsUseCase _getReviewsUseCase;
  final SubmitReviewUseCase _submitReviewUseCase;
  final DeleteReviewUseCase _deleteReviewUseCase;
  final UpdateDestinationUseCase _updateDestinationUseCase;

  ReviewProvider({
    required GetReviewsUseCase getReviewsUseCase,
    required SubmitReviewUseCase submitReviewUseCase,
    required DeleteReviewUseCase deleteReviewUseCase,
    required UpdateDestinationUseCase updateDestinationUseCase,
  })  : _getReviewsUseCase = getReviewsUseCase,
        _submitReviewUseCase = submitReviewUseCase,
        _deleteReviewUseCase = deleteReviewUseCase,
        _updateDestinationUseCase = updateDestinationUseCase;

  ViewState<List<ReviewEntity>> reviewsState = const ViewLoading();

  Future<void> loadReviews(String destinationId) async {
    reviewsState = const ViewLoading();
    notifyListeners();

    final result = await _getReviewsUseCase(destinationId);
    switch (result) {
      case Success<List<ReviewEntity>>(:final data):
        reviewsState = data.isEmpty
            ? const ViewEmpty(message: 'No reviews yet. Be the first!')
            : ViewLoaded(data);
      case Error<List<ReviewEntity>>(:final failure):
        reviewsState = ViewFailed(failure.message);
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
    final review = ReviewEntity(
      id: '${userId}_$destinationId',
      destinationId: destinationId,
      userId: userId,
      reviewerName: reviewerName,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    final result = await _submitReviewUseCase(review);
    if (result is Success<void>) {
      await _recalculateAggregate(destinationId);
      await loadReviews(destinationId);
      return true;
    }
    return false;
  }

  Future<bool> deleteReview(String destinationId, String userId) async {
    final result = await _deleteReviewUseCase(
      DeleteReviewParams(userId: userId, destinationId: destinationId),
    );
    if (result is Success<void>) {
      await _recalculateAggregate(destinationId);
      await loadReviews(destinationId);
      return true;
    }
    return false;
  }

  Future<void> _recalculateAggregate(String destinationId) async {
    final result = await _getReviewsUseCase(destinationId);
    if (result is Success<List<ReviewEntity>>) {
      final reviews = (result as Success<List<ReviewEntity>>).data;
      final count = reviews.length;
      final avg = count == 0
          ? 0.0
          : reviews.map((r) => r.rating).reduce((a, b) => a + b) / count;
      await _updateDestinationUseCase(
        UpdateDestinationParams(
          id: destinationId,
          data: {'averageRating': avg, 'reviewCount': count},
        ),
      );
    }
  }
}