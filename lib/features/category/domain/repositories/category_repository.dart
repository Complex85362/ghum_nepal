import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAll();
  Future<String> create(CategoryEntity category);
  Future<void> update(String id, CategoryEntity category);
  Future<void> delete(String id);
}