import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class SubmitReviewUseCase implements UseCase<void, ReviewEntity> {
  final ReviewRepository _repository;
  SubmitReviewUseCase(this._repository);

  @override
  Future<Result<void>> call(ReviewEntity params) async {
    try {
      await _repository.addOrUpdateReview(params);
      return const Success(null);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not submit review.'));
    }
  }
}