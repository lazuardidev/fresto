import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/state_enum.dart';
import '../provider/restaurant_list_provider.dart';
import '../widget/card_restaurant.dart';
import '../widget/loading.dart';
import '../widget/text_message.dart';

class RestaurantListPage extends StatelessWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildList(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Fresto'),
    );
  }

  Widget _buildList() {
    return Consumer<RestaurantListProvider>(
      builder: (_, provider, __) {
        switch (provider.state) {
          case RequestState.loading:
            return const Loading();
          case RequestState.loaded:
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: provider.result.count,
              itemBuilder: (_, index) {
                final restaurant = provider.result.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              },
            );
          case RequestState.empty:
            return const TextMessage(
              image: 'assets/images/empty-data.png',
              message: 'Data Kosong',
            );
          case RequestState.error:
            return TextMessage(
              image: 'assets/images/no-internet.png',
              message: 'Koneksi Terputus',
              onPressed: () => provider.fetchAllRestaurant(),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
