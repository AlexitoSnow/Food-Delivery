import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

class ActionTile extends StatelessWidget {
  const ActionTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});

  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: AppWidget.semiBoldTextFieldStyle(),
        ),
        leading: Icon(icon),
        onTap: onPressed,
      ),
    );
  }
}
