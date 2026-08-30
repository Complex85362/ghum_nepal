import '../../domain/entities/wishlist_item_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../../destination/domain/entities/destination_entity.dart';
import '../datasources/wishlist_remote_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource _remoteDataSource;
  WishlistRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> addToWishlist(String uid, DestinationEntity destination) =>
      _remoteDataSource.addToWishlist(uid, destination);

  @override
  Future<void> removeFromWishlist(String uid, String destinationId) =>
      _remoteDataSource.removeFromWishlist(uid, destinationId);

  @override
  Future<bool> isInWishlist(String uid, String destinationId) =>
      _remoteDataSource.isInWishlist(uid, destinationId);

  @override
  Future<List<WishlistItemEntity>> getWishlist(String uid) =>
      _remoteDataSource.getWishlist(uid);
}