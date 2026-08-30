import 'package:flutter/material.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _logoutUseCase = logoutUseCase;

  AuthStatus status = AuthStatus.idle;
  UserEntity? user;
  String? errorMessage;

  Future<bool> logIn(String email, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    final result = await _loginUseCase(LoginParams(email: email, password: password));

    switch (result) {
      case Success<UserEntity>(:final data):
        user = data;
        status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      case Error<UserEntity>(:final failure):
        errorMessage = failure.message;
        status = AuthStatus.error;
        notifyListeners();
        return false;
    }
  }

  Future<bool> signUp(String email, String username, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    final result = await _signUpUseCase(
      SignUpParams(email: email, username: username, password: password),
    );

    switch (result) {
      case Success<UserEntity>(:final data):
        user = data;
        status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      case Error<UserEntity>(:final failure):
        errorMessage = failure.message;
        status = AuthStatus.error;
        notifyListeners();
        return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    final result = await _signInWithGoogleUseCase(const NoParams());

    switch (result) {
      case Success<UserEntity>(:final data):
        user = data;
        status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      case Error<UserEntity>(:final failure):
        errorMessage = failure.message;
        status = AuthStatus.error;
        notifyListeners();
        return false;
    }
  }

  Future<bool> updateProfile({String? username, String? photoUrl}) async {
    if (user == null) return false;
    final result = await _updateProfileUseCase(
      UpdateProfileParams(uid: user!.uid, username: username, photoUrl: photoUrl),
    );
    switch (result) {
      case Success<UserEntity>(:final data):
        user = data;
        notifyListeners();
        return true;
      case Error<UserEntity>():
        return false;
    }
  }

  Future<void> logOut() async {
    await _logoutUseCase(const NoParams());
    user = null;
    status = AuthStatus.idle;
    notifyListeners();
  }
}