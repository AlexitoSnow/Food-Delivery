import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/app/presentation/controllers/sign_up_controller.dart';
import 'package:food_delivery_app/app/presentation/common/app_elevated_button.dart';
import 'package:food_delivery_app/app/presentation/common/app_text_field.dart';
import 'package:food_delivery_app/app/presentation/common/auth_background.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignUpController>();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: AuthBackground(
        formKey: formKey,
        button: AppElevatedButton(
          'Register',
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final message = await provider.signUp();
              if (message != null) {
                Fluttertoast.showToast(
                  msg: message,
                  backgroundColor: Colors.red.shade900,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            }
          },
        ),
        headerText: 'Sign Up',
        heightFactor: 0.6,
        auxiliaryButton: TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Already have an account? Log in',
            style: AppWidget.lightTextFieldStyle(),
          ),
        ),
        headerIcon: Icons.app_registration_outlined,
        formFields: [
          AppTextField(
            onChanged: provider.onNameChanged,
            hintText: 'Name',
            prefixIcon: Icons.person_outline_outlined,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          AppTextField(
            onChanged: provider.onEmailChanged,
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          AppTextField(
            onChanged: provider.onPasswordChanged,
            hintText: 'Password',
            prefixIcon: Icons.password_outlined,
            suffix: IconButton(
              icon: Icon(
                  provider.isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: provider.toggleVisibility,
            ),
            obscureText: !provider.isVisible,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
