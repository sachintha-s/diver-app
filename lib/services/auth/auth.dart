import 'package:driver_app/screens/register%20page/register_page.dart';
import 'package:driver_app/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user;
  String smsCode;

  Future<String> registerUser(String mobile, BuildContext context) async {
    final _deviceSize = MediaQuery.of(context).size;
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          Navigator.of(context).pop();
          UserCredential authResult =
              await _firebaseAuth.signInWithCredential(authCredential);
          user = authResult.user;

          if (user != null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ));
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
          print('authException.message');
          errorCode(
              context, "Phone Number is Invalid.Enter Valid Phone Number");
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          //show dialog t take iput from user

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              titleTextStyle: TextStyle(
                  fontFamily: 'GANTICS',
                  fontSize: _deviceSize.width*0.05,
                  letterSpacing: 1,
                  color: Colors.green),
              title: Center(child: Text("Verify $mobile")),
              content: Container(
                height: _deviceSize.height*0.3,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Text(
                        "Waiting for automatically detect an SMS sent to $mobile"),
                    SizedBox(
                      height: 10,
                    ),
                    PinCodeTextField(
                      pinBoxWidth: _deviceSize.width*0.08,
                      pinBoxHeight: _deviceSize.height*0.05,
                      hasUnderline: true,
                      pinBoxOuterPadding: const EdgeInsets.all(4),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      pinBoxDecoration:
                          ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                      pinTextStyle: TextStyle(fontSize: 20),
                      onTextChanged: (value) async {
                        smsCode = value.trim();
                        if (smsCode.length == 6) {
                          try {
                            AuthCredential _credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);

                            UserCredential authResult = await _firebaseAuth
                                .signInWithCredential(_credential);
                            User user = authResult.user;
                            if (user != null) {
                              // Navigator.of(context)
                              //     .popUntil((route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(
                                      mobile: mobile,
                                    ),
                                  ));
                            }
                          } catch (e) {
                            errorCodeInvalid(context, e.message, mobile);
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter 6-digit code",
                      style: TextStyle(color: Colors.grey),
                    ),
                    
                    // RaisedButton(
                    //   child: Text("Done"),
                    //   onPressed: () async {
                    //     //final smsCode = _codeController.text.trim();
                    //     try {
                    //       AuthCredential _credential =
                    //           PhoneAuthProvider.getCredential(
                    //               verificationId: verificationId,
                    //               smsCode: smsCode);

                    //       AuthResult authResult = await _firebaseAuth
                    //           .signInWithCredential(_credential);
                    //       FirebaseUser user = authResult.user;
                    //       if (user != null) {
                    //         Navigator.pushReplacement(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => HomePage(),
                    //             ));
                    //       }
                    //     } catch (e) {
                    //       errorCodeInvalid(context, e.message, mobile);
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        });
    return user?.uid;
  }

  signout() {
    return _firebaseAuth.signOut();
  }

  Future<User> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((user) => user?.uid);
  }

  void errorCode(context, e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        titleTextStyle: TextStyle(
            fontFamily: 'GANTICS',
            fontSize: 30,
            letterSpacing: 2,
            color: Colors.green),
        titlePadding: EdgeInsets.only(left: 70, top: 30),
        title: Text("Error"),
        content: Container(
          height: 202,
          width: 500,
          child: Column(
            children: <Widget>[
              Text(e),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                child: Text("Done"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void errorCodeInvalid(context, e, mobile) {
    Auth auth = AuthProvider.of(context).auth;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        titleTextStyle: TextStyle(
            fontFamily: 'GANTICS',
            fontSize: 30,
            letterSpacing: 2,
            color: Colors.green),
        titlePadding: EdgeInsets.only(left: 70, top: 30),
        title: Text("Error"),
        content: Container(
          height: 202,
          width: 500,
          child: Column(
            children: <Widget>[
              Text(e),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                child: Text("Done"),
                onPressed: () async {
                  Navigator.pop(context);
                  await auth.registerUser(mobile, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
