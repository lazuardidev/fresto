import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../data/api/api_service.dart';
import '../common/state_enum.dart';
import '../data/model/restaurant_list_model.dart';
import '../provider/restaurant_detail_provider.dart';
import '../widget/content_restaurant.dart';
import '../widget/loading.dart';
import '../widget/text_message.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  final Restaurant restaurant;
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(
        apiService: ApiService(http.Client()),
        restaurantId: restaurant.id,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RestaurantDetailProvider>(
          builder: (_, provider, __) {
            return provider.state == RequestState.loading
                ? const Text('...')
                : Text(provider.result.restaurant.name);
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<RestaurantDetailProvider>(
          builder: (_, provider, __) {
            switch (provider.state) {
              case RequestState.loading:
                return const Loading();
              case RequestState.loaded:
                return ContentRestaurant(
                  provider: provider,
                  restaurant: provider.result.restaurant,
                );
              case RequestState.error:
                return TextMessage(
                  image: 'assets/images/no-internet.png',
                  message: 'Koneksi Terputus',
                  onPressed: () =>
                      provider.fetchDetailRestaurant(restaurant.id),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
