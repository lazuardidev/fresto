import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/state_enum.dart';
import '../provider/database_provider.dart';
import '../widgets/card_restaurant.dart';
import '../widgets/response_message.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/restaurant_favorites';

  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildList(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Favorite'),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (_, provider, __) {
        if (provider.state == RequestState.loaded) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            itemCount: provider.favorites.length,
            itemBuilder: (_, index) {
              final restaurant = provider.favorites[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
        } else {
          return ResponseMessage(
            image: 'assets/images/empty-data.png',
            message: provider.message,
          );
        }
      },
    );
  }
}
