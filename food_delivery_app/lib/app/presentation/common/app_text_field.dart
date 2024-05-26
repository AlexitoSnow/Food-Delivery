import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxlines,
    this.suffix,
  });

  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final int? maxlines;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: AppWidget.semiBoldTextFieldStyle(),
      prefixIcon: Icon(prefixIcon),
      suffix: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade900),
      ),
    );
    if (validator != null) {
      return TextFormField(
        controller: controller,
        decoration: inputDecoration,
        cursorColor: Colors.red.shade900,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLines: maxlines ?? 1,
      );
    }
    return TextField(
      controller: controller,
      maxLines: maxlines ?? 1,
      decoration: inputDecoration,
      cursorColor: Colors.red.shade900,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
