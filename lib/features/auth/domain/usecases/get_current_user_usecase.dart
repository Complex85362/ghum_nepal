import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<String?, NoParams> {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  @override
  Future<Result<String?>> call(NoParams params) async {
    return Success(_repository.currentUserId);
  }
}