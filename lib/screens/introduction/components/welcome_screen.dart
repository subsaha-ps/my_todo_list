import 'package:flutter/material.dart';
import 'package:todo_app/screens/introduction/components/rich_text_widget.dart';
import 'package:todo_app/utilities/constant.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onTapHandler;

  WelcomeScreen({required this.onTapHandler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageViewBackgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTapHandler(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichTextWidget(
                text: 'Welcome to',
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.normal),
                textSpanList: [
                  {
                    'text': ' Clear\n\n',
                    'style': TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold)
                  },
                  {
                    'text': 'Tap or swipe',
                    'style': TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)
                  },
                  {
                    'text': ' to begin',
                    'style': TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.normal)
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
onPanUpdate: (details) {
          if (details.delta.dy > 0) {
            // swiping in right direction
            navigateToOnBoardingScreen(context);
          }
        },
* */
