import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class CreateCategoryUseCase implements UseCase<String, CategoryEntity> {
  final CategoryRepository _repository;
  CreateCategoryUseCase(this._repository);

  @override
  Future<Result<String>> call(CategoryEntity params) async {
    try {
      final id = await _repository.create(params);
      return Success(id);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not create category.'));
    }
  }
}