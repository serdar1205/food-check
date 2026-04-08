import '../domain/restaurant.dart';
import '../domain/restaurants_repository.dart';

class GetRestaurantByIdUseCase {
  GetRestaurantByIdUseCase(this._repository);

  final RestaurantsRepository _repository;

  Future<Restaurant?> call(String id) => _repository.getById(id);
}
