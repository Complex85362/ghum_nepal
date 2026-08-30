import 'package:flutter/material.dart';
import '../../../../core/result/result.dart';
import '../../../../core/widgets/view_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  CategoryProvider({
    required GetCategoriesUseCase getCategoriesUseCase,
    required CreateCategoryUseCase createCategoryUseCase,
    required UpdateCategoryUseCase updateCategoryUseCase,
    required DeleteCategoryUseCase deleteCategoryUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _createCategoryUseCase = createCategoryUseCase,
        _updateCategoryUseCase = updateCategoryUseCase,
        _deleteCategoryUseCase = deleteCategoryUseCase;

  ViewState<List<CategoryEntity>> categoriesState = const ViewLoading();

  Future<void> loadCategories() async {
    categoriesState = const ViewLoading();
    notifyListeners();

    final result = await _getCategoriesUseCase(const NoParams());
    switch (result) {
      case Success<List<CategoryEntity>>(:final data):
        categoriesState = data.isEmpty
            ? const ViewEmpty(message: 'No categories yet.')
            : ViewLoaded(data);
      case Error<List<CategoryEntity>>(:final failure):
        categoriesState = ViewFailed(failure.message);
    }
    notifyListeners();
  }

  Future<bool> createCategory(CategoryEntity category) async {
    final result = await _createCategoryUseCase(category);
    if (result is Success<String>) {
      await loadCategories();
      return true;
    }
    return false;
  }

  Future<bool> updateCategory(String id, CategoryEntity category) async {
    final result = await _updateCategoryUseCase(
      UpdateCategoryParams(id: id, category: category),
    );
    if (result is Success<void>) {
      await loadCategories();
      return true;
    }
    return false;
  }

  Future<bool> deleteCategory(String id) async {
    final result = await _deleteCategoryUseCase(id);
    if (result is Success<void>) {
      await loadCategories();
      return true;
    }
    return false;
  }
}