import 'package:flutter/material.dart';
import '../../../../core/widgets/view_state.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/wishlist_item_entity.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/toggle_wishlist_usecase.dart';
import '../../../destination/domain/entities/destination_entity.dart';

class WishlistProvider extends ChangeNotifier {
  final GetWishlistUseCase _getWishlistUseCase;
  final ToggleWishlistUseCase _toggleWishlistUseCase;

  WishlistProvider({
    required GetWishlistUseCase getWishlistUseCase,
    required ToggleWishlistUseCase toggleWishlistUseCase,
  })  : _getWishlistUseCase = getWishlistUseCase,
        _toggleWishlistUseCase = toggleWishlistUseCase;

  ViewState<List<WishlistItemEntity>> wishlistState = const ViewLoading();
  final Set<String> _savedIds = {};

  bool isSaved(String destinationId) => _savedIds.contains(destinationId);

  Future<void> loadWishlist(String uid) async {
    wishlistState = const ViewLoading();
    notifyListeners();

    final result = await _getWishlistUseCase(uid);
    switch (result) {
      case Success<List<WishlistItemEntity>>(:final data):
        _savedIds
          ..clear()
          ..addAll(data.map((d) => d.destinationId));
        wishlistState = data.isEmpty
            ? const ViewEmpty(message: 'No saved destinations yet.')
            : ViewLoaded(data);
      case Error<List<WishlistItemEntity>>(:final failure):
        wishlistState = ViewFailed(failure.message);
    }
    notifyListeners();
  }

  Future<void> toggle(String uid, DestinationEntity destination) async {
    final wasSaved = _savedIds.contains(destination.id);
    final result = await _toggleWishlistUseCase(
      ToggleWishlistParams(uid: uid, destination: destination, currentlySaved: wasSaved),
    );
    if (result is Success<void>) {
      if (wasSaved) {
        _savedIds.remove(destination.id);
      } else {
        _savedIds.add(destination.id);
      }
      notifyListeners();
    }
  }
}