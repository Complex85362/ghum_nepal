import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/errors/failure.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  AuthStatus status = AuthStatus.idle;
  UserModel? user;
  String? errorMessage;

  Future<bool> logIn(String email, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      user = await _repository.logIn(email: email, password: password);
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on Failure catch (f) {
      errorMessage = f.message;
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String username, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      user = await _repository.signUp(
        email: email,
        username: username,
        password: password,
      );
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on Failure catch (f) {
      errorMessage = f.message;
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logOut() async {
    await _repository.logOut();
    user = null;
    status = AuthStatus.idle;
    notifyListeners();
  }
}