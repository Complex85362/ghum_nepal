import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(LoginParams params) async {
    try {
      final user = await _repository.logIn(
        email: params.email,
        password: params.password,
      );
      return Success(user);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Unable to log in. Please try again.'));
    }
  }
}