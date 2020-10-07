import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/services/auth/auth.dart';
import 'package:driver_app/services/auth/auth_provider.dart';
import 'package:driver_app/services/database/database.dart';
import 'package:driver_app/shared/circular_indicator.dart';
import 'package:driver_app/shared/textfield_model.dart';
import "package:flutter/material.dart";

import '../home.dart';

class RegisterPage extends StatefulWidget {
  final String mobile;

  const RegisterPage({
    Key key,
    this.mobile,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //create global key to the form that gets user details as inputs
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userFirstName;
  String userLastName;
  String userAddressLine1;
  String userAddressLine2;
  String userAddressLine3;
  String userEmail;

  bool loading = false;
  var downloadUrl;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool onSubmit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (context) => Stack(
                  children: <Widget>[
                    registerPage(
                        _formKey,
                        userFirstName,
                        userLastName,
                        userAddressLine1,
                        userAddressLine2,
                        userAddressLine3,
                        userEmail,
                        onSubmit,
                        context),
                    if (loading) Indicator(),
                  ],
                )));
  }

  Widget registerPage(
      GlobalKey _formKey,
      String userFirstName,
      String userLastName,
      String userAddressLine1,
      String userAddressLine2,
      String userAddressLine3,
      String userEmail,
      bool Function() onSubmit,
      BuildContext context) {
    Auth auth = AuthProvider.of(context).auth;

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Create profile",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldModel(
                        onSavedFunction: (value) => userFirstName = value,
                        hintText: "First name",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldModel(
                        onSavedFunction: (value) => userFirstName = value,
                        hintText: "Last name",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldModel(
                        onSavedFunction: (value) => userFirstName = value,
                        hintText: "Address line 1",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldModel(
                        onSavedFunction: (value) => userFirstName = value,
                        hintText: "Address line 3",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldModel(
                        onSavedFunction: (value) => userFirstName = value,
                        hintText: "Address line 3",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldModel(
                        onSavedFunction: (value) => userFirstName = value,
                        hintText: "E-mail",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          "By continuing, I confirm that I have read & agree to the ",
                      style: TextStyle(
                          fontSize: 13, color: Colors.black.withOpacity(0.6)),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Terms & conditions",
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        TextSpan(
                          text: " and ",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                        TextSpan(
                          text: "Privacy policy",
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        )
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "CONTINUE",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 2),
                    ),
                    onPressed: () async {
                      if (onSubmit()) {
                        setState(() {
                          loading = true;
                        });

                        try {
                          final String mobile = await auth
                              .currentUser()
                              .then((value) => value.phoneNumber);
                          final String uId = await auth
                              .currentUser()
                              .then((value) => value.uid);

                          await Database(uid: uId).setUserData(
                              userFirstName,
                              userLastName,
                              userAddressLine1,
                              userAddressLine2,
                              userAddressLine3,
                              userEmail,
                              mobile);

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            //return ProfilePage(uid: uId);
                            return HomePage();
                          }));
                        } catch (e) {
                          print(e);
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                    color: Colors.greenAccent[400],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
