import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.black), // Set the text color
          child: Text(message),
        ),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3), // Adjust the duration as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),    // Set top-left corner radius
          topRight: Radius.circular(10.0),   // Set top-right corner radius
          bottomLeft: Radius.circular(10.0), // Set bottom-left corner radius
          bottomRight: Radius.circular(10.0),// Set bottom-right corner radius
        ),
        side: BorderSide(
          color: Colors.white, // Set the border color
          width: 2.0, // Set the border width
        ),
      ),
      margin: EdgeInsets.all(10.0), // Set margin to create a gap around the SnackBar
      behavior: SnackBarBehavior.floating, // Makes the SnackBar float,
    ),
  );
}
