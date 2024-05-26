import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/common/app_elevated_button.dart';
import 'package:food_delivery_app/app/presentation/common/app_text_field.dart';
import 'package:food_delivery_app/app/presentation/common/auth_background.dart';

import '../../common/widget_support.dart';
import 'admin_home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        headerIcon: Icons.admin_panel_settings_outlined,
        headerText: 'Let\'s start with Admin!',
        formFields: [
          AppTextField(
            controller: usernameController,
            hintText: 'Username',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email is required';
              }
              return null;
            },
          ),
          AppTextField(
            controller: passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
        ],
        button: AppElevatedButton(
          'Login',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              loginAdmin();
            }
          },
        ),
        heightFactor: 0.5,
        formKey: formKey,
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection('admin').get().then((snapshot) {
      for (var result in snapshot.docs) {
        final username = usernameController.text.trim();
        final password = passwordController.text;
        if (result['username'] == username && result['password'] == password) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHome(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade900,
              content: Text(
                'The account already exists for that email',
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
            ),
          );
        }
      }
    });
  }
}
