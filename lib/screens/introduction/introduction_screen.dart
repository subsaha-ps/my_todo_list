import 'package:flutter/material.dart';
import 'package:todo_app/screens/introduction/components/body.dart';
import 'package:todo_app/utilities/constant.dart';

class IntroductionScreen extends StatelessWidget {
  static String routeName = '/introduction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
