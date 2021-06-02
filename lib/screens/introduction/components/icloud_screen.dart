import 'package:flutter/material.dart';
import 'package:todo_app/screens/introduction/components/rich_text_widget.dart';
import 'package:todo_app/utilities/constant.dart';

import 'outlined_custom_button.dart';

typedef ButtonTap = void Function();

class ICloudScreen extends StatelessWidget {
  final ButtonTap notNowButtonPressed;
  final ButtonTap iCloudButtonPressed;

  ICloudScreen(
      {required this.notNowButtonPressed, required this.iCloudButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPageViewBackgroundColor,
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud,
            color: Colors.blueAccent,
            size: 200,
          ),
          SizedBox(
            height: 30,
          ),
          RichTextWidget(
            text: 'Use',
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.normal),
            textSpanList: [
              {
                'text': ' iCloud?\n',
                'style': TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold)
              }
            ],
          ),
          Text(
            'Storing your lists in iCloud allows you to keep your data in sync across your iPhone, iPad and Mac.',
            textAlign: TextAlign.center,
            style: kRichTextNormal,
          ),
          SizedBox(
            height: 55,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedCustomButton(
                title: 'Not Now',
                onPress: notNowButtonPressed,
              ),
              OutlinedCustomButton(
                title: 'Use iCloud',
                onPress: iCloudButtonPressed,
                isBoldFont: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
