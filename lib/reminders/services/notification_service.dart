import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<bool?> hasPermission() async {
    bool? ret = false;

    AndroidFlutterLocalNotificationsPlugin?
        androidFlutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidFlutterLocalNotificationsPlugin != null) {
      ret = await androidFlutterLocalNotificationsPlugin
          .areNotificationsEnabled();
    }

    return ret;
  }

  Future requestPermission() async {
    AndroidFlutterLocalNotificationsPlugin?
        androidFlutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidFlutterLocalNotificationsPlugin != null) {
      await androidFlutterLocalNotificationsPlugin
          .requestNotificationsPermission();
    }
  }

  Future<void> initNotification() async {
    AndroidFlutterLocalNotificationsPlugin?
        androidFlutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidFlutterLocalNotificationsPlugin != null) {
      androidFlutterLocalNotificationsPlugin.requestNotificationsPermission();
    }

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_notify_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  NotificationDetails? notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'reminderNotificationId', 'Reminders',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails());

    return;
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();

    return;
  }
}
