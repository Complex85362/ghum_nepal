import '../result/result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// For use cases that take no parameters.
class NoParams {
  const NoParams();
}