import 'restaurant.dart';

abstract interface class RestaurantsRepository {
  Future<List<Restaurant>> getRestaurants();

  Future<Restaurant?> getById(String id);
}
