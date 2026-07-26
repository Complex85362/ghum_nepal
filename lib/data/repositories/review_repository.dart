import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../../core/errors/failure.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _collection => _firestore.collection('reviews');

  Future<List<ReviewModel>> getForDestination(String destinationId) async {
    try {
      final snapshot = await _collection
          .where('destinationId', isEqualTo: destinationId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((d) => ReviewModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    } catch (_) {
      throw const Failure('Could not load reviews.');
    }
  }

  Future<void> addOrUpdateReview(ReviewModel review) async {
    try {
      await _collection.doc(review.id).set(review.toMap());
    } catch (_) {
      throw const Failure('Could not submit review.');
    }
  }

  Future<void> deleteReview(String userId, String destinationId) async {
    try {
      await _collection.doc('${userId}_$destinationId').delete();
    } catch (_) {
      throw const Failure('Could not delete review.');
    }
  }
}