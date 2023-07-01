import 'package:flutter/material.dart';

class InputInfo extends StatelessWidget {
  final TextEditingController controller;
  bool toHide;
  String labelText;
  IconData myIcon;

  InputInfo({
    Key? key,
    required this.controller,
    required this.myIcon,
    required this.labelText,
    this.toHide = false,
  }) : super(key: key);

  _passwordValidate(String val) {
    if (val.length < 6) {
      return "Password must be at least 6 characters";
    } else {
      return null;
    }
  }

  _emailValidate(String val) {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val)
        ? null
        : "Please enter a valid email";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        (labelText == "Password")
            ? _passwordValidate(val!)
            : _emailValidate(val!);
      },
      obscureText: toHide,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        icon: Icon(
          myIcon,
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.grey,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.grey,
            )),
      ),
    );
  }
}
