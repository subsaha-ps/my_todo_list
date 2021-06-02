import 'package:flutter/material.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/screens/introduction/introduction_screen.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: IntroductionScreen.routeName,
      routes: routes,
    );
  }
}
