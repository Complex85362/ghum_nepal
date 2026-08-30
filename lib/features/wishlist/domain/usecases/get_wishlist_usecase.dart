import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wishlist_item_entity.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistUseCase implements UseCase<List<WishlistItemEntity>, String> {
  final WishlistRepository _repository;
  GetWishlistUseCase(this._repository);

  @override
  Future<Result<List<WishlistItemEntity>>> call(String uid) async {
    try {
      final data = await _repository.getWishlist(uid);
      return Success(data);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not load wishlist.'));
    }
  }
}