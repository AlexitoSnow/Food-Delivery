import 'package:food_delivery_app/app/domain/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String userId = 'userId';
  static String userName = 'userName';
  static String userEmail = 'userEmail';
  static String userWallet = 'userWallet';
  static String userImage = 'userImage';
  static String userPhone = 'userPhone';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userId, user.id);
    prefs.setString(userName, user.name);
    prefs.setString(userEmail, user.email);
    prefs.setDouble(userWallet, user.wallet);
    prefs.setString(userImage, user.image ?? '');
    prefs.setString(userPhone, user.phone ?? '');
  }

  static Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(userId) ?? '';
    final name = prefs.getString(userName) ?? '';
    final email = prefs.getString(userEmail) ?? '';
    final wallet = prefs.getDouble(userWallet) ?? 0;
    final image = prefs.getString(userImage);
    final phone = prefs.getString(userPhone);

    return User(
      id: id,
      name: name,
      email: email,
      wallet: wallet,
      image: image,
      phone: phone,
    );
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userId);
    prefs.remove(userName);
    prefs.remove(userEmail);
    prefs.remove(userWallet);
    prefs.remove(userImage);
    prefs.remove(userPhone);
  }
}
