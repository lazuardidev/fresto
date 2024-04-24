import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_list_model.dart';

class ApiService {
  final http.Client client;
  ApiService(this.client);
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResult> getRestaurants() async {
    final response = await client.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantListResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<RestaurantDetailResult> getRestaurantById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
