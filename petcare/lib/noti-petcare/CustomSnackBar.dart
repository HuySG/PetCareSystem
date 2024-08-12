import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Container(
        height: 40.0, // Adjust the height as needed
        alignment: Alignment.center,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFBD58),
            fontSize: 16.0,
          ),
        ),
      ),
      backgroundColor: Color(0xFFB12A1C), // Customize the background color
      duration: Duration(seconds: 1), // Adjust the duration as needed
      behavior:
          SnackBarBehavior.floating, // Makes the SnackBar float in the center
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
