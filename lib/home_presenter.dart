import 'dart:async';
abstract class HomeContract {
  void screenUpdate();
}
class HomePresenter {
  HomeContract _view;
  updateScreen() {
    _view.screenUpdate();
  }
}
