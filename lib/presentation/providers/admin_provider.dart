import 'package:flutter/material.dart';
import '../../core/widgets/view_state.dart';
import '../../data/models/destination_model.dart';
import '../../data/repositories/destination_repository.dart';
import '../../core/errors/failure.dart';

class AdminProvider extends ChangeNotifier {
  final DestinationRepository _repository;
  AdminProvider(this._repository);

  ViewState<List<DestinationModel>> pendingState = const ViewLoading();

  Future<void> loadPending() async {
    pendingState = const ViewLoading();
    notifyListeners();
    try {
      final data = await _repository.getPendingSubmissions();
      pendingState = data.isEmpty
          ? const ViewEmpty(message: 'No pending submissions. All caught up!')
          : ViewLoaded(data);
    } on Failure catch (f) {
      pendingState = ViewFailed(f.message);
    }
    notifyListeners();
  }

  Future<void> approve(String id) async {
    try {
      await _repository.approveSubmission(id);
      await loadPending();
    } on Failure catch (_) {
      // keep prior state; could surface a snackbar from the caller
    }
  }

  Future<void> reject(String id) async {
    try {
      await _repository.rejectSubmission(id);
      await loadPending();
    } on Failure catch (_) {}
  }
}