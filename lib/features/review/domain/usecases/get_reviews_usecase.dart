import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetReviewsUseCase implements UseCase<List<ReviewEntity>, String> {
  final ReviewRepository _repository;
  GetReviewsUseCase(this._repository);

  @override
  Future<Result<List<ReviewEntity>>> call(String destinationId) async {
    try {
      final data = await _repository.getForDestination(destinationId);
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not load reviews.'));
    }
  }
}