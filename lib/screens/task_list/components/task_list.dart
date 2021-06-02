import 'package:flutter/material.dart';
import 'package:todo_app/db/database_helper.dart';
import 'package:todo_app/utilities/constant.dart';
import 'package:todo_app/utilities/utility.dart';
import 'task_tile.dart';
import 'package:todo_app/models/task_model.dart';

class TasksList extends StatefulWidget {
  final List<Task> taskList;
  final Function(Task) deleteTaskHandler;
  final Function(Task) completedTaskHandler;
  TasksList(
      {required this.taskList,
      required this.deleteTaskHandler,
      required this.completedTaskHandler});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      physics: BouncingScrollPhysics(),
      onReorder: onReorder,
      children: widget.taskList
          .asMap()
          .map(
            (index, item) => MapEntry(index, _buildTasksListTile(item, index)),
          )
          .values
          .toList(),
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      Task task = widget.taskList[oldIndex];
      widget.taskList.removeAt(oldIndex);
      if (newIndex == 0) {
        task.isCompleted = widget.taskList[0].isCompleted;
      } else if (!task.isCompleted &&
          widget.taskList[newIndex - 1].isCompleted) {
        task.isCompleted = true;
      } else if (task.isCompleted && !widget.taskList[newIndex].isCompleted) {
        task.isCompleted = false;
      }
      widget.taskList.insert(newIndex, task);
      updateDatabase();
    });
  }

  void updateDatabase() {
    DatabaseHelper.instance.deleteTable();
    for (Task task in widget.taskList) {
      DatabaseHelper.instance.insertTask(task);
    }
  }

  Widget _buildTasksListTile(Task item, int index) {
    ColorTween color =
        ColorTween(begin: kListBeginTileColor, end: kListEndTileColor);
    int listLen = widget.taskList.length;

    return Dismissible(
      key: Key(item.taskId),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          //delete task
          widget.deleteTaskHandler(item);
        } else {
          widget.completedTaskHandler(item);
        }
      },
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      child: TaskTile(
        taskTitle: item.taskName,
        taskSubTitle: item.taskDateTime != null
            ? Utility.getFormattedDateString(item.taskDateTime)
            : '',
        isCompleted: item.isCompleted,
        taskId: item.taskId,
        color: (index > 0)
            ? color.lerp(index / (listLen - 1))!
            : Colors.deepOrange,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      // color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.done,
              color: Colors.white,
              size: 35,
            ),
            Text(
              " Done",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
