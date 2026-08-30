import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryParams {
  final String id;
  final CategoryEntity category;
  const UpdateCategoryParams({required this.id, required this.category});
}

class UpdateCategoryUseCase implements UseCase<void, UpdateCategoryParams> {
  final CategoryRepository _repository;
  UpdateCategoryUseCase(this._repository);

  @override
  Future<Result<void>> call(UpdateCategoryParams params) async {
    try {
      await _repository.update(params.id, params.category);
      return const Success(null);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not update category.'));
    }
  }
}