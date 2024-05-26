import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/data/helpers/constants.dart';
import 'package:food_delivery_app/app/domain/model/food_item.dart';
import 'package:food_delivery_app/app/presentation/controllers/home_controller.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';
import 'package:provider/provider.dart';

import 'home/widgets/food_horizontal_card.dart';
import 'home/widgets/food_vertical_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Widget streammingFoodRow(Stream<QuerySnapshot> foodItems) {
    return StreamBuilder<QuerySnapshot>(
      stream: foodItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final DocumentSnapshot doc = snapshot.data!.docs[index];
                final food =
                    FoodItem.fromJson(doc.data() as Map<String, dynamic>);
                return FoodVerticalCard(food: food);
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget streammingFoodColumn(Stream<QuerySnapshot> foodItems) {
    return StreamBuilder<QuerySnapshot>(
      stream: foodItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final DocumentSnapshot doc = snapshot.data!.docs[index];
              final food =
                  FoodItem.fromJson(doc.data() as Map<String, dynamic>);
              return FoodHorizontalCard(food: food);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Hello, ${provider.getUserName()}',
          style: AppWidget.boldTextFieldStyle(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton.filled(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red.shade900),
            ),
            color: Colors.white,
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delicious Food',
                style: AppWidget.headlineTextFieldStyle(),
              ),
              Text(
                'Discover and get great food',
                style: AppWidget.lightTextFieldStyle(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(categories.length, (index) {
                  final key = categories.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      provider.categorySelected = key;
                      provider.getFoodItems();
                    },
                    child: Card(
                      color: provider.categorySelected == key
                          ? Colors.red.shade900
                          : Colors.transparent,
                      key: ValueKey(key),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          categories.values.elementAt(index),
                          size: 50,
                          color: provider.categorySelected == key
                              ? Colors.transparent
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              streammingFoodRow(provider.foodItems!),
              const SizedBox(height: 30),
              Text(
                'Popular Food',
                style: AppWidget.headlineTextFieldStyle(),
              ),
              const SizedBox(height: 20),
              streammingFoodColumn(provider.foodItems!),
            ],
          ),
        ),
      ),
    );
  }
}
