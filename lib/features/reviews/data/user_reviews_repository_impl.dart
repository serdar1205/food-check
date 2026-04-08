import '../domain/user_review_summary.dart';
import '../domain/user_reviews_repository.dart';

class UserReviewsRepositoryImpl implements UserReviewsRepository {
  @override
  Future<List<UserReviewSummary>> getMyReviews() async {
    return const <UserReviewSummary>[
      UserReviewSummary(
        id: 'ur1',
        restaurantName: 'Napoli',
        dateLabel: '7 апреля 2026',
        overallRating: 5,
        teaser:
            'Отличная пицца и быстрое обслуживание. Обязательно вернёмся с друзьями.',
        status: UserReviewPublicationStatus.published,
      ),
      UserReviewSummary(
        id: 'ur2',
        restaurantName: 'Азбука Вкуса',
        dateLabel: '4 апреля 2026',
        overallRating: 4,
        teaser: 'Хороший выбор готовой еды, очереди вечером небольшие.',
        status: UserReviewPublicationStatus.published,
      ),
      UserReviewSummary(
        id: 'ur3',
        restaurantName: 'Терраса',
        dateLabel: '1 апреля 2026',
        overallRating: 5,
        teaser: 'Уютная атмосфера на веранде. Десерты особенно понравились.',
        status: UserReviewPublicationStatus.pendingModeration,
      ),
      UserReviewSummary(
        id: 'ur4',
        restaurantName: 'Суши Wok',
        dateLabel: '25 марта 2026',
        overallRating: 3,
        teaser: 'Доставка чуть задержалась, но роллы свежие.',
        status: UserReviewPublicationStatus.published,
      ),
    ];
  }
}
