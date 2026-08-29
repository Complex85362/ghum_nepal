import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String username;
  final String password;
  const SignUpParams({
    required this.email,
    required this.username,
    required this.password,
  });
}

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(SignUpParams params) async {
    try {
      final user = await _repository.signUp(
        email: params.email,
        username: params.username,
        password: params.password,
      );
      return Success(user);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Unable to sign up. Please try again.'));
    }
  }
}