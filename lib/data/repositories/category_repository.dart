import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../../core/errors/failure.dart';


class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _collection => _firestore.collection('categories');

  Future<List<CategoryModel>> getAll() async {
    try {
      final snapshot = await _collection.orderBy('name').get();
      return snapshot.docs
          .map((d) => CategoryModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    } catch (_) {
      throw const Failure('Could not load categories.');
    }
  }

  Future<String> create(CategoryModel category) async {
    try {
      final doc = await _collection.add(category.toMap());
      return doc.id;
    } catch (_) {
      throw const Failure('Could not create category.');
    }
  }

  Future<void> update(String id, CategoryModel category) async {
    try {
      await _collection.doc(id).update(category.toMap());
    } catch (_) {
      throw const Failure('Could not update category.');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (_) {
      throw const Failure('Could not delete category.');
    }
  }
}