import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/errors/failure.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserModel> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final userModel = UserModel(
        uid: uid,
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(uid).set(userModel.toMap());
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Failure.fromFirebaseAuth(e.code);
    } catch (_) {
      throw const Failure('Unable to sign up. Please try again.');
    }
  }

  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw const Failure('User record not found.');
      }
      return UserModel.fromMap(doc.data()!, uid);
    } on FirebaseAuthException catch (e) {
      throw Failure.fromFirebaseAuth(e.code);
    } catch (e) {
      if (e is Failure) rethrow;
      throw const Failure('Unable to log in. Please try again.');
    }
  }

  Future<void> logOut() => _auth.signOut();
}