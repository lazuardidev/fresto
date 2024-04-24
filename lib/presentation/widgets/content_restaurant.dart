import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../common/styles.dart';
import '../../data/model/restaurant_detail_model.dart';
import '../../data/model/restaurant_list_model.dart';
import '../provider/database_provider.dart';
import '../provider/restaurant_detail_provider.dart';
import 'card_menu.dart';

class ContentRestaurant extends StatelessWidget {
  final RestaurantDetail restaurant;
  final RestaurantDetailProvider provider;

  const ContentRestaurant({
    super.key,
    required this.restaurant,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final heightImage = MediaQuery.of(context).size.height * 0.4;
    final widthImage = MediaQuery.of(context).size.width;

    return Consumer<DatabaseProvider>(
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
                                  Text(
                                    restaurant.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
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
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                            const SizedBox(width: 8),
                            Container(
                              child: isFavorited
                                  ? FloatingActionButton(
                                      onPressed: () {
                                        providerFavorite
                                            .removeFavorite(restaurant.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                              'Remove from favorite',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.favorite,
                                        size: 28,
                                      ),
                                    )
                                  : FloatingActionButton(
                                      onPressed: () {
                                        providerFavorite.addFavorite(
                                          Restaurant(
                                            id: restaurant.id,
                                            name: restaurant.name,
                                            description: restaurant.description,
                                            city: restaurant.city,
                                            pictureId: restaurant.pictureId,
                                            rating: restaurant.rating,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                              'Added to favorite',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.favorite_border,
                                        size: 28,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Category :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 35,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: restaurant.categories.map((category) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Center(
                                  child: Text(
                                    category.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
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
                        const SizedBox(height: 24),
                        Text(
                          'Foods :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 180,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            children: restaurant.menus.foods.map((food) {
                              return CardMenu(
                                image: 'assets/images/food.png',
                                name: food.name,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Drinks :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 180,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            children: restaurant.menus.drinks.map((drink) {
                              return CardMenu(
                                image: 'assets/images/drink.png',
                                name: drink.name,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Review :',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: restaurant.customerReviews.length,
                            itemBuilder: (context, index) {
                              var review = restaurant.customerReviews[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(review.name),
                                    subtitle: Text(review.date),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(72, 0, 0, 8),
                                    child: Text(
                                      review.review,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  const Divider(
                                    height: 4,
                                    thickness: 2,
                                  ),
                                ],
                              );
                            }),
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
