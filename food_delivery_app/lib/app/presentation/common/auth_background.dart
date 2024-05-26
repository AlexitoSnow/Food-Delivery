import 'package:flutter/material.dart';

import 'widget_support.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    this.headerIcon,
    this.headerImage,
    required this.headerText,
    required this.formFields,
    required this.button,
    this.auxiliaryButton,
    required this.heightFactor,
    required this.formKey,
  });

  final IconData? headerIcon;
  final String? headerImage;
  final String headerText;
  final List<Widget> formFields;
  final Widget button;
  final Widget? auxiliaryButton;
  final double heightFactor;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    assert(
      (headerIcon != null) != (headerImage != null),
      'Either headerIcon or headerImage should be provided, but not both.',
    );
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red.shade900,
                Colors.red.shade400,
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
        Center(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                headerIcon != null
                    ? Icon(
                        headerIcon,
                        size: 100,
                        color: Colors.white,
                      )
                    : Image.asset(headerImage!),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * heightFactor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(headerText,
                              style: AppWidget.headlineTextFieldStyle()),
                          ...formFields,
                          button,
                        ],
                      ),
                    ),
                  ),
                ),
                auxiliaryButton ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
