enum AppFlavor { dev, test, prod }

class FlavorConfig {
  FlavorConfig._(this.flavor);

  static FlavorConfig? _instance;
  final AppFlavor flavor;

  static void initialize(AppFlavor flavor) {
    _instance = FlavorConfig._(flavor);
  }

  static FlavorConfig get instance {
    final inst = _instance;
    if (inst == null) {
      // Default to dev if not explicitly initialized.
      return FlavorConfig._(AppFlavor.dev);
    }
    return inst;
  }

  static bool get isDev => instance.flavor == AppFlavor.dev;
  static bool get isTest => instance.flavor == AppFlavor.test;
  static bool get isProd => instance.flavor == AppFlavor.prod;
}
