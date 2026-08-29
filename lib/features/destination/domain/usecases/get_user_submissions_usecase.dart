import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class GetUserSubmissionsUseCase implements UseCase<List<DestinationEntity>, String> {
  final DestinationRepository _repository;
  GetUserSubmissionsUseCase(this._repository);

  @override
  Future<Result<List<DestinationEntity>>> call(String uid) async {
    try {
      final data = await _repository.getBySubmitter(uid);
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not load your submissions.'));
    }
  }
}