/*
MVP Presenter Template (Provider)
=================================

Kullanım: Yeni bir özellik için presenter ve view arayüzlerini aşağıdaki şablona göre oluşturun.

import 'package:provider/provider.dart';
import 'package:complex_ui_openai/core/mvp/presenter.dart';

abstract class <Feature>View {
  // View'e özgü UI geri çağrıları (opsiyonel)
  // void showError(String message);
}

abstract class I<Feature>Presenter {
  Future<void> init();
  // Özelliğe özgü aksiyonlar
  // Future<void> doSomething();
}

class <Feature>Presenter extends Presenter<<Feature>View>
    implements I<Feature>Presenter {
  // Gerekli bağımlılıkları DI ile alın (Controller/Repo vs.)
  // <Feature>Presenter(this._controller);

  @override
  Future<void> init() async {
    // İlk yükleme/başlatma işlemleri
  }
}

// Örnek kullanım: View içinde Provider ile controller'ı alıp presenter oluşturun.
// final controller = Provider.of<<Feature>Controller>(context, listen: false);
// final presenter = <Feature>Presenter(controller);

*/
