import 'package:complex_ui/core/mvp/presenter.dart';

abstract class ProfileView {}

abstract class IProfilePresenter {
  Future<void> init();
  // Future<void> refreshProfile();
}

class ProfilePresenter extends Presenter<ProfileView>
    implements IProfilePresenter {
  @override
  Future<void> init() async {}
}
