import 'package:flutter/material.dart';

import 'main_shell_scope.dart';
import 'router.dart';

/// Pops the home tab to root and selects tab 0; falls back to global [AppRoutes.main].
void navigateToMainHome(BuildContext context) {
  final MainShellScope? scope = context
      .findAncestorWidgetOfExactType<MainShellScope>();
  if (scope != null) {
    scope.goToHomeTab();
    return;
  }
  Navigator.of(
    context,
  ).pushNamedAndRemoveUntil(AppRoutes.main, (Route<dynamic> route) => false);
}
