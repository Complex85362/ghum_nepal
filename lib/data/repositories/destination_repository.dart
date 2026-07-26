import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination_model.dart';
import '../../core/errors/failure.dart';

class DestinationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _collection => _firestore.collection('destinations');

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

  Future<String> submitDestination(DestinationModel destination) async {
    try {
      final doc = await _collection.add({
        ...destination.toMap(),
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
}