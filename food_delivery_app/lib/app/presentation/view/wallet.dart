import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/data/sources/database.dart';
import 'package:food_delivery_app/app/data/sources/shared_pref.dart';
import 'package:food_delivery_app/app/presentation/common/app_elevated_button.dart';
import 'package:food_delivery_app/app/presentation/common/app_text_field.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final amounts = [5, 10, 20, 30, 50, 100];
  double walletAmount = 0.0;

  @override
  void initState() {
    super.initState();
    getUserWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: AppWidget.headlineTextFieldStyle(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.wallet_outlined),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(children: [
                    Text(
                      'Your Wallet',
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    Text(
                      '\$ $walletAmount',
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Text(
            'Add Money',
            style: AppWidget.semiBoldTextFieldStyle(),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(amounts.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: OutlinedButton(
                    child: Text(
                      amounts[index].toString(),
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                    onPressed: () async {
                      await addToWallet(amounts[index].toDouble());
                    },
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            child: SizedBox(
              width: double.infinity,
              child: AppElevatedButton(
                'Add money',
                onPressed: customAmountDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUserWallet() async {
    final user = await SharedPref.getUser();
    setState(() {
      walletAmount = user.wallet;
    });
  }

  addToWallet(double amount) async {
    final user = await SharedPref.getUser();
    final newAmount = walletAmount + amount;
    user.wallet = newAmount;
    await SharedPref.saveUser(user);
    await Database().updateUserInfo(user.id, user.toJson());
    await getUserWallet();
  }

  Future customAmountDialog() async {
    final TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter amount'),
          content: AppTextField(
            controller: controller,
            keyboardType: TextInputType.number,
            hintText: 'Custom Amount',
            prefixIcon: Icons.money,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final amount = double.parse(controller.text);
                await addToWallet(amount);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
