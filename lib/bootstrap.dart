import 'dart:ui' as ui;

import 'package:complex_ui_openai/app.dart';
import 'package:complex_ui_openai/core/services/navigation_service.dart';
import 'package:complex_ui_openai/features/dashboard/state/dashboard_controller.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

/// Bootstraps the app with any platform-specific setup, then runs ComplexApp.
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  // Only adjust window size on desktop platforms; keep web compatible.
  if (!kIsWeb) {
    final isDesktop =
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows;
    if (isDesktop) {
      setWindowMinSize(const ui.Size(800, 1000));
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
        Provider<NavigationService>(create: (_) => NavigationService()),
      ],
      child: const ComplexApp(),
    ),
  );
}
