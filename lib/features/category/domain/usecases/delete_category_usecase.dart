import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/category_repository.dart';

class DeleteCategoryUseCase implements UseCase<void, String> {
  final CategoryRepository _repository;
  DeleteCategoryUseCase(this._repository);

  @override
  Future<Result<void>> call(String id) async {
    try {
      await _repository.delete(id);
      return const Success(null);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not delete category.'));
    }
  }
}