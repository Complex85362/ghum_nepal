import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;
  SignInWithGoogleUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(NoParams params) async {
    try {
      final user = await _repository.signInWithGoogle();
      return Success(user);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Google sign-in failed. Please try again.'));
    }
  }
}