import 'package:flutter/material.dart';
import 'package:todo_app/utilities/constant.dart';

class SliderView extends StatelessWidget {
  final Widget textWidget;
  final String imagePath;

  SliderView({required this.textWidget, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageViewBackgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 5,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 50),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: textWidget,
                  ),
                )),
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Image.asset(imagePath),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Clear sorts items by',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' priority',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                    SizedBox(height: 20.0),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Important items are highlighted at the top...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ]),
                    ),
* */
