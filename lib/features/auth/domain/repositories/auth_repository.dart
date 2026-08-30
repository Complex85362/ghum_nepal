import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<String?> get authStateChanges;
  String? get currentUserId;

  Future<UserEntity> signUp({
    required String email,
    required String username,
    required String password,
  });

  Future<UserEntity> logIn({
    required String email,
    required String password,
  });

  Future<UserEntity> signInWithGoogle();

  Future<UserEntity> updateProfile({
    required String uid,
    String? username,
    String? photoUrl,
  });

  Future<void> logOut();
}