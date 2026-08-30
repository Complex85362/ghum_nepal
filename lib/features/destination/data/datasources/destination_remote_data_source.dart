import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/destination_entity.dart';

class DestinationRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _collection =>
      _firestore.collection(AppConstants.destinationsCollection);

  Future<List<DestinationModel>> getFeatured() async {
    try {
      final snapshot = await _collection
          .where('approved', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();
      return snapshot.docs
          .map((d) => DestinationModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    } catch (_) {
      throw const Failure('Could not load featured destinations.');
    }
  }

  Future<List<DestinationModel>> getByCategory(String categoryId, {int limit = 20}) async {
    try {
      final snapshot = await _collection
          .where('approved', isEqualTo: true)
          .where('categoryId', isEqualTo: categoryId)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((d) => DestinationModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    } catch (_) {
      throw const Failure('Could not load destinations for this category.');
    }
  }

  /// Fetches all approved destinations then filters client-side.
  /// Kept simple deliberately: combining category/province equality with a
  /// budget range would need a Firestore composite index for every field
  /// combination, which doesn't scale well for a dataset this size.
  Future<List<DestinationModel>> getDiscoverFeed({
    String? categoryId,
    String? province,
    int? maxBudgetNpr,
    int limit = 40,
  }) async {
    try {
      final snapshot =
      await _collection.where('approved', isEqualTo: true).limit(200).get();
      var results = snapshot.docs
          .map((d) => DestinationModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();

      if (categoryId != null && categoryId.isNotEmpty) {
        results = results.where((d) => d.categoryId == categoryId).toList();
      }
      if (province != null && province.isNotEmpty) {
        results = results.where((d) => d.province == province).toList();
      }
      if (maxBudgetNpr != null) {
        results = results.where((d) => d.estimatedBudgetNpr <= maxBudgetNpr).toList();
      }

      return results.take(limit).toList();
    } catch (_) {
      throw const Failure('Could not load destinations.');
    }
  }

  Future<List<DestinationModel>> search(String query) async {
    try {
      final snapshot = await _collection.where('approved', isEqualTo: true).get();
      final all = snapshot.docs
          .map((d) => DestinationModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
      final lower = query.toLowerCase();
      return all.where((d) => d.name.toLowerCase().contains(lower)).toList();
    } catch (_) {
      throw const Failure('Search failed. Please try again.');
    }
  }

  Future<DestinationModel> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) throw const Failure('Destination not found.');
      return DestinationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      if (e is Failure) rethrow;
      throw const Failure('Could not load destination.');
    }
  }

  Future<String> submitDestination(DestinationEntity destination) async {
    try {
      final model = DestinationModel.fromEntity(destination);
      final doc = await _collection.add({
        ...model.toMap(),
        'isFeatured': false,
        'approved': false,
      });
      return doc.id;
    } catch (_) {
      throw const Failure('Could not submit destination.');
    }
  }

  Future<void> updateDestination(String id, Map<String, dynamic> data) async {
    try {
      await _collection.doc(id).update(data);
    } catch (_) {
      throw const Failure('Could not update destination.');
    }
  }

  Future<void> deleteDestination(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (_) {
      throw const Failure('Could not delete destination.');
    }
  }

  Future<List<DestinationModel>> getPendingSubmissions() async {
    try {
      final snapshot = await _collection.where('approved', isEqualTo: false).get();
      return snapshot.docs
          .map((d) => DestinationModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    } catch (_) {
      throw const Failure('Could not load pending submissions.');
    }
  }

  Future<void> approveSubmission(String id) async {
    try {
      await _collection.doc(id).update({'approved': true});
    } catch (_) {
      throw const Failure('Could not approve submission.');
    }
  }

  Future<void> rejectSubmission(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (_) {
      throw const Failure('Could not reject submission.');
    }
  }
  Future<List<DestinationModel>> getBySubmitter(String uid) async {
    try {
      final snapshot = await _collection.where('submittedBy', isEqualTo: uid).get();
      return snapshot.docs
          .map((d) => DestinationModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    } catch (_) {
      throw const Failure('Could not load your submissions.');
    }
  }
}