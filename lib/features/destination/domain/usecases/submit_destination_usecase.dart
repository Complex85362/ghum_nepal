import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class SubmitDestinationUseCase implements UseCase<String, DestinationEntity> {
  final DestinationRepository _repository;
  SubmitDestinationUseCase(this._repository);

  @override
  Future<Result<String>> call(DestinationEntity params) async {
    try {
      final id = await _repository.submitDestination(params);
      return Success(id);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not submit destination.'));
    }
  }
}