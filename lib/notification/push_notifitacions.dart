import 'package:bitirme_projesi/main.dart';
import 'package:bitirme_projesi/view/account_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final onClickNotification = BehaviorSubject<String>();

  late final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTapNotofication,
      onDidReceiveBackgroundNotificationResponse: onTapNotofication,
    );
  }

  static void onTapNotofication(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
    print('gelen payload: ${notificationResponse.payload}');
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => const AccountView(),
        ),
      );
    
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payLoad);
  }

 
}
