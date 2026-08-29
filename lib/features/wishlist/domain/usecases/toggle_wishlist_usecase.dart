import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../destination/domain/entities/destination_entity.dart';
import '../repositories/wishlist_repository.dart';

class ToggleWishlistParams {
  final String uid;
  final DestinationEntity destination;
  final bool currentlySaved;
  const ToggleWishlistParams({
    required this.uid,
    required this.destination,
    required this.currentlySaved,
  });
}

class ToggleWishlistUseCase implements UseCase<void, ToggleWishlistParams> {
  final WishlistRepository _repository;
  ToggleWishlistUseCase(this._repository);

  @override
  Future<Result<void>> call(ToggleWishlistParams params) async {
    try {
      if (params.currentlySaved) {
        await _repository.removeFromWishlist(params.uid, params.destination.id);
      } else {
        await _repository.addToWishlist(params.uid, params.destination);
      }
      return const Success(null);
    } on Failure catch (f) {
      return Error(f);
    } catch (_) {
      return const Error(Failure('Could not update wishlist.'));
    }
  }
}