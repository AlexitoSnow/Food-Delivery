import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/view/admin/admin_items.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Home',
          style: AppWidget.headlineTextFieldStyle(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminItems(),
                ),
              ),
              child: Card(
                child: Row(
                  children: [
                    const Icon(
                      Icons.food_bank,
                      size: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Food Items',
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                          'Add food items',
                          style: AppWidget.lightTextFieldStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
