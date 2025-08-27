import 'package:complex_ui/bootstrap.dart';
import 'package:complex_ui/core/config/flavor.dart';

void main() {
  FlavorConfig.initialize(AppFlavor.test);
  bootstrap();
}
