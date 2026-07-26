import 'package:flutter/material.dart';
import '../../core/widgets/view_state.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../core/errors/failure.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;
  CategoryProvider(this._repository);

  ViewState<List<CategoryModel>> categoriesState = const ViewLoading();

  Future<void> loadCategories() async {
    categoriesState = const ViewLoading();
    notifyListeners();
    try {
      final data = await _repository.getAll();
      categoriesState = data.isEmpty
          ? const ViewEmpty(message: 'No categories yet.')
          : ViewLoaded(data);
    } on Failure catch (f) {
      categoriesState = ViewFailed(f.message);
    }
    notifyListeners();
  }

  Future<bool> createCategory(CategoryModel category) async {
    try {
      await _repository.create(category);
      await loadCategories();
      return true;
    } on Failure catch (_) {
      return false;
    }
  }

  Future<bool> updateCategory(String id, CategoryModel category) async {
    try {
      await _repository.update(id, category);
      await loadCategories();
      return true;
    } on Failure catch (_) {
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      await _repository.delete(id);
      await loadCategories();
      return true;
    } on Failure catch (_) {
      return false;
    }
  }
}