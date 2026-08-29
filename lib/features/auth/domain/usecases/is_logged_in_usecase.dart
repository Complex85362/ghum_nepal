import '../repositories/auth_repository.dart';

/// Simple synchronous check, not wrapped in Result since it never fails —
/// used for quick UI decisions (e.g. showing a login prompt).
class IsLoggedInUseCase {
  final AuthRepository _repository;
  IsLoggedInUseCase(this._repository);

  bool call() => _repository.currentUserId != null;
}