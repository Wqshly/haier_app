import 'package:flutter/material.dart';

class Util {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger .of(context).showSnackBar(
      SnackBar(content: Text("$msg")),
    );
  }
}