import 'package:flutter/material.dart';
import '../../../../core/result/result.dart';
import '../../../../core/widgets/view_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/destination_entity.dart';
import '../../domain/usecases/get_pending_submissions_usecase.dart';
import '../../domain/usecases/approve_submission_usecase.dart';
import '../../domain/usecases/reject_submission_usecase.dart';

class AdminProvider extends ChangeNotifier {
  final GetPendingSubmissionsUseCase _getPendingUseCase;
  final ApproveSubmissionUseCase _approveUseCase;
  final RejectSubmissionUseCase _rejectUseCase;

  AdminProvider({
    required GetPendingSubmissionsUseCase getPendingUseCase,
    required ApproveSubmissionUseCase approveUseCase,
    required RejectSubmissionUseCase rejectUseCase,
  })  : _getPendingUseCase = getPendingUseCase,
        _approveUseCase = approveUseCase,
        _rejectUseCase = rejectUseCase;

  ViewState<List<DestinationEntity>> pendingState = const ViewLoading();

  Future<void> loadPending() async {
    pendingState = const ViewLoading();
    notifyListeners();

    final result = await _getPendingUseCase(const NoParams());
    switch (result) {
      case Success<List<DestinationEntity>>(:final data):
        pendingState = data.isEmpty
            ? const ViewEmpty(message: 'No pending submissions. All caught up!')
            : ViewLoaded(data);
      case Error<List<DestinationEntity>>(:final failure):
        pendingState = ViewFailed(failure.message);
    }
    notifyListeners();
  }

  Future<void> approve(String id) async {
    final result = await _approveUseCase(id);
    if (result is Success<void>) {
      await loadPending();
    }
  }

  Future<void> reject(String id) async {
    final result = await _rejectUseCase(id);
    if (result is Success<void>) {
      await loadPending();
    }
  }
}