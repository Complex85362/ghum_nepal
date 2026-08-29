import '../entities/destination_entity.dart';

abstract class DestinationRepository {
  Future<List<DestinationEntity>> getFeatured();
  Future<List<DestinationEntity>> getByCategory(String categoryId, {int limit = 20});
  Future<List<DestinationEntity>> getDiscoverFeed({
    String? categoryId,
    String? province,
    int? maxBudgetNpr,
    int limit = 40,
  });
  Future<List<DestinationEntity>> getBySubmitter(String uid);
  Future<List<DestinationEntity>> search(String query);
  Future<DestinationEntity> getById(String id);
  Future<String> submitDestination(DestinationEntity destination);
  Future<void> updateDestination(String id, Map<String, dynamic> data);
  Future<void> deleteDestination(String id);
  Future<List<DestinationEntity>> getPendingSubmissions();
  Future<void> approveSubmission(String id);
  Future<void> rejectSubmission(String id);
}