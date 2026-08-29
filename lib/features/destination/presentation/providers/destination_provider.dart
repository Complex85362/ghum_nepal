import 'package:flutter/material.dart';
import '../../../../core/result/result.dart';
import '../../../../core/widgets/view_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/destination_entity.dart';
import '../../domain/usecases/get_featured_destinations_usecase.dart';
import '../../domain/usecases/get_destinations_by_category_usecase.dart';
import '../../domain/usecases/get_discover_feed_usecase.dart';

class DestinationProvider extends ChangeNotifier {
  final GetFeaturedDestinationsUseCase _getFeaturedUseCase;
  final GetDestinationsByCategoryUseCase _getByCategoryUseCase;
  final GetDiscoverFeedUseCase _getDiscoverFeedUseCase;

  DestinationProvider({
    required GetFeaturedDestinationsUseCase getFeaturedUseCase,
    required GetDestinationsByCategoryUseCase getByCategoryUseCase,
    required GetDiscoverFeedUseCase getDiscoverFeedUseCase,
  })  : _getFeaturedUseCase = getFeaturedUseCase,
        _getByCategoryUseCase = getByCategoryUseCase,
        _getDiscoverFeedUseCase = getDiscoverFeedUseCase;

  ViewState<List<DestinationEntity>> featuredState = const ViewLoading();
  ViewState<List<DestinationEntity>> categoryState = const ViewLoading();
  ViewState<List<DestinationEntity>> discoverFeedState = const ViewLoading();

  String? selectedCategoryId;
  String? selectedProvince;
  int? selectedMaxBudget;

  Future<void> loadFeatured() async {
    featuredState = const ViewLoading();
    notifyListeners();

    final result = await _getFeaturedUseCase(const NoParams());
    switch (result) {
      case Success<List<DestinationEntity>>(:final data):
        featuredState = data.isEmpty
            ? const ViewEmpty(message: 'No featured destinations yet.')
            : ViewLoaded(data);
      case Error<List<DestinationEntity>>(:final failure):
        featuredState = ViewFailed(failure.message);
    }
    notifyListeners();
  }

  Future<void> loadCategory(String categoryId) async {
    categoryState = const ViewLoading();
    notifyListeners();

    final result = await _getByCategoryUseCase(
      GetDestinationsByCategoryParams(categoryId),
    );
    switch (result) {
      case Success<List<DestinationEntity>>(:final data):
        categoryState = data.isEmpty
            ? const ViewEmpty(message: 'No destinations in this category yet.')
            : ViewLoaded(data);
      case Error<List<DestinationEntity>>(:final failure):
        categoryState = ViewFailed(failure.message);
    }
    notifyListeners();
  }

  Future<void> loadDiscoverFeed() async {
    discoverFeedState = const ViewLoading();
    notifyListeners();

    final result = await _getDiscoverFeedUseCase(
      GetDiscoverFeedParams(
        categoryId: selectedCategoryId,
        province: selectedProvince,
        maxBudgetNpr: selectedMaxBudget,
      ),
    );
    switch (result) {
      case Success<List<DestinationEntity>>(:final data):
        discoverFeedState = data.isEmpty
            ? const ViewEmpty(message: 'No destinations match these filters.')
            : ViewLoaded(data);
      case Error<List<DestinationEntity>>(:final failure):
        discoverFeedState = ViewFailed(failure.message);
    }
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    selectedCategoryId = categoryId;
    loadDiscoverFeed();
  }

  void setProvinceFilter(String? province) {
    selectedProvince = province;
    loadDiscoverFeed();
  }

  void setBudgetFilter(int? maxBudget) {
    selectedMaxBudget = maxBudget;
    loadDiscoverFeed();
  }
}