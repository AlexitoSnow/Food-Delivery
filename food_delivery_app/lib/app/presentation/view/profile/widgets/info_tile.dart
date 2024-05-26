import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: AppWidget.lightTextFieldStyle(),
        ),
        subtitle: Text(
          value,
          style: AppWidget.semiBoldTextFieldStyle(),
        ),
        leading: Icon(icon),
      ),
    );
  }
}
