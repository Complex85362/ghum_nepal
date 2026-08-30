import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final CategoryRepository _repository;
  GetCategoriesUseCase(this._repository);

  @override
  Future<Result<List<CategoryEntity>>> call(NoParams params) async {
    try {
      final data = await _repository.getAll();
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Something went wrong.'));
    }
  }
}