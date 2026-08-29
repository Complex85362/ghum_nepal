import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  @override
  Future<Result<void>> call(NoParams params) async {
    try {
      await _repository.logOut();
      return const Success(null);
    } catch (_) {
      return const Error(Failure('Unable to log out. Please try again.'));
    }
  }
}