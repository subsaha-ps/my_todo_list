import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io' show File, Platform;

class NotificationHelper {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  var initializationSettings;

  NotificationHelper._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializedPlatformSpecific();
  }

  initializedPlatformSpecific() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          ReceivedNotification _receivedNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(_receivedNotification);
        });
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  _requestIOSPermission() {
    IOSFlutterLocalNotificationsPlugin? iosFlutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation();
    if (iosFlutterLocalNotificationsPlugin != null) {
      iosFlutterLocalNotificationsPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersion) {
    didReceiveLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersion(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        onNotificationClick(payload);
      },
    );
  }

  Future initializetimezone() async {
    tz.initializeTimeZones();
  }

  Future<void> showNotification() async {
    var androidChanelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChanelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChanelSpecifics, iOS: iosChanelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'test title',
      'test body',
      platformChannelSpecifics,
      payload: 'test payload',
    );
  }

  Future<void> scheduleNotification(
      {required int timeOffset,
      required String title,
      required String body}) async {
    await initializetimezone();
    var androidChanelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChanelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChanelSpecifics, iOS: iosChanelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: timeOffset)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (ex) {
      print(ex);
    }
  }
}

NotificationHelper notificationHelper = NotificationHelper._();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
