import '../entities/wishlist_item_entity.dart';
import '../../../destination/domain/entities/destination_entity.dart';

abstract class WishlistRepository {
  Future<void> addToWishlist(String uid, DestinationEntity destination);
  Future<void> removeFromWishlist(String uid, String destinationId);
  Future<bool> isInWishlist(String uid, String destinationId);
  Future<List<WishlistItemEntity>> getWishlist(String uid);
}