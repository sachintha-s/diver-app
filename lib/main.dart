import 'package:driver_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'screens/user_profile/user_profile_screen.dart';
import 'services/auth/auth.dart';
import 'services/auth/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WeZent',
        theme: ThemeData(
          canvasColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Hexcolor('#3FC060'),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
