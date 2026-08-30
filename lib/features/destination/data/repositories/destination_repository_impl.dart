import '../../domain/entities/destination_entity.dart';
import '../../domain/repositories/destination_repository.dart';
import '../datasources/destination_remote_data_source.dart';

class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationRemoteDataSource _remoteDataSource;
  DestinationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<DestinationEntity>> getFeatured() => _remoteDataSource.getFeatured();

  @override
  Future<List<DestinationEntity>> getByCategory(String categoryId, {int limit = 20}) =>
      _remoteDataSource.getByCategory(categoryId, limit: limit);

  @override
  Future<List<DestinationEntity>> getDiscoverFeed({
    String? categoryId,
    String? province,
    int? maxBudgetNpr,
    int limit = 40,
  }) =>
      _remoteDataSource.getDiscoverFeed(
        categoryId: categoryId,
        province: province,
        maxBudgetNpr: maxBudgetNpr,
        limit: limit,
      );
  @override
  Future<List<DestinationEntity>> getBySubmitter(String uid) =>
      _remoteDataSource.getBySubmitter(uid);
  
  @override
  Future<List<DestinationEntity>> search(String query) => _remoteDataSource.search(query);

  @override
  Future<DestinationEntity> getById(String id) => _remoteDataSource.getById(id);

  @override
  Future<String> submitDestination(DestinationEntity destination) =>
      _remoteDataSource.submitDestination(destination);

  @override
  Future<void> updateDestination(String id, Map<String, dynamic> data) =>
      _remoteDataSource.updateDestination(id, data);

  @override
  Future<void> deleteDestination(String id) => _remoteDataSource.deleteDestination(id);

  @override
  Future<List<DestinationEntity>> getPendingSubmissions() =>
      _remoteDataSource.getPendingSubmissions();

  @override
  Future<void> approveSubmission(String id) => _remoteDataSource.approveSubmission(id);

  @override
  Future<void> rejectSubmission(String id) => _remoteDataSource.rejectSubmission(id);
}