import '../core/constants/splash_constants.dart';
import '../features/auth/application/auth_cubit.dart';
import '../features/auth/application/login_use_case.dart';
import '../features/auth/data/auth_repository_impl.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/partner_analytics/application/partner_dashboard_cubit.dart';
import '../features/partner_analytics/data/partner_analytics_repository_impl.dart';
import '../features/partner_analytics/domain/partner_analytics_repository.dart';
import '../features/partner_branches/application/partner_branch_details_cubit.dart';
import '../features/partner_branches/application/partner_branches_cubit.dart';
import '../features/partner_branches/data/partner_branches_repository_impl.dart';
import '../features/partner_branches/domain/partner_branches_repository.dart';
import '../features/partner_quality_alerts/application/partner_quality_alerts_cubit.dart';
import '../features/partner_quality_alerts/data/partner_quality_alerts_repository_impl.dart';
import '../features/partner_quality_alerts/domain/partner_quality_alerts_repository.dart';
import '../features/gamification/application/gamification_cubit.dart';
import '../features/gamification/data/gamification_repository_impl.dart';
import '../features/gamification/domain/gamification_repository.dart';
import '../features/notifications/application/notifications_cubit.dart';
import '../features/notifications/data/notifications_repository_impl.dart';
import '../features/notifications/domain/notifications_repository.dart';
import '../features/orders/application/get_orders_use_case.dart';
import '../features/orders/application/orders_list_cubit.dart';
import '../features/orders/data/orders_repository_impl.dart';
import '../features/orders/domain/orders_repository.dart';
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
import '../features/rewards/application/rewards_list_cubit.dart';
import '../features/rewards/data/rewards_repository_impl.dart';
import '../features/rewards/domain/rewards_repository.dart';
import '../features/reviews/application/get_user_reviews_use_case.dart';
import '../features/reviews/application/review_form_cubit.dart';
import '../features/reviews/application/review_history_cubit.dart';
import '../features/reviews/application/user_reviews_list_cubit.dart';
import '../features/reviews/data/review_history_repository_impl.dart';
import '../features/reviews/data/review_repository_impl.dart';
import '../features/reviews/data/user_reviews_repository_impl.dart';
import '../features/reviews/domain/review_history_repository.dart';
import '../features/reviews/domain/review_repository.dart';
import '../features/reviews/domain/user_reviews_repository.dart';
import '../features/settings/application/settings_cubit.dart';
import '../features/splash/application/check_authorization_use_case.dart';
import '../features/splash/application/splash_cubit.dart';
import '../features/wallet/application/bonus_wallet_cubit.dart';
import '../features/wallet/data/bonus_wallet_repository_impl.dart';
import '../features/wallet/domain/bonus_wallet_repository.dart';

/// Composition root: wires repositories, use cases, and cubit factories.
class AppDependencies {
  factory AppDependencies({
    Duration splashMinDisplayDuration = SplashConstants.minDisplayDuration,
  }) {
    final authRepository = AuthRepositoryImpl();
    final restaurantsRepository = RestaurantsRepositoryImpl();
    final bonusWalletRepository = BonusWalletRepositoryImpl();
    final profileRepository = ProfileRepositoryImpl(bonusWalletRepository);
    final reviewRepository = ReviewRepositoryImpl();
    final reviewHistoryRepository = ReviewHistoryRepositoryImpl();
    final ordersRepository = OrdersRepositoryImpl();
    final userReviewsRepository = UserReviewsRepositoryImpl();
    final rewardsRepository = RewardsRepositoryImpl(profileRepository);
    final gamificationRepository = GamificationRepositoryImpl();
    final notificationsRepository = NotificationsRepositoryImpl();
    final partnerAnalyticsRepository = PartnerAnalyticsRepositoryImpl();
    final partnerBranchesRepository = PartnerBranchesRepositoryImpl();
    final partnerQualityAlertsRepository = PartnerQualityAlertsRepositoryImpl();
    return AppDependencies._(
      splashMinDisplayDuration: splashMinDisplayDuration,
      authRepository: authRepository,
      restaurantsRepository: restaurantsRepository,
      bonusWalletRepository: bonusWalletRepository,
      profileRepository: profileRepository,
      reviewRepository: reviewRepository,
      reviewHistoryRepository: reviewHistoryRepository,
      ordersRepository: ordersRepository,
      userReviewsRepository: userReviewsRepository,
      rewardsRepository: rewardsRepository,
      gamificationRepository: gamificationRepository,
      notificationsRepository: notificationsRepository,
      partnerAnalyticsRepository: partnerAnalyticsRepository,
      partnerBranchesRepository: partnerBranchesRepository,
      partnerQualityAlertsRepository: partnerQualityAlertsRepository,
    );
  }

  const AppDependencies._({
    required this.splashMinDisplayDuration,
    required this.authRepository,
    required this.restaurantsRepository,
    required this.bonusWalletRepository,
    required this.profileRepository,
    required this.reviewRepository,
    required this.reviewHistoryRepository,
    required this.ordersRepository,
    required this.userReviewsRepository,
    required this.rewardsRepository,
    required this.gamificationRepository,
    required this.notificationsRepository,
    required this.partnerAnalyticsRepository,
    required this.partnerBranchesRepository,
    required this.partnerQualityAlertsRepository,
  });

  /// Minimum splash visibility; tests may pass [Duration.zero].
  final Duration splashMinDisplayDuration;

  final AuthRepository authRepository;
  final RestaurantsRepository restaurantsRepository;
  final BonusWalletRepository bonusWalletRepository;
  final ProfileRepository profileRepository;
  final ReviewRepository reviewRepository;
  final ReviewHistoryRepository reviewHistoryRepository;
  final OrdersRepository ordersRepository;
  final UserReviewsRepository userReviewsRepository;
  final RewardsRepository rewardsRepository;
  final GamificationRepository gamificationRepository;
  final NotificationsRepository notificationsRepository;
  final PartnerAnalyticsRepository partnerAnalyticsRepository;
  final PartnerBranchesRepository partnerBranchesRepository;
  final PartnerQualityAlertsRepository partnerQualityAlertsRepository;

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

  ReviewHistoryCubit createReviewHistoryCubit() =>
      ReviewHistoryCubit(reviewHistoryRepository);

  BonusWalletCubit createBonusWalletCubit() =>
      BonusWalletCubit(bonusWalletRepository, _getProfileUseCase);

  RewardsListCubit createRewardsListCubit() =>
      RewardsListCubit(rewardsRepository);

  GamificationCubit createGamificationCubit() =>
      GamificationCubit(gamificationRepository);

  NotificationsCubit createNotificationsCubit() =>
      NotificationsCubit(notificationsRepository);

  SettingsCubit createSettingsCubit() =>
      SettingsCubit(_getProfileUseCase, profileRepository);

  PartnerDashboardCubit createPartnerDashboardCubit() =>
      PartnerDashboardCubit(partnerAnalyticsRepository);

  PartnerBranchesCubit createPartnerBranchesCubit() =>
      PartnerBranchesCubit(partnerBranchesRepository);

  PartnerBranchDetailsCubit createPartnerBranchDetailsCubit() =>
      PartnerBranchDetailsCubit(partnerBranchesRepository);

  PartnerQualityAlertsCubit createPartnerQualityAlertsCubit() =>
      PartnerQualityAlertsCubit(partnerQualityAlertsRepository);
}
