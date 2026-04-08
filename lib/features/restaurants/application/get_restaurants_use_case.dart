import '../domain/restaurant.dart';
import '../domain/restaurants_repository.dart';

class GetRestaurantsUseCase {
  GetRestaurantsUseCase(this._repository);

  final RestaurantsRepository _repository;

  Future<List<Restaurant>> call() => _repository.getRestaurants();
}
