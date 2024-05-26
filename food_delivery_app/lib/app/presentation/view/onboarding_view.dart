import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

import 'login_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: contents.length,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          contents[index].icon,
                          size: MediaQuery.of(context).size.width * 0.8,
                          color: Colors.red.shade600,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          contents[index].title,
                          style: AppWidget.headlineTextFieldStyle(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          contents[index].description,
                          style: AppWidget.lightTextFieldStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length, (index) => buildDot(context, index)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Ink(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    if (currentIndex == contents.length - 1) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const Login()));
                    } else {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                  child: Text(
                    currentIndex == contents.length - 1 ? 'Get Started' : 'Next',
                    style: AppWidget.semiBoldTextFieldStyle()
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot(BuildContext context, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 10,
      width: currentIndex == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.red.shade600 : Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class OnBoardingContent {
  String? image;
  String title;
  String description;
  IconData? icon;

  OnBoardingContent({
    required this.title,
    required this.description,
    this.icon,
    this.image,
  });
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
    title: 'Select from our\nBest Menu',
    description: 'Pick yout food from our menu\nMore than',
    icon: Icons.menu_book_outlined,
  ),
  OnBoardingContent(
    title: 'Easy and Online payment',
    description: 'You can pay cash on delivery and\ncard payment is available',
    icon: Icons.delivery_dining,
  ),
  OnBoardingContent(
    title: 'Quick delivery at your doorstep',
    description: 'Delivery your food at your\ndoorstep',
    icon: Icons.restaurant_outlined,
    image: 'assets/images/onboard3.png',
  ),
];
