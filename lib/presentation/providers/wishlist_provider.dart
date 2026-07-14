import 'package:flutter/material.dart';
import '../../core/widgets/view_state.dart';
import '../../data/repositories/wishlist_repository.dart';
import '../../data/models/destination_model.dart';
import '../../core/errors/failure.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository _repository;
  WishlistProvider(this._repository);

  ViewState<List<Map<String, dynamic>>> wishlistState = const ViewLoading();
  final Set<String> _savedIds = {};

  bool isSaved(String destinationId) => _savedIds.contains(destinationId);

  Future<void> loadWishlist(String uid) async {
    wishlistState = const ViewLoading();
    notifyListeners();
    try {
      final data = await _repository.getWishlist(uid);
      _savedIds
        ..clear()
        ..addAll(data.map((d) => d['destinationId'] as String));
      wishlistState = data.isEmpty
          ? const ViewEmpty(message: 'No saved destinations yet.')
          : ViewLoaded(data);
    } on Failure catch (f) {
      wishlistState = ViewFailed(f.message);
    }
    notifyListeners();
  }

  Future<void> toggle(String uid, DestinationModel destination) async {
    try {
      if (_savedIds.contains(destination.id)) {
        await _repository.removeFromWishlist(uid, destination.id);
        _savedIds.remove(destination.id);
      } else {
        await _repository.addToWishlist(uid, destination);
        _savedIds.add(destination.id);
      }
      notifyListeners();
    } on Failure catch (_) {
      // Silently ignore; UI can re-check isSaved if needed
    }
  }
}