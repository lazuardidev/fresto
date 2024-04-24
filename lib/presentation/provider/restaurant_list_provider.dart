import 'package:flutter/material.dart';
import '../../data/api/api_service.dart';
import '../../data/model/restaurant_list_model.dart';
import '../../common/state_enum.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    fetchAllRestaurant();
  }

  late RestaurantListResult _restaurantListResult;
  RestaurantListResult get result => _restaurantListResult;

  late RequestState _state;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = RequestState.loading;
      notifyListeners();

      final restaurantList = await apiService.getRestaurants();
      if (restaurantList.count == 0 && restaurantList.restaurants.isEmpty) {
        _state = RequestState.empty;
        notifyListeners();

        return _message = 'Empty Data';
      } else {
        _state = RequestState.loaded;
        notifyListeners();

        return _restaurantListResult = restaurantList;
      }
    } catch (e) {
      _state = RequestState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}
