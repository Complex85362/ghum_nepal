import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class GetDestinationByIdParams {
  final String id;
  const GetDestinationByIdParams(this.id);
}

class GetDestinationByIdUseCase
    implements UseCase<DestinationEntity, GetDestinationByIdParams> {
  final DestinationRepository _repository;
  GetDestinationByIdUseCase(this._repository);

  @override
  Future<Result<DestinationEntity>> call(GetDestinationByIdParams params) async {
    try {
      final data = await _repository.getById(params.id);
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Something went wrong.'));
    }
  }
}