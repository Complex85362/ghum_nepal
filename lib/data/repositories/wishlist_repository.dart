import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination_model.dart';
import '../../core/errors/failure.dart';

class WishlistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _wishlistCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('wishlist');

  Future<void> addToWishlist(String uid, DestinationModel destination) async {
    try {
      await _wishlistCollection(uid).doc(destination.id).set({
        'destinationId': destination.id,
        'name': destination.name,
        'coverImageUrl': destination.coverImageUrl,
        'category': destination.category,
        'addedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      throw const Failure('Could not save to wishlist.');
    }
  }

  Future<void> removeFromWishlist(String uid, String destinationId) async {
    try {
      await _wishlistCollection(uid).doc(destinationId).delete();
    } catch (_) {
      throw const Failure('Could not remove from wishlist.');
    }
  }

  Future<bool> isInWishlist(String uid, String destinationId) async {
    try {
      final doc = await _wishlistCollection(uid).doc(destinationId).get();
      return doc.exists;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getWishlist(String uid) async {
    try {
      final snapshot = await _wishlistCollection(uid)
          .orderBy('addedAt', descending: true)
          .get();
      return snapshot.docs.map((d) => d.data() as Map<String, dynamic>).toList();
    } catch (_) {
      throw const Failure('Could not load wishlist.');
    }
  }
}