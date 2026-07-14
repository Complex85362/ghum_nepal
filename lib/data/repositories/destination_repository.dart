import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination_model.dart';
import '../../core/errors/failure.dart';

class DestinationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _collection => _firestore.collection('destinations');

  Future<List<DestinationModel>> getFeatured() async {
    try {
      final snapshot = await _collection
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

  Future<List<DestinationModel>> getByCategory(String category, {int limit = 20}) async {
    try {
      final snapshot = await _collection
          .where('category', isEqualTo: category)
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
      final snapshot = await _collection.get();
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

  Future<void> submitDestination(DestinationModel destination) async {
    try {
      await _collection.add({
        ...destination.toMap(),
        'isFeatured': false,
        'approved': false,
      });
    } catch (_) {
      throw const Failure('Could not submit destination.');
    }
  }
}