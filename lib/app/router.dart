import 'package:flutter/material.dart';

import '../features/auth/presentation/auth_page.dart';
import '../features/splash/presentation/splash_page.dart';
import 'di.dart';
import 'main_shell_page.dart';

class AppRoutes {
  static const splash = '/';
  static const auth = '/auth';

  /// Primary post-login container (tabs + nested navigators).
  static const main = '/main';

  /// Alias for [main] for legacy call sites.
  static const restaurants = '/restaurants';

  /// Used only inside the home tab [Navigator] ([ShellHomeTabRoutes]).
  static const details = '/details';
  static const review = '/review';
  static const receipt = '/receipt';
  static const result = '/result';
  static const profile = '/profile';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    AppDependencies dependencies,
  ) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(
          builder: (_) => SplashPage(dependencies: dependencies),
          settings: settings,
        );
      case AppRoutes.auth:
        return MaterialPageRoute<void>(
          builder: (_) => AuthPage(dependencies: dependencies),
          settings: settings,
        );
      case AppRoutes.main:
      case AppRoutes.restaurants:
        return MaterialPageRoute<void>(
          builder: (_) => MainShellPage(dependencies: dependencies),
          settings: settings,
        );
      default:
        return _errorRoute('Unknown route: ${settings.name}');
    }
  }

  static MaterialPageRoute<void> _errorRoute(String message) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(body: Center(child: Text(message))),
    );
  }
}
