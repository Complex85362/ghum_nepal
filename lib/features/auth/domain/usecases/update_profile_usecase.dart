import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileParams {
  final String uid;
  final String? username;
  final String? photoUrl;
  const UpdateProfileParams({required this.uid, this.username, this.photoUrl});
}

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository _repository;
  UpdateProfileUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(UpdateProfileParams params) async {
    try {
      final user = await _repository.updateProfile(
        uid: params.uid,
        username: params.username,
        photoUrl: params.photoUrl,
      );
      return Success(user);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not update profile.'));
    }
  }
}