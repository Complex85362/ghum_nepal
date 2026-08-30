import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/review_repository.dart';

class DeleteReviewParams {
  final String userId;
  final String destinationId;
  const DeleteReviewParams({required this.userId, required this.destinationId});
}

class DeleteReviewUseCase implements UseCase<void, DeleteReviewParams> {
  final ReviewRepository _repository;
  DeleteReviewUseCase(this._repository);

  @override
  Future<Result<void>> call(DeleteReviewParams params) async {
    try {
      await _repository.deleteReview(params.userId, params.destinationId);
      return const Success(null);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not delete review.'));
    }
  }
}