// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZssm_5L8-cX8ZRBA9RoWJk1MmzkMQynY',
    appId: '1:603581841205:android:66a2a81ded2247fec2d67c',
    messagingSenderId: '603581841205',
    projectId: 'food-delivery-app-a4844',
    storageBucket: 'food-delivery-app-a4844.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDD-hfJGYCR_bY8-7iVY2FTIlC9kkJiSb8',
    appId: '1:603581841205:ios:b0a605ce26483efcc2d67c',
    messagingSenderId: '603581841205',
    projectId: 'food-delivery-app-a4844',
    storageBucket: 'food-delivery-app-a4844.appspot.com',
    iosBundleId: 'com.snow.app.foodDeliveryApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAdSWYsKtY5V5unl5V4w0cfmznyLzQwv1I',
    appId: '1:603581841205:web:a06a30f7d8040366c2d67c',
    messagingSenderId: '603581841205',
    projectId: 'food-delivery-app-a4844',
    authDomain: 'food-delivery-app-a4844.firebaseapp.com',
    storageBucket: 'food-delivery-app-a4844.appspot.com',
    measurementId: 'G-NKD3FVEBEV',
  );

}