class Task {
  int? dbId;
  final String taskName;
  final String taskId;
  bool isCompleted;
  DateTime? taskDateTime;

  Task({
    required this.taskName,
    required this.taskId,
    this.isCompleted = false,
    this.taskDateTime,
    this.dbId,
  });

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (dbId != null) {
      map['id'] = dbId;
    }
    map['task_id'] = taskId;
    map['name'] = taskName;
    map['status'] = isCompleted ? 'true' : 'false';
    map['date'] =
        taskDateTime != null ? taskDateTime!.millisecondsSinceEpoch : 0;

    return map;
  }

  // Extract a Note object from a Map object
  static Task fromMapObject(Map<String, dynamic> map) {
    int id = map['id'];
    String taskId = map['task_id'];
    String name = map['name'];
    bool status = map['status'] == 'true';
    int date = map['date'];
    DateTime? dateTime =
        date > 0 ? DateTime.fromMillisecondsSinceEpoch(date) : null;

    return Task(
      dbId: id,
      taskId: taskId,
      taskName: name,
      isCompleted: status,
      taskDateTime: dateTime,
    );
  }
}
