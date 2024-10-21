import 'package:flutter/material.dart';

class removeaction extends StatefulWidget {
  final String text;
  final Gradient gradient;
  final void Function()? onPressed;

  removeaction({
    required this.text,
    required this.gradient,
    this.onPressed,
  });

  @override
  State<removeaction> createState() => _DoubleButtonState();
}

class _DoubleButtonState extends State<removeaction> {
  bool isLoading = false;

  void _handlePress() {
    if (widget.onPressed != null) {
      setState(() {
        isLoading = true;
      });

      widget.onPressed!();

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
          minimumSize: Size(150, 50),
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
