import 'package:flutter/material.dart';
import '../../data/api/api_service.dart';
import '../../data/model/restaurant_detail_model.dart';
import '../../common/state_enum.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider({
    required this.apiService,
    required this.restaurantId,
  }) {
    fetchDetailRestaurant(restaurantId);
  }

  late RestaurantDetailResult _restaurantDetailResult;
  RestaurantDetailResult get result => _restaurantDetailResult;

  late RequestState _state;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> fetchDetailRestaurant(String restaurantId) async {
    try {
      _state = RequestState.loading;
      notifyListeners();

      final restaurantDetail = await apiService.getRestaurantById(restaurantId);
      _state = RequestState.loaded;
      notifyListeners();

      return _restaurantDetailResult = restaurantDetail;
    } catch (e) {
      _state = RequestState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}
