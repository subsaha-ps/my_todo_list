import 'package:flutter/material.dart';

typedef ButtonTap = void Function();

class OutlinedCustomButton extends StatelessWidget {
  const OutlinedCustomButton(
      {required this.title, required this.onPress, this.isBoldFont = false});

  final String title;
  final ButtonTap onPress;
  final bool isBoldFont;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.0,
      height: 50.0,
      child: OutlinedButton(
        onPressed: onPress,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: BorderSide(width: 1.5, color: Colors.black),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: isBoldFont ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
