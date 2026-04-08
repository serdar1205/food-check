import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'di.dart';
import 'router.dart';

class FoodCheckApp extends StatelessWidget {
  const FoodCheckApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodCheck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryYellow,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, dependencies),
    );
  }
}
