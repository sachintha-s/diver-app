import 'package:driver_app/screens/home%20page/home_page.dart';
import 'package:driver_app/services/auth/auth.dart';
import 'package:driver_app/services/auth/auth_provider.dart';
import 'package:driver_app/screens/phone%20authentication/sign_in_page.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = AuthProvider.of(context).auth;

    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool isLoggedin = snapshot.hasData;
            return isLoggedin ? DriverHomePage() : AuthScreeen();
          }
          return CircularProgressIndicator();
        });
  }
}
