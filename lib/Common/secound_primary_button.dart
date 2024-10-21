import 'package:flutter/material.dart';

class secoundButton extends StatefulWidget {
  final String text;
  final Gradient gradient;
  final Future<void> Function() onPressed;

  secoundButton({
    required this.text,
    required this.gradient,
    required this.onPressed,
  });

  @override
  State<secoundButton> createState() => _secoundButtonState();
}

class _secoundButtonState extends State<secoundButton> {
  bool isLoading = false;

  Future<void> _handlePress() async {
    setState(() {
      isLoading = true;
    });

    try {
      await widget.onPressed();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handlePress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          minimumSize: Size(220, 50),
        ),
        child: isLoading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                widget.text,
                style: TextStyle(
                    color: Color.fromARGB(232, 255, 255, 255), fontSize: 17),
              ),
      ),
    );
  }
}