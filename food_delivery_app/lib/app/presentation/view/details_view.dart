import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/domain/model/food_cart.dart';
import 'package:food_delivery_app/app/domain/model/food_item.dart';
import 'package:food_delivery_app/app/data/sources/shared_pref.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

import '../../data/sources/database.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key, required this.foodItem});

  final FoodItem foodItem;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  int quantity = 1;
  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.red.shade900,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.foodItem.image,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.foodItem.category,
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                    Text(
                      widget.foodItem.name,
                      style: AppWidget.boldTextFieldStyle(),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade900),
                  ),
                  color: Colors.white,
                  onPressed: () => setState(() => quantity--),
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    quantity.toString(),
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ),
                IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade900),
                  ),
                  color: Colors.white,
                  onPressed: () => setState(() => quantity++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Delivery Time',
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                const Spacer(),
                const Icon(
                  Icons.alarm,
                  color: Colors.black54,
                ),
                Text(
                  '${widget.foodItem.deliveryTime} min',
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
              ],
            ),
            Text(
              widget.foodItem.description,
              style: AppWidget.lightTextFieldStyle(),
              maxLines: 3,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Price',
                          style: AppWidget.semiBoldTextFieldStyle()),
                      Text(
                        '\$${widget.foodItem.price * quantity}',
                        style: AppWidget.boldTextFieldStyle(),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final foodCart = FoodCart(
                        name: widget.foodItem.name,
                        quantity: quantity,
                        totalPrice: widget.foodItem.price * quantity,
                        image: widget.foodItem.image,
                      );
                      final userId = (await SharedPref.getUser()).id;
                      try {
                        await Database().addToCart(userId, foodCart.toJson());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red.shade900,
                            content: Text(
                              'Added to cart',
                              style: AppWidget.semiBoldTextFieldStyle()
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red.shade900,
                            content: Text(
                              'Failed to add to cart',
                              style: AppWidget.semiBoldTextFieldStyle()
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red.shade900),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    icon: Ink(
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
