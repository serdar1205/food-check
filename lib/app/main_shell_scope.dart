import 'package:flutter/material.dart';

import 'di.dart';

/// Provides shell navigation to descendants (e.g. "На главную" after review submit).
class MainShellScope extends InheritedWidget {
  const MainShellScope({
    super.key,
    required this.dependencies,
    required this.tabNavigatorKeys,
    required this.currentTabIndex,
    required this.onTabSelected,
    required this.goToHomeTab,
    required super.child,
  });

  final AppDependencies dependencies;
  final List<GlobalKey<NavigatorState>> tabNavigatorKeys;
  final int currentTabIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback goToHomeTab;

  @override
  bool updateShouldNotify(MainShellScope oldWidget) {
    return currentTabIndex != oldWidget.currentTabIndex ||
        tabNavigatorKeys != oldWidget.tabNavigatorKeys ||
        dependencies != oldWidget.dependencies;
  }
}
