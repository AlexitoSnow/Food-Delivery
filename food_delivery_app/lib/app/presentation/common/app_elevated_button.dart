import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.red.shade900),
      padding:
          MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50)),
    );
    var labelWidget = Text(
      label,
      style: AppWidget.lightTextFieldStyle().copyWith(color: Colors.white),
    );
    if (icon != null) {
      return ElevatedButton.icon(
        style: buttonStyle,
        onPressed: onPressed,
        icon: Icon(icon),
        label: labelWidget,
      );
    }
    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: labelWidget,
    );
  }
}
