import 'package:driver_app/services/auth/auth.dart';
import 'package:flutter/material.dart';

//implementing auth provider class and extetend wih inherited widget
class AuthProvider extends InheritedWidget {
  AuthProvider({this.auth, Key key, Widget child})
      : super(key: key, child: child);

  final Auth auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static AuthProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType(aspect: AuthProvider));
  }
}
