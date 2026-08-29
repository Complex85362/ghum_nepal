import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/constants/app_constants.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);

  String? get currentUserId => _auth.currentUser?.uid;

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
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(userModel.toMap());
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
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
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

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final credential = await _auth.signInWithPopup(googleProvider);
      final uid = credential.user!.uid;

      final docRef = _firestore.collection(AppConstants.usersCollection).doc(uid);
      final doc = await docRef.get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, uid);
      }

      final email = credential.user!.email ?? '';
      final displayName = credential.user!.displayName ?? email.split('@').first;
      final userModel = UserModel(
        uid: uid,
        email: email,
        username: displayName,
        photoUrl: credential.user!.photoURL ?? '',
        createdAt: DateTime.now(),
      );
      await docRef.set(userModel.toMap());
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Failure.fromFirebaseAuth(e.code);
    } catch (_) {
      throw const Failure('Google sign-in failed. Please try again.');
    }
  }

  Future<UserModel> updateProfile({
    required String uid,
    String? username,
    String? photoUrl,
  }) async {
    try {
      final docRef = _firestore.collection(AppConstants.usersCollection).doc(uid);
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (updates.isNotEmpty) {
        await docRef.update(updates);
      }
      final doc = await docRef.get();
      return UserModel.fromMap(doc.data()!, uid);
    } catch (_) {
      throw const Failure('Could not update profile.');
    }
  }

  Future<void> logOut() => _auth.signOut();
}