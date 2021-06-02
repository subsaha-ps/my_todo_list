import 'package:flutter/widgets.dart';
import 'package:todo_app/screens/introduction/introduction_screen.dart';
import 'package:todo_app/screens/task_list/tasks_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  IntroductionScreen.routeName: (context) => IntroductionScreen(),
  TasksScreen.routeName: (context) => TasksScreen(),
};
