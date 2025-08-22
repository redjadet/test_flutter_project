import 'package:flutter/material.dart';

abstract class INavigationService {
  void navigateTo(Widget screen);
  void navigateBack();
  void showSnackBar(String message);
  void showModalBottomSheet(Widget child);
}

class NavigationService implements INavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  NavigatorState get navigator => navigatorKey.currentState!;
  ScaffoldMessengerState get scaffoldMessenger =>
      scaffoldMessengerKey.currentState!;

  @override
  void navigateTo(Widget screen) {
    navigator.push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  void navigateBack() {
    navigator.pop();
  }

  @override
  void showSnackBar(String message) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void showModalBottomSheet(Widget child) {
    navigator.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        opaque: false,
        barrierDismissible: true,
      ),
    );
  }
}
