import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<String?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  String? get currentUserId => _remoteDataSource.currentUserId;

  @override
  Future<UserEntity> signUp({
    required String email,
    required String username,
    required String password,
  }) {
    return _remoteDataSource.signUp(
      email: email,
      username: username,
      password: password,
    );
  }

  @override
  Future<UserEntity> logIn({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.logIn(email: email, password: password);
  }

  @override
  Future<UserEntity> signInWithGoogle() => _remoteDataSource.signInWithGoogle();

  @override
  Future<UserEntity> updateProfile({
    required String uid,
    String? username,
    String? photoUrl,
  }) {
    return _remoteDataSource.updateProfile(uid: uid, username: username, photoUrl: photoUrl);
  }

  @override
  Future<void> logOut() => _remoteDataSource.logOut();
}