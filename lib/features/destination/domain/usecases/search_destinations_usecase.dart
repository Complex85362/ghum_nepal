import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/destination_entity.dart';
import '../repositories/destination_repository.dart';

class SearchDestinationsParams {
  final String query;
  const SearchDestinationsParams(this.query);
}

class SearchDestinationsUseCase
    implements UseCase<List<DestinationEntity>, SearchDestinationsParams> {
  final DestinationRepository _repository;
  SearchDestinationsUseCase(this._repository);

  @override
  Future<Result<List<DestinationEntity>>> call(SearchDestinationsParams params) async {
    try {
      final data = await _repository.search(params.query);
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Search failed.'));
    }
  }
}