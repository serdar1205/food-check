import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/profile/application/profile_cubit.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/receipt_upload/presentation/receipt_flow_page.dart';
import '../features/restaurants/presentation/restaurants_page.dart';
import '../features/review_result/domain/review_result.dart';
import '../features/review_result/presentation/review_result_page.dart';
import '../features/reviews/domain/review_draft.dart';
import '../features/reviews/presentation/review_form_page.dart';
import '../features/venue_details/presentation/venue_details_page.dart';
import 'di.dart';
import 'router.dart';

/// Routes for the home tab nested [Navigator].
class ShellHomeTabRoutes {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    AppDependencies dependencies,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => RestaurantsPage(dependencies: dependencies),
        );
      case AppRoutes.details:
        final id = settings.arguments as String?;
        if (id == null) {
          return _missingArgsRoute(settings, 'Restaurant id is missing.');
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => dependencies.createVenueDetailsCubit(id),
            child: const VenueDetailsPage(),
          ),
        );
      case AppRoutes.review:
        final id = settings.arguments as String?;
        if (id == null) {
          return _missingArgsRoute(settings, 'Restaurant id is missing.');
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) =>
              ReviewFormPage(dependencies: dependencies, restaurantId: id),
        );
      case AppRoutes.receipt:
        final draft = settings.arguments as ReviewDraft?;
        if (draft == null) {
          return _missingArgsRoute(settings, 'Review draft is missing.');
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) =>
              ReceiptFlowPage(dependencies: dependencies, draft: draft),
        );
      case AppRoutes.result:
        final result = settings.arguments as ReviewResultEntity?;
        if (result == null) {
          return _missingArgsRoute(settings, 'Result is missing.');
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ReviewResultPage(result: result),
        );
      default:
        return _unknownRoute(settings);
    }
  }

  static MaterialPageRoute<void> _missingArgsRoute(
    RouteSettings settings,
    String message,
  ) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(body: Center(child: Text(message))),
    );
  }

  static MaterialPageRoute<void> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(
        body: Center(child: Text('Unknown route: ${settings.name}')),
      ),
    );
  }
}

/// Profile tab nested stack (root = profile).
class ShellProfileTabRoutes {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    AppDependencies dependencies,
    ProfileCubit profileCubit,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: ProfilePage(
              dependencies: dependencies,
              profileCubit: profileCubit,
            ),
          ),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('Unknown route: ${settings.name}')),
          ),
        );
    }
  }
}
