import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/domain/model/food_cart.dart';
import 'package:food_delivery_app/app/domain/model/user.dart';
import 'package:food_delivery_app/app/data/sources/database.dart';
import 'package:food_delivery_app/app/data/sources/shared_pref.dart';
import 'package:food_delivery_app/app/presentation/common/app_elevated_button.dart';

import '../common/widget_support.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  Future<QuerySnapshot>? cartItems;
  double totalPrice = 0.0;
  late User user;

  Future getCartItems() async {
    user = await SharedPref.getUser();
    cartItems = Database().getCartItems(user.id);
    totalPrice = 0.0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  @override
  void dispose() {
    cartItems = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Cart',
          style: AppWidget.headlineTextFieldStyle(),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: cartItems,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final foodCart =
                      FoodCart.fromJson(doc.data() as Map<String, dynamic>);
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Card(
                      child: Row(
                        children: [
                          Text(
                            'x${foodCart.quantity}',
                            style: AppWidget.lightTextFieldStyle(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                foodCart.image,
                                height: 75,
                                width: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                foodCart.name,
                                style: AppWidget.lightTextFieldStyle(),
                              ),
                              Text(
                                '\$${foodCart.totalPrice}',
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await Database()
                                  .removeFromCart(
                                user.id,
                                foodCart.name,
                              )
                                  .then(
                                (_) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartView(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  'Cart is Empty',
                  style: AppWidget.lightTextFieldStyle(),
                ),
              ],
            ),
          );
        },
      ),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: AppWidget.lightTextFieldStyle(),
                ),
                Text(
                  '\$$totalPrice',
                  style: AppWidget.semiBoldTextFieldStyle(),
                )
              ],
            ),
            AppElevatedButton(
              'Checkout',
              onPressed: () async {
                final wallet = user.wallet;
                if (wallet >= totalPrice) {
                  user.wallet = wallet - totalPrice;
                  await Database()
                      .updateUserInfo(user.id, user.toJson())
                      .then((_) async {
                    await Database().cleanCart(user.id).then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartView(),
                        ),
                      );
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red.shade900,
                      content: Text(
                        'Order Placed Successfully',
                        style: AppWidget.semiBoldTextFieldStyle()
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red.shade900,
                      content: Text(
                        'Insufficient Balance',
                        style: AppWidget.semiBoldTextFieldStyle()
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
