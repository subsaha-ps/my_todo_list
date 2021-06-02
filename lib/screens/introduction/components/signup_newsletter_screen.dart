import 'package:flutter/material.dart';
import 'package:todo_app/utilities/constant.dart';

import 'outlined_custom_button.dart';

typedef ButtonTap = void Function();

class SignUpNewsLetterScreen extends StatelessWidget {
  final ButtonTap skipButtonPressed;
  final ButtonTap joinButtonPressed;

  SignUpNewsLetterScreen(
      {required this.skipButtonPressed, required this.joinButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPageViewBackgroundColor,
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign up to the newsletter, and unlock a theme for your lists.',
            textAlign: TextAlign.center,
            style: kRichTextNormal,
          ),
          SizedBox(
            height: 25,
          ),
          Icon(
            Icons.mail_outline,
            color: Colors.black,
            size: 290,
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    labelText: 'Email Address',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedCustomButton(
                      title: 'Skip',
                      onPress: skipButtonPressed,
                    ),
                    OutlinedCustomButton(
                      title: 'Join',
                      onPress: joinButtonPressed,
                      isBoldFont: true,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
