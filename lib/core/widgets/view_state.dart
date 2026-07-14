sealed class ViewState<T> {
  const ViewState();
}

class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}

class ViewLoaded<T> extends ViewState<T> {
  final T data;
  const ViewLoaded(this.data);
}

class ViewEmpty<T> extends ViewState<T> {
  final String message;
  const ViewEmpty({this.message = 'Nothing here yet.'});
}

class ViewFailed<T> extends ViewState<T> {
  final String message;
  const ViewFailed(this.message);
}