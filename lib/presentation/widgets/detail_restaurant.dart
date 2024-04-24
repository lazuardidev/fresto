import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fresto/presentation/widgets/capsule_name.dart';
import 'package:fresto/presentation/widgets/review.dart';
import 'package:provider/provider.dart';
import '../../data/model/restaurant_detail_model.dart';
import '../../data/model/restaurant_list_model.dart';
import '../provider/database_notifier.dart';
import '../provider/restaurant_detail_notifier.dart';

class ContentRestaurant extends StatelessWidget {
  final RestaurantDetail restaurant;
  final RestaurantDetailNotifier provider;

  const ContentRestaurant({
    super.key,
    required this.restaurant,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final heightImage = MediaQuery.of(context).size.height * 0.4;
    final widthImage = MediaQuery.of(context).size.width;

    return Consumer<DatabaseNotifier>(
      builder: (_, providerFavorite, __) {
        return FutureBuilder(
          future: providerFavorite.isFavorited(restaurant.id),
          builder: (_, snapshot) {
            final isFavorited = snapshot.data ?? false;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: heightImage,
                    width: widthImage,
                    child: Stack(
                      children: [
                        Container(
                          height: heightImage,
                          width: widthImage,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        restaurant.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Container(
                                        child: isFavorited
                                            ? IconButton(
                                                onPressed: () =>
                                                    providerFavorite
                                                        .removeFavorite(
                                                            restaurant.id),
                                                color: Colors.pink,
                                                icon:
                                                    const Icon(Icons.favorite))
                                            : IconButton(
                                                onPressed: () =>
                                                    providerFavorite
                                                        .addFavorite(
                                                  Restaurant(
                                                    id: restaurant.id,
                                                    name: restaurant.name,
                                                    description:
                                                        restaurant.description,
                                                    city: restaurant.city,
                                                    pictureId:
                                                        restaurant.pictureId,
                                                    rating: restaurant.rating,
                                                  ),
                                                ),
                                                color: Colors.pink,
                                                icon: const Icon(
                                                    Icons.favorite_border),
                                              ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 18,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.city,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: const Color(0xFF616161)),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        '${restaurant.rating}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(width: 4),
                                      RatingBarIndicator(
                                        rating: restaurant.rating,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemSize: 18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Category :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              direction: Axis
                                  .horizontal, // Start listing items from left to right
                              children: List.generate(
                                  restaurant.categories.length,
                                  (index) => CapsuleName(
                                        name: restaurant.categories[index].name,
                                      )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Foods :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              direction: Axis
                                  .horizontal, // Start listing items from left to right
                              children: List.generate(
                                  restaurant.menus.foods.length,
                                  (index) => CapsuleName(
                                        name:
                                            restaurant.menus.foods[index].name,
                                      )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Drinks :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              direction: Axis
                                  .horizontal, // Start listing items from left to right
                              children: List.generate(
                                  restaurant.menus.drinks.length,
                                  (index) => CapsuleName(
                                        name:
                                            restaurant.menus.drinks[index].name,
                                      )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Description :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          restaurant.description,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Review(
                          provider: provider,
                          restaurant: restaurant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
