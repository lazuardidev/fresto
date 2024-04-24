import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../data/api/api_service.dart';
import '../../common/state_enum.dart';
import '../../data/model/restaurant_list_model.dart';
import '../provider/restaurant_detail_notifier.dart';
import '../widgets/detail_restaurant.dart';
import '../widgets/loading.dart';
import '../widgets/response_message.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  final Restaurant restaurant;
  const DetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailNotifier>(
      create: (_) => RestaurantDetailNotifier(
        apiService: ApiService(http.Client()),
        restaurantId: restaurant.id,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RestaurantDetailNotifier>(
          builder: (_, provider, __) {
            return provider.state == RequestState.loading
                ? const Text('...')
                : Text(provider.result.restaurant.name);
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<RestaurantDetailNotifier>(
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
                return ResponseMessage(
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
