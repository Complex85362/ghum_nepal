import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/destination_repository.dart';

class UpdateDestinationParams {
  final String id;
  final Map<String, dynamic> data;
  const UpdateDestinationParams({required this.id, required this.data});
}

class UpdateDestinationUseCase implements UseCase<void, UpdateDestinationParams> {
  final DestinationRepository _repository;
  UpdateDestinationUseCase(this._repository);

  @override
  Future<Result<void>> call(UpdateDestinationParams params) async {
    try {
      await _repository.updateDestination(params.id, params.data);
      return const Success(null);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not update destination.'));
    }
  }
}