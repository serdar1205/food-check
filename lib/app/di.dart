import '../core/constants/splash_constants.dart';
import '../features/orders/application/get_orders_use_case.dart';
import '../features/orders/application/orders_list_cubit.dart';
import '../features/orders/data/orders_repository_impl.dart';
import '../features/orders/domain/orders_repository.dart';
import '../features/auth/application/auth_cubit.dart';
import '../features/auth/application/login_use_case.dart';
import '../features/auth/data/auth_repository_impl.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/profile/application/get_profile_use_case.dart';
import '../features/profile/application/profile_cubit.dart';
import '../features/profile/data/profile_repository_impl.dart';
import '../features/profile/domain/profile_repository.dart';
import '../features/receipt_upload/application/receipt_flow_cubit.dart';
import '../features/receipt_upload/application/submit_review_with_receipt_use_case.dart';
import '../features/restaurants/application/get_restaurant_by_id_use_case.dart';
import '../features/restaurants/application/get_restaurants_use_case.dart';
import '../features/restaurants/application/restaurant_list_cubit.dart';
import '../features/restaurants/application/venue_details_cubit.dart';
import '../features/restaurants/data/restaurants_repository_impl.dart';
import '../features/restaurants/domain/restaurant.dart';
import '../features/restaurants/domain/restaurants_repository.dart';
import '../features/reviews/application/get_user_reviews_use_case.dart';
import '../features/reviews/application/review_form_cubit.dart';
import '../features/reviews/application/user_reviews_list_cubit.dart';
import '../features/reviews/data/review_history_repository_impl.dart';
import '../features/reviews/data/review_repository_impl.dart';
import '../features/reviews/data/user_reviews_repository_impl.dart';
import '../features/reviews/domain/review_history_repository.dart';
import '../features/reviews/domain/review_repository.dart';
import '../features/reviews/domain/user_reviews_repository.dart';
import '../features/splash/application/check_authorization_use_case.dart';
import '../features/splash/application/splash_cubit.dart';

/// Composition root: wires repositories, use cases, and cubit factories.
class AppDependencies {
  AppDependencies({
    this.splashMinDisplayDuration = SplashConstants.minDisplayDuration,
  }) : authRepository = AuthRepositoryImpl(),
       restaurantsRepository = RestaurantsRepositoryImpl(),
       profileRepository = ProfileRepositoryImpl(),
       reviewRepository = ReviewRepositoryImpl(),
       reviewHistoryRepository = ReviewHistoryRepositoryImpl(),
       ordersRepository = OrdersRepositoryImpl(),
       userReviewsRepository = UserReviewsRepositoryImpl();

  /// Minimum splash visibility; tests may pass [Duration.zero].
  final Duration splashMinDisplayDuration;

  final AuthRepository authRepository;
  final RestaurantsRepository restaurantsRepository;
  final ProfileRepository profileRepository;
  final ReviewRepository reviewRepository;
  final ReviewHistoryRepository reviewHistoryRepository;
  final OrdersRepository ordersRepository;
  final UserReviewsRepository userReviewsRepository;

  CheckAuthorizationUseCase get _checkAuthorizationUseCase =>
      CheckAuthorizationUseCase(authRepository);

  LoginUseCase get _loginUseCase => LoginUseCase(authRepository);

  GetRestaurantsUseCase get _getRestaurantsUseCase =>
      GetRestaurantsUseCase(restaurantsRepository);

  GetRestaurantByIdUseCase get _getRestaurantByIdUseCase =>
      GetRestaurantByIdUseCase(restaurantsRepository);

  GetProfileUseCase get _getProfileUseCase =>
      GetProfileUseCase(profileRepository);

  GetOrdersUseCase get _getOrdersUseCase => GetOrdersUseCase(ordersRepository);

  GetUserReviewsUseCase get _getUserReviewsUseCase =>
      GetUserReviewsUseCase(userReviewsRepository);

  SubmitReviewWithReceiptUseCase get _submitReviewWithReceiptUseCase =>
      SubmitReviewWithReceiptUseCase(
        reviewRepository,
        profileRepository,
        reviewHistoryRepository,
      );

  SplashCubit createSplashCubit() => SplashCubit(
    _checkAuthorizationUseCase,
    minDisplayDuration: splashMinDisplayDuration,
  );

  AuthCubit createAuthCubit() => AuthCubit(_loginUseCase);

  RestaurantListCubit createRestaurantListCubit() =>
      RestaurantListCubit(_getRestaurantsUseCase);

  VenueDetailsCubit createVenueDetailsCubit(String restaurantId) =>
      VenueDetailsCubit(_getRestaurantByIdUseCase, restaurantId);

  ReviewFormCubit createReviewFormCubit(Restaurant restaurant) =>
      ReviewFormCubit.fromRestaurant(restaurant);

  ReceiptFlowCubit createReceiptFlowCubit() =>
      ReceiptFlowCubit(_submitReviewWithReceiptUseCase);

  ProfileCubit createProfileCubit() =>
      ProfileCubit(_getProfileUseCase, authRepository);

  OrdersListCubit createOrdersListCubit() => OrdersListCubit(_getOrdersUseCase);

  UserReviewsListCubit createUserReviewsListCubit() =>
      UserReviewsListCubit(_getUserReviewsUseCase);
}
