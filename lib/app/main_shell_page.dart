import 'package:flutter/material.dart';

import '../features/profile/application/profile_cubit.dart';
import 'di.dart';
import 'main_shell_scope.dart';
import '../features/orders/presentation/orders_list_page.dart';
import '../features/reviews/presentation/user_reviews_list_page.dart';
import 'shell_tab_routes.dart';
import 'widgets/main_shell_bottom_nav.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _tabIndex = 0;
  late final List<GlobalKey<NavigatorState>> _tabKeys;
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _tabKeys = List<GlobalKey<NavigatorState>>.generate(
      4,
      (int i) => GlobalKey<NavigatorState>(debugLabel: 'mainShellTab$i'),
    );
    _profileCubit = widget.dependencies.createProfileCubit()..load();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  void _goToHomeTab() {
    setState(() => _tabIndex = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabKeys[0].currentState?.popUntil((Route<dynamic> r) => r.isFirst);
    });
  }

  void _onTabTap(int index) {
    if (index == 0 && _tabIndex == 0) {
      _tabKeys[0].currentState?.popUntil((Route<dynamic> r) => r.isFirst);
    }
    if (index == 3) {
      _profileCubit.load();
    }
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final deps = widget.dependencies;

    return MainShellScope(
      dependencies: deps,
      tabNavigatorKeys: _tabKeys,
      currentTabIndex: _tabIndex,
      onTabSelected: _onTabTap,
      goToHomeTab: _goToHomeTab,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          final NavigatorState? nav = _tabKeys[_tabIndex].currentState;
          if (nav != null && nav.canPop()) {
            nav.pop();
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: _tabIndex,
            sizing: StackFit.expand,
            children: [
              Navigator(
                key: _tabKeys[0],
                onGenerateRoute: (RouteSettings settings) =>
                    ShellHomeTabRoutes.onGenerateRoute(settings, deps),
              ),
              Navigator(
                key: _tabKeys[1],
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (_) => OrdersListPage(dependencies: deps),
                  );
                },
              ),
              Navigator(
                key: _tabKeys[2],
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (_) => UserReviewsListPage(dependencies: deps),
                  );
                },
              ),
              Navigator(
                key: _tabKeys[3],
                onGenerateRoute: (RouteSettings settings) =>
                    ShellProfileTabRoutes.onGenerateRoute(
                      settings,
                      deps,
                      _profileCubit,
                    ),
              ),
            ],
          ),
          bottomNavigationBar: MainShellBottomNav(
            currentIndex: _tabIndex,
            onTap: _onTabTap,
          ),
        ),
      ),
    );
  }
}
