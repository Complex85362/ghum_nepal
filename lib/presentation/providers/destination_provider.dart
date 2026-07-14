import 'package:flutter/material.dart';
import '../../core/widgets/view_state.dart';
import '../../data/models/destination_model.dart';
import '../../data/repositories/destination_repository.dart';
import '../../core/errors/failure.dart';

class DestinationProvider extends ChangeNotifier {
  final DestinationRepository _repository;
  DestinationProvider(this._repository);

  ViewState<List<DestinationModel>> featuredState = const ViewLoading();
  ViewState<List<DestinationModel>> categoryState = const ViewLoading();

  Future<void> loadFeatured() async {
    featuredState = const ViewLoading();
    notifyListeners();
    try {
      final data = await _repository.getFeatured();
      featuredState = data.isEmpty
          ? const ViewEmpty(message: 'No featured destinations yet.')
          : ViewLoaded(data);
    } on Failure catch (f) {
      featuredState = ViewFailed(f.message);
    } catch (_) {
      featuredState = const ViewFailed('Something went wrong.');
    }
    notifyListeners();
  }

  Future<void> loadCategory(String category) async {
    categoryState = const ViewLoading();
    notifyListeners();
    try {
      final data = await _repository.getByCategory(category);
      categoryState = data.isEmpty
          ? const ViewEmpty(message: 'No destinations in this category yet.')
          : ViewLoaded(data);
    } on Failure catch (f) {
      categoryState = ViewFailed(f.message);
    } catch (_) {
      categoryState = const ViewFailed('Something went wrong.');
    }
    notifyListeners();
  }
}