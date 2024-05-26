import 'package:firebase_auth/firebase_auth.dart'
    show EmailAuthProvider, FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/app/data/routes/app_screens.dart';
import 'package:food_delivery_app/app/domain/model/user.dart';
import 'package:food_delivery_app/app/data/sources/database.dart';
import 'package:food_delivery_app/app/data/sources/shared_pref.dart';
import 'package:food_delivery_app/app/presentation/view/profile/widgets/action_tile.dart';
import 'package:food_delivery_app/app/presentation/common/app_text_field.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../controllers/profile_controller.dart';
import '../login_view.dart';
import 'widgets/info_tile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileController>();
    return Scaffold(
      body: FutureBuilder(
          future: provider.getUser(),
          builder: (context, builder) {
            if (builder.hasData) {
              final user = builder.data as User;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 50, left: 20, right: 20, bottom: 20),
                      margin: const EdgeInsets.only(bottom: 20),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 105),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            provider.updateImage(user, picked.path);
                            AppScreens.appRouter().refresh();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          foregroundImage: user.image!.isNotEmpty
                              ? NetworkImage(user.image!)
                              : null,
                          child: user.image == null || user.image!.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.red.shade900,
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          InfoTile(
                            title: 'Name',
                            value: user.name,
                            icon: Icons.person_outlined,
                          ),
                          const SizedBox(height: 10),
                          InfoTile(
                            title: 'Email',
                            value: user.email,
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 10),
                          InfoTile(
                            title: 'Phone Number',
                            value: user.phone!.isEmpty
                                ? 'Add Phone Number'
                                : user.phone!,
                            icon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: 10),
                          ActionTile(
                            title: 'Change Password',
                            icon: Icons.edit_outlined,
                            onPressed: () {
                              final formKey = GlobalKey<FormState>();
                              String email = user.email;
                              String oldPassword = '';
                              String newPassword = '';
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final user =
                                      FirebaseAuth.instance.currentUser!;
                                  return AlertDialog(
                                    title: const Text('Change Password'),
                                    content: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppTextField(
                                            hintText: 'Old Password',
                                            prefixIcon: Icons.lock_outline,
                                            obscureText: true,
                                            onChanged: (value) =>
                                                oldPassword = value,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter your old password';
                                              }
                                              if (value == newPassword) {
                                                return 'Passwords cannot be the same';
                                              }
                                              try {
                                                var authCredential =
                                                    EmailAuthProvider
                                                        .credential(
                                                            email: email,
                                                            password:
                                                                oldPassword);
                                                user.reauthenticateWithCredential(
                                                    authCredential);
                                              } catch (e) {
                                                return 'Incorrect password';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          AppTextField(
                                            hintText: 'New Password',
                                            prefixIcon: Icons.lock_outline,
                                            obscureText: true,
                                            onChanged: (value) =>
                                                newPassword = value,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter a password';
                                              }
                                              if (value == oldPassword) {
                                                return 'Passwords cannot be the same';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            try {
                                              user.updatePassword(newPassword);
                                              Fluttertoast.showToast(
                                                msg: 'Password changed',
                                                backgroundColor:
                                                    Colors.red.shade900,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                msg: e.toString(),
                                                backgroundColor:
                                                    Colors.red.shade900,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } finally {
                                              Navigator.of(context).pop();
                                            }
                                          }
                                        },
                                        child: const Text('Change'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Card(
                            child: ListTile(
                              title: Text(
                                'Terms and Conditions',
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                              leading: const Icon(Icons.description_outlined),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            color: Colors.red,
                            child: ListTile(
                              title: Text(
                                'Delete Account',
                                style:
                                    AppWidget.semiBoldTextFieldStyle().copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                String password = '';
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: TextFormField(
                                        onChanged: (value) => password = value,
                                        decoration: const InputDecoration(
                                          labelText: 'Password',
                                        ),
                                        obscureText: true,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await Database().deleteAccount(
                                                user.id, password);
                                            await SharedPref.clearUser();
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login(),
                                              ),
                                              (route) => false,
                                            );
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            color: Colors.red,
                            child: ListTile(
                              title: Text(
                                'Log Out',
                                style:
                                    AppWidget.semiBoldTextFieldStyle().copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                await SharedPref.clearUser();
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
