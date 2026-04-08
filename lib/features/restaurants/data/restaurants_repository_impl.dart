import '../domain/restaurant.dart';
import '../domain/restaurants_repository.dart';

class RestaurantsRepositoryImpl implements RestaurantsRepository {
  static const List<Restaurant> _items = <Restaurant>[
    Restaurant(
      id: '1',
      name: 'Пиццерия Наполи',
      rating: 4.0,
      address: 'ул. Пушкина, д. 12',
      cuisine: 'Итальянская',
      description:
          'Аутентичная неаполитанская пицца, дровяная печь и уютный зал.',
      imageUrl: 'https://picsum.photos/seed/napoli/400',
      foodQualityScore: 8,
      serviceScore: 7,
      atmosphereScore: 9,
      priceQualityScore: 6,
    ),
    Restaurant(
      id: '2',
      name: 'Суши-бар «Токио»',
      rating: 4.9,
      address: 'пр. Мира, 42',
      cuisine: 'Японская',
      description: 'Свежие роллы и сашими, доставка и зал для гостей.',
      imageUrl: 'https://picsum.photos/seed/tokyo/200',
      foodQualityScore: 9,
      serviceScore: 9,
      atmosphereScore: 8,
      priceQualityScore: 7,
    ),
    Restaurant(
      id: '3',
      name: 'Бургерная «Гриль Хаус»',
      rating: 4.2,
      address: 'ул. Ленина, 8',
      cuisine: 'Фастфуд',
      description: 'Сочные бургеры, картофель и молочные коктейли.',
      imageUrl: 'https://picsum.photos/seed/grill/200',
      foodQualityScore: 8,
      serviceScore: 7,
      atmosphereScore: 7,
      priceQualityScore: 8,
    ),
    Restaurant(
      id: '4',
      name: 'Кофейня «Латте Арт»',
      rating: 4.3,
      address: 'ул. Советская, 3',
      cuisine: 'Кафе',
      description: 'Авторский кофе, десерты и завтраки до 14:00.',
      imageUrl: 'https://picsum.photos/seed/latte/200',
      foodQualityScore: 8,
      serviceScore: 8,
      atmosphereScore: 9,
      priceQualityScore: 7,
      isNew: true,
    ),
    Restaurant(
      id: '5',
      name: 'Стейк-хаус «Мясо»',
      rating: 4.8,
      address: 'ул. Гагарина, 21',
      cuisine: 'Гриль',
      description: 'Стейки из мраморной говяды и винная карта.',
      imageUrl: 'https://picsum.photos/seed/steak/200',
      foodQualityScore: 10,
      serviceScore: 9,
      atmosphereScore: 8,
      priceQualityScore: 7,
    ),
    Restaurant(
      id: '6',
      name: 'Траттория «Белла Италия»',
      rating: 4.6,
      address: 'наб. Речная, 7',
      cuisine: 'Итальянская',
      description: 'Домашняя паста, ризотто и итальянские вина.',
      imageUrl: 'https://picsum.photos/seed/bella/200',
      foodQualityScore: 9,
      serviceScore: 8,
      atmosphereScore: 8,
      priceQualityScore: 7,
    ),
  ];

  @override
  Future<List<Restaurant>> getRestaurants() async => _items;

  @override
  Future<Restaurant?> getById(String id) async {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
