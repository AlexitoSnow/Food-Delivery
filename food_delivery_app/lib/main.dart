import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_delivery_app/app/data/routes/app_screens.dart';
import 'package:provider/provider.dart';
import 'app/presentation/controllers/controllers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Provider.debugCheckInvalidValueType = null;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SignUpController>(create: (_) => SignUpController()),
        Provider<LoginController>(create: (_) => LoginController()),
        Provider<HomeController>(create: (_) => HomeController()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppScreens.appRouter(),
      ),
    );
  }
}
