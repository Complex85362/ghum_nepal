import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/review_entity.dart';

class ReviewRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _collection =>
      _firestore.collection(AppConstants.reviewsCollection);

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

  Future<void> addOrUpdateReview(ReviewEntity review) async {
    try {
      final model = ReviewModel.fromEntity(review);
      await _collection.doc(review.id).set(model.toMap());
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