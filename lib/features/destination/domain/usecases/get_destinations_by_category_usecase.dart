import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class GetDestinationsByCategoryParams {
  final String categoryId;
  const GetDestinationsByCategoryParams(this.categoryId);
}

class GetDestinationsByCategoryUseCase
    implements UseCase<List<DestinationEntity>, GetDestinationsByCategoryParams> {
  final DestinationRepository _repository;
  GetDestinationsByCategoryUseCase(this._repository);

  @override
  Future<Result<List<DestinationEntity>>> call(
      GetDestinationsByCategoryParams params) async {
    try {
      final data = await _repository.getByCategory(params.categoryId);
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Something went wrong.'));
    }
  }
}