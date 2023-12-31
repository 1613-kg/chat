import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2)));
