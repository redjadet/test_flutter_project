abstract class Presenter<V> {
  V? _view;

  void attachView(V view) {
    _view = view;
    onViewAttached();
  }

  void detachView() {
    onViewDetached();
    _view = null;
  }

  V? get view => _view;

  void onViewAttached() {}

  void onViewDetached() {}
}
