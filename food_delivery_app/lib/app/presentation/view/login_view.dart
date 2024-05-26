import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/app/data/routes/app_screens.dart';
import 'package:food_delivery_app/app/presentation/common/app_elevated_button.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/app_text_field.dart';
import '../common/auth_background.dart';
import '../controllers/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginController>();
    final formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: AuthBackground(
          headerIcon: Icons.login,
          button: AppElevatedButton(
            'Login',
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final message = await provider.login();
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
          formKey: formKey,
          headerText: 'Login',
          heightFactor: 0.4,
          auxiliaryButton: TextButton(
            onPressed: () => context.goNamed(AppRoutes.signUp),
            child: Text(
              'Don\'t have an account? Sign up',
              style: AppWidget.lightTextFieldStyle(),
            ),
          ),
          formFields: [
            AppTextField(
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: provider.onEmailChanged,
            ),
            AppTextField(
              hintText: 'Password',
              prefixIcon: Icons.password_outlined,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onChanged: provider.onPasswordChanged,
              suffix: IconButton(
                icon: Icon(provider.isVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: provider.toggleVisibility,
              ),
              obscureText: !provider.isVisible,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.goNamed(AppRoutes.forgotPassword),
                child: Text(
                  'Forgot Password?',
                  style: AppWidget.lightTextFieldStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
