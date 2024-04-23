import 'package:flutter/material.dart';
import 'package:fresto/common/state_enum.dart';
import 'package:fresto/provider/restaurant_list_provider.dart';
import 'package:fresto/widget/card_restaurant.dart';
import 'package:fresto/widget/loading.dart';
import 'package:fresto/widget/response_message.dart';
import 'package:provider/provider.dart';
import '../utils/notification_helper.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'setting_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fresto')),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/logo/logo.png'),
              ),
              accountName: Text('Fresto'),
              accountEmail: Text('fresto@restaurant.com'),
            ),
            ListTile(
              leading: const Icon(
                Icons.restaurant_menu,
                color: Colors.orange,
              ),
              title: const Text('Restaurant'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.orange),
              title: const Text('Favorite'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, FavoritePage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, SettingPage.routeName);
              },
              leading: const Icon(
                Icons.settings,
                color: Colors.orange,
              ),
              title: const Text('Setting'),
            ),
          ],
        ),
      ),
      body: _buildList(),
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
            return const ResponseMessage(
              image: 'assets/images/empty-data.png',
              message: 'Data Kosong',
            );
          case RequestState.error:
            return ResponseMessage(
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

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
