import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/restaurant_list_model.dart';
import '../provider/database_notifier.dart';
import '../pages/detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;
  const CardRestaurant({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseNotifier>(
      builder: (_, provider, __) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (_, snapshot) {
            final isFavorited = snapshot.data ?? false;

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailPage.routeName,
                  arguments: restaurant,
                );
              },
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Image.network(
                            'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey[400],
                                  ),
                                );
                              }
                            },
                            errorBuilder: (_, __, ___) {
                              return Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey[400],
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                          ),
                          isFavorited
                              ? IconButton(
                                  onPressed: () =>
                                      provider.removeFavorite(restaurant.id),
                                  color: Colors.pink,
                                  icon: const Icon(Icons.favorite))
                              : IconButton(
                                  onPressed: () =>
                                      provider.addFavorite(restaurant),
                                  color: Colors.pink,
                                  icon: const Icon(Icons.favorite_border),
                                ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant.rating}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: const Color(0xFF616161)),
                          ),
                          const SizedBox(width: 20),
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
                                .copyWith(color: const Color(0xFF616161)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
