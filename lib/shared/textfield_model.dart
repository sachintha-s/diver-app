import 'package:flutter/material.dart';

class TextFieldModel extends StatelessWidget {
  final Function onSavedFunction;
  final String hintText;

  const TextFieldModel({Key key, this.onSavedFunction, this.hintText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return '$hintText can\'t be empty';
        } else {
          return null;
        }
      },
      onSaved: onSavedFunction,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.greenAccent[400]
          )
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.4)
          )
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        hintStyle: TextStyle(
          fontSize: 18,
          color: Colors.black.withOpacity(0.6)
        )
      ),
    );
  }
}
