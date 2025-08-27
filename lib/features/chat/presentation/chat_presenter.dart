import 'package:complex_ui/core/mvp/presenter.dart';

abstract class ChatListView {}

abstract class IChatPresenter {
  Future<void> init();
  // Future<void> loadConversations();
}

class ChatPresenter extends Presenter<ChatListView> implements IChatPresenter {
  @override
  Future<void> init() async {}
}
