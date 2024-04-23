import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/model/restaurant_detail_model.dart';
import '../data/enum/result_state.dart';

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

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> fetchDetailRestaurant(String restaurantId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurantDetail = await apiService.getRestaurantById(restaurantId);
      _state = ResultState.hasData;
      notifyListeners();

      return _restaurantDetailResult = restaurantDetail;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}
