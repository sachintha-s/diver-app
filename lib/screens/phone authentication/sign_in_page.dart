import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver_app/screens/user_profile/user_profile_screen.dart';
import 'package:driver_app/services/auth/auth.dart';
import 'package:driver_app/services/auth/auth_provider.dart';
import 'package:driver_app/shared/circular_indicator.dart';
import 'package:flutter/material.dart';

class AuthScreeen extends StatefulWidget {
  @override
  _AuthScreeenState createState() => _AuthScreeenState();
}

class _AuthScreeenState extends State<AuthScreeen> {
  String countryCode;
  bool loading = false;

  //this will be the value that user inputs
  String phoneNumberSuffix;

  //this is the true phone number with the country code and the user entered number.
  String phoneNumber;

  //create global key
  GlobalKey<FormState> _formKey = GlobalKey();

  //this method wil triggured when the form is saved.Then validate the input and return a bool value.
  bool onSaved() {
    //save the form
    _formKey.currentState.save();

    if (_formKey.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }

  //dialog box  to confirm the entered phone number
  crateAlertDialog(BuildContext context, Size deviceSize, Auth auth) {
    //content of the alert dialog
    Widget _content() {
      return Container(
        height: deviceSize.height * 0.18,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                //used RichText to customize text style
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Verification code will be sent to ",
                      style: TextStyle(
                          fontSize: deviceSize.height * 0.023,
                          color: Colors.black.withOpacity(0.6)),
                      children: <TextSpan>[
                        TextSpan(
                          text: "$countryCode $phoneNumberSuffix",
                          style: TextStyle(
                              fontSize: deviceSize.height * 0.023,
                              color: Colors.black),
                        )
                      ]),
                )),
            SizedBox(
              height: deviceSize.height * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                //'EDIT' button will pop the dialog box
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "EDIT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceSize.height * 0.023,
                        color: Colors.greenAccent[400],
                        letterSpacing: 2),
                  ),
                  color: Colors.white,
                ),
                SizedBox(
                  width: deviceSize.height * 0.03,
                ),

                //'SEND OTP' button will send otp cod to given phone number
                FlatButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        loading = true;
                      });

                      print(phoneNumber);

                      //callback method in auth class to register user
                      await auth.registerUser(phoneNumber, context);

                      setState(() {
                        loading = false;
                      });
                    } catch (e) {
                      print(e);
                      errorCode(e.message,deviceSize);
                    }
                  },
                  child: Text(
                    "SEND OTP",
                    style: TextStyle(
                        fontSize: deviceSize.height * 0.023,
                        color: Colors.greenAccent[400],
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      );
    }

    //title of the alert dialog
    Widget _title() {
      return Text(
        "Confirm ",
        style: TextStyle(
            fontSize: deviceSize.height * 0.029, color: Colors.black, fontWeight: FontWeight.bold),
      );
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: _title(), content: _content());
        });
  }

  void errorCode(e,Size deviceSize) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        titleTextStyle: TextStyle(
            fontFamily: 'GANTICS',
            fontSize: deviceSize.height * 0.025,
            letterSpacing: 2,
            color: Colors.green),
        titlePadding: EdgeInsets.only(left: 70, top: 30),
        title: Text("Error!"),
        content: Container(
          height: deviceSize.height * 0.4,
          child: Column(
            children: <Widget>[
              Text(e.toString()),
              SizedBox(
                height: deviceSize.height * 0.1,
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

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    Auth auth = AuthProvider.of(context).auth;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
        body: Builder(
      builder: (context) => Stack(
        children: <Widget>[
          signUpWidget(auth, _deviceSize),
          if (loading) Indicator()
        ],
      ),
    ));
  }

  Widget signUpWidget(auth, deviceSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Enter Mobile Number",
              style: TextStyle(
                  fontSize: deviceSize.height * 0.04,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //add countrycodepicker to get the postal code of the phone number
                Container(
                  child: CountryCodePicker(
                    initialSelection: "+94",
                   // dialogSize: Size(50, 200),
                    onInit: (value) {
                      //countryCode set to initial value
                      countryCode = value.dialCode;
                    },
                    onChanged: (value) {
                      countryCode = value.dialCode;
                    },
                  ),
                ),
                SizedBox(width: 5),
                //add textfild for enter phone number,
                Container(
                  width: deviceSize.width*0.6,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Mobile Number Can't be Empty";
                        } else if (value.length != 9) {
                          return "Mobile Number is Invalid";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        phoneNumberSuffix = value;
                      },
                      decoration: InputDecoration(
                        //border: InputBorder.none,
                        hintText: 'Enter Your Mobile number',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: deviceSize.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: RichText(
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
                          fontSize: 13, color: Colors.black.withOpacity(0.6)),
                    ),
                    TextSpan(
                      text: "Privacy policy",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    )
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "CONTINUE",
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  if (onSaved()) {
                    phoneNumber = "$countryCode$phoneNumberSuffix";
                    crateAlertDialog(context, deviceSize, auth);
                  }
                  print("$phoneNumber");
                },
                color: Colors.greenAccent[400],
              ),
            ),
          ),
          RaisedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
          },)
        ],
      ),
    );
  }
}
