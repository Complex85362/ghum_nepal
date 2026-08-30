import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;
  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ReviewEntity>> getForDestination(String destinationId) =>
      _remoteDataSource.getForDestination(destinationId);

  @override
  Future<void> addOrUpdateReview(ReviewEntity review) =>
      _remoteDataSource.addOrUpdateReview(review);

  @override
  Future<void> deleteReview(String userId, String destinationId) =>
      _remoteDataSource.deleteReview(userId, destinationId);
}