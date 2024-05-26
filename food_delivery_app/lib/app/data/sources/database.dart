import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show EmailAuthProvider, FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_delivery_app/app/domain/model/user.dart';

class Database {
  Future registerUser(Map<String, dynamic> user) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user['id'])
        .set(user);
  }

  Future<User> getUser(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    final user = result.docs.first.data();
    return User.fromJson(user);
  }

  Future updateUserInfo(String id, Map<String, dynamic> user) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(user);
  }

  Future addFoodItem(
      String categoryCollection, Map<String, dynamic> foodItem) async {
    return await FirebaseFirestore.instance
        .collection(categoryCollection)
        .add(foodItem);
  }

  Future<Stream<QuerySnapshot>> getFoodItems(String category) async {
    return FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<QuerySnapshot> getCartItems(String userId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
  }

  Future addToCart(String userId, Map<String, dynamic> cartItem) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .add(cartItem);
  }

  Future<String> updateUserProfile(String userId, File image) async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("profiles")
        .child('$userId.${image.path.split('.').last}');
    final UploadTask task = firebaseStorageRef.putFile(image);

    return (await task).ref.getDownloadURL();
  }

  Future deleteAccount(String userId, String password) async {
    var user = FirebaseAuth.instance.currentUser;
    var authCredential =
        EmailAuthProvider.credential(email: user!.email!, password: password);
    await user.reauthenticateWithCredential(authCredential);
    await user.delete();
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profiles').child('$userId.jpg');
    await firebaseStorageRef.delete();
    await cleanCart(userId);
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  Future<void> cleanCart(String userId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.collection('cart').get().then((snapshot) {
      for (DocumentSnapshot cartItem in snapshot.docs) {
        cartItem.reference.delete();
      }
    });
  }

  Future<void> removeFromCart(String userId, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .where('name', isEqualTo: name)
        .get()
        .then(
      (snapshot) {
        snapshot.docs.first.reference.delete();
      },
    );
  }
}
