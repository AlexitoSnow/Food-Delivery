import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/common/app_elevated_button.dart';
import 'package:food_delivery_app/app/presentation/common/app_text_field.dart';
import 'package:food_delivery_app/app/presentation/common/auth_background.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

import 'sign_up_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  final _emailController = TextEditingController();

  void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade900,
          content: Text(
            'Password reset email sent',
            style: AppWidget.semiBoldTextFieldStyle()
                .copyWith(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      print(email);
      if (error.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade900,
            content: Text(
              'Invalid email address',
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
              error.message!,
              style: AppWidget.semiBoldTextFieldStyle()
                  .copyWith(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
      ),
      body: AuthBackground(
        headerText: 'Password Recovery',
        formFields: [
          AppTextField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        ],
        button: AppElevatedButton(
          'Send',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              email = _emailController.text;
              resetPassword();
            }
          },
        ),
        auxiliaryButton: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpView(),
              ),
            );
          },
          child: Text(
            'Don\'t have an account? Sign up',
            style: AppWidget.lightTextFieldStyle(),
          ),
        ),
        heightFactor: 0.4,
        headerIcon: Icons.lock_outline,
        formKey: _formKey,
      ),
    );
  }
}
