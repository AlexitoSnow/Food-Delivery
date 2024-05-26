import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/presentation/controllers/parent_view_controller.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/constants.dart';

class ParentView extends StatelessWidget {
  const ParentView({super.key, required this.currentWidget});
  final Widget currentWidget;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParentViewController>();
    return SafeArea(
      child: Scaffold(
        body: currentWidget,
        bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.transparent,
          color: Colors.red.shade900,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (index) => provider.currentIndex = index,
          items: List.generate(
            icons.length,
            (index) => Icon(
              icons[index],
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
