import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/destination_repository.dart';

class DeleteDestinationUseCase implements UseCase<void, String> {
  final DestinationRepository _repository;
  DeleteDestinationUseCase(this._repository);

  @override
  Future<Result<void>> call(String id) async {
    try {
      await _repository.deleteDestination(id);
      return const Success(null);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not delete destination.'));
    }
  }
}