import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wishlist_item_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../destination/domain/entities/destination_entity.dart';

class WishlistRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _wishlistCollection(String uid) => _firestore
      .collection(AppConstants.usersCollection)
      .doc(uid)
      .collection(AppConstants.wishlistSubcollection);

  Future<void> addToWishlist(String uid, DestinationEntity destination) async {
    try {
      await _wishlistCollection(uid).doc(destination.id).set({
        'destinationId': destination.id,
        'name': destination.name,
        'coverImageUrl': destination.coverImageUrl,
        'categoryName': destination.categoryName,
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

  Future<List<WishlistItemModel>> getWishlist(String uid) async {
    try {
      final snapshot =
      await _wishlistCollection(uid).orderBy('addedAt', descending: true).get();
      return snapshot.docs
          .map((d) => WishlistItemModel.fromMap(d.data() as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const Failure('Could not load wishlist.');
    }
  }
}