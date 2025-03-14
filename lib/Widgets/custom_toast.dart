import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void success(
    String msg, {
    Color bgColor = Colors.green,
    Color textColor = Colors.white,
    int duration = 1,
    double fontSize = 16,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void error(
    String msg, {
    Color bgColor = Colors.red,
    Color textColor = Colors.white,
    int duration = 2,
    double fontSize = 16,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
