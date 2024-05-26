import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/data/routes/app_screens.dart';
import 'package:food_delivery_app/app/domain/model/food_item.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';
import 'package:go_router/go_router.dart';

class FoodHorizontalCard extends StatelessWidget {
  const FoodHorizontalCard({
    super.key,
    required this.food,
  });

  final FoodItem food;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.details, extra: food),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    food.image,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                      Text(
                        food.shortDescription,
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                      Text(
                        '\$${food.price}',
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
