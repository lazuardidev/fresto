import 'package:flutter/material.dart';
import 'package:fresto/common/styles.dart';
import 'package:fresto/data/model/restaurant_detail_model.dart';
import 'package:fresto/presentation/provider/restaurant_detail_provider.dart';

class Review extends StatelessWidget {
  final RestaurantDetail restaurant;
  final RestaurantDetailProvider provider;

  const Review({super.key, required this.restaurant, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    contentPadding: EdgeInsets.zero,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(56, 0, 0, 8),
                    child: Text(
                      review.review,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
    );
  }
}
