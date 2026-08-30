import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class GetFeaturedDestinationsUseCase
    implements UseCase<List<DestinationEntity>, NoParams> {
  final DestinationRepository _repository;
  GetFeaturedDestinationsUseCase(this._repository);

  @override
  Future<Result<List<DestinationEntity>>> call(NoParams params) async {
    try {
      final data = await _repository.getFeatured();
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Something went wrong.'));
    }
  }
}