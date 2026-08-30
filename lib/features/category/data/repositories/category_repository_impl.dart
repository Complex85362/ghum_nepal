import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CategoryEntity>> getAll() => _remoteDataSource.getAll();

  @override
  Future<String> create(CategoryEntity category) => _remoteDataSource.create(category);

  @override
  Future<void> update(String id, CategoryEntity category) =>
      _remoteDataSource.update(id, category);

  @override
  Future<void> delete(String id) => _remoteDataSource.delete(id);
}