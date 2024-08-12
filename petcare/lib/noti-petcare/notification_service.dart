import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('@drawable/logo');

  void initialiseNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(String title, DateTime? appointmentDate) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      appointmentDate!.year,
      appointmentDate.month,
      appointmentDate.day - 1,
      12,
      0,
    );

    // Calculate the time difference in milliseconds between now and scheduledDate
    final int timeDifference =
        scheduledDate.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

    // Schedule the notification for the day before appointmentDate
    if (timeDifference > 0) {
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        'Total Amount: \$${appointmentDate.toString()}',
        scheduledDate,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print('Scheduled Date: $scheduledDate');
      print('Time Difference: $timeDifference');
    }

    print('Scheduled Date: $scheduledDate');
    print('Time Difference: $timeDifference');
  }

  void sendNotificationFirst(String title, DateTime? appointmentDate) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      ' ${appointmentDate.toString()}',
      notificationDetails,
    );
  }

  void sendNotificationVaccine(
    String title,
    String appointmentDate,
    int notificationId, // Add an integer parameter for the notification ID
  ) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationId, // Use the provided notification ID
      title,
      ' ${appointmentDate.toString()} at Pets4life center',
      notificationDetails,
    );
  }
}
