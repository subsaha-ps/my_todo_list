import 'package:flutter/material.dart';
import 'package:todo_app/utilities/constant.dart';
import 'dart:math';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.taskId,
    required this.taskTitle,
    required this.taskSubTitle,
    required this.isCompleted,
    required this.color,
  });

  final String taskId;
  final String taskTitle;
  final String taskSubTitle;
  final bool isCompleted;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCompleted ? Colors.green : color,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      borderOnForeground: true,
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Center(
        child: ListTile(
          key: ValueKey(taskId),
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              taskTitle,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  decoration: isCompleted ? TextDecoration.lineThrough : null),
            ),
          ),
          subtitle: taskSubTitle.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: Text(
                    taskSubTitle,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null),
                  ),
                ),
        ),
      ),
    );
  }
}
