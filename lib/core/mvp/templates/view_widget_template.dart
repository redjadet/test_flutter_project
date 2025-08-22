/*
View Widget Template (Provider + StatefulWidget)
===============================================

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:complex_ui_openai/core/mvp/presenter.dart';
// import 'package:complex_ui_openai/features/<feature>/presentation/<feature>_presenter.dart';
// import 'package:complex_ui_openai/features/<feature>/state/<feature>_controller.dart';

class <Feature>Screen extends StatefulWidget {
  const <Feature>Screen({super.key});

  @override
  State<<Feature>Screen> createState() => _<Feature>ScreenState();
}

class _<Feature>ScreenState extends State<<Feature>Screen>
    implements <Feature>View {
  late final I<Feature>Presenter _presenter;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<<Feature>Controller>(context, listen: false);
    _presenter = <Feature>Presenter(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_presenter is Presenter<<Feature>View>) {
        (_presenter as Presenter<<Feature>View>).attachView(this);
      }
      _presenter.init();
    });
  }

  @override
  void dispose() {
    final p = _presenter;
    if (p is Presenter<<Feature>View>) {
      p.detachView();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI burada: durum Provider üzerinden context.select ile okunur; aksiyonlar presenter'a delege edilir.
    return const SizedBox.shrink();
  }
}

*/
