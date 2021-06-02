import 'package:flutter/material.dart';
import 'package:todo_app/db/database_helper.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/notification/notification_helper.dart';
import 'package:todo_app/utilities/utility.dart';
import 'package:todo_app/screens/task_list/components/task_list.dart';
import 'package:todo_app/utilities/constant.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class TasksScreen extends StatefulWidget {
  static String routeName = '/task_list';

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> taskList = [];
  int count = 0;

  late TextEditingController _txtController;
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  String _txtReminderDateTime = '';

  @override
  initState() {
    super.initState();
    _txtController = TextEditingController();

    notificationHelper
        .setListenerForLowerVersions(onNotificationInLowerVersion);
    notificationHelper.setOnNotificationClick(onNotificationClick);
  }

  @override
  void dispose() {
    _txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size contextSize = MediaQuery.of(context).size;
    if (taskList.length == 0) {
      updateListView();
    }
    return Scaffold(
      backgroundColor: kThemeBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.red,
              width: contextSize.width,
              height: 100.0,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20, top: 25),
                            child: TextField(
                              controller: _txtController,
                              cursorColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration.collapsed(
                                hintText: "",
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextButton(
                              style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                              ),
                              onPressed: () {
                                Platform.isIOS
                                    ? _showDatePickerIOS(context)
                                    : _showDatePickerAndroid(context);
                              },
                              child: Text(
                                _txtReminderDateTime.isEmpty
                                    ? 'Add Reminder'
                                    : _txtReminderDateTime,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                        )
                      ],
                    ),
                  ),
                  //Add task action button
                  TextButton(
                    onPressed: () async {
                      if (count < kTotalTaskCount) {
                        if (_txtController.text.length > 0) {
                          //add task into database and reload listview
                          Task task = Task(
                              taskId: Uuid().v1(),
                              taskName: _txtController.text,
                              taskDateTime: _selectedDate);
                          int i =
                              await DatabaseHelper.instance.insertTask(task);
                          // print('the inserted ID $i');
                          if (_selectedDate != null) {
                            await notificationHelper.scheduleNotification(
                                timeOffset: _selectedDate!
                                    .difference(DateTime.now())
                                    .inSeconds,
                                title: "ToDo App",
                                body: _txtController.text);
                          }
                        }
                        updateListView();
                        _txtController.text = '';
                        _txtReminderDateTime = '';
                        _selectedDate = null;
                      } else {
                        //
                        showAlertDialogWithOkButton(
                            context: context,
                            alertMsg:
                                'Max limit reached, please delete task to add more.',
                            onPress: () {
                              Navigator.of(context).pop();
                            });
                      }

                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(
                      Icons.done,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: kThemeBackgroundColor,
                child: taskList.length > 0
                    ? TasksList(
                        //show task list
                        taskList: taskList,
                        completedTaskHandler: (Task task) => completeTask(task),
                        deleteTaskHandler: (Task task) => deleteTask(task),
                      )
                    : Center(
                        //show for no item in list
                        child: Text(
                          'No items',
                          style: TextStyle(color: Colors.red, fontSize: 30),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showAlertDialogWithOkButton(
      {required BuildContext context,
      String? alertTitle,
      String? alertMsg,
      required VoidCallback onPress}) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: onPress,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        alertTitle ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      content: Text(
        alertMsg ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updateListView() {
    Future<List<Task>> taskListFuture = DatabaseHelper.instance.getTaskList();
    taskListFuture.then((taskList) {
      setState(() {
        this.taskList = taskList;
        this.count = taskList.length;
      });
    });
  }

  void deleteTask(Task item) {
    // Remove the item from the database.
    DatabaseHelper.instance.deleteTask(item.dbId!);
    updateListView();

    // Then show a snackbar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.taskName} deleted'),
      ),
    );
  }

  void completeTask(Task item) {
    DatabaseHelper.instance.deleteTask(item.dbId!);

    Task task = Task(
        taskId: Uuid().v1(),
        taskName: item.taskName,
        isCompleted: true,
        taskDateTime: item.taskDateTime);
    DatabaseHelper.instance.insertTask(task);
    updateListView();
  }

  void _showDatePickerAndroid(BuildContext context) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: _currentDate,
      lastDate: DateTime(_currentDate.year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _txtReminderDateTime = Utility.getFormattedDateString(_selectedDate);
      });
    }
  }

  void _showDatePickerIOS(BuildContext context) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 320,
        color: Colors.white,
        child: Column(
          children: [
            Container(
                height: 50,
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  child: Text('Done'),
                  onPressed: () {
                    setState(() {
                      _txtReminderDateTime =
                          Utility.getFormattedDateString(_selectedDate);
                    });
                    Navigator.of(context).pop();
                  },
                )),
            Container(
              height: 270,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _currentDate,
                  minimumDate: _currentDate,
                  onDateTimeChanged: (date) {
                    _selectedDate = date;
                    setState(() {
                      _txtReminderDateTime =
                          Utility.getFormattedDateString(_selectedDate);
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void onNotificationInLowerVersion(
      ReceivedNotification receivedNotification) {}
  void onNotificationClick(String payload) {}
}
