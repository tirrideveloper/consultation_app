import 'dart:io';
import 'dart:math';

import 'package:consultation_app/notification/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotifications {
  FirebaseMessaging _messaging;
  BuildContext myContext;

  void setupFirebase(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    NotificationSettings setting = await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    print("SETTING ${setting.authorizationStatus}");
    _messaging.getToken().then((token) => print("MY TOKEN: $token"));

    _messaging
        .subscribeToTopic("demo")
        .whenComplete(() => print("SUCCESSFULLY"));

    FirebaseMessaging.onMessage.listen(
      (remoteMessage) {
        print("$remoteMessage");
        if (Platform.isAndroid)
          showNotification(
              remoteMessage.data["title"], remoteMessage.data["body"]);
        else if (Platform.isIOS)
          showNotification(remoteMessage.notification.title,
              remoteMessage.notification.body);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (remoteMessage) {
        print("open app: $remoteMessage");
        if (Platform.isIOS)
          showDialog(
            context: myContext,
            builder: (context) => CupertinoAlertDialog(
              title: Text(remoteMessage.notification.title),
              content: Text(remoteMessage.notification.body),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Okay"),
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                ),
              ],
            ),
          );
      },
    );
  }

  static void showNotification(String title, String body) async {
    var androidChannel = AndroidNotificationDetails(
        "com.example.consultation_app", "Mesaj Bildirimleri", "Gelen mesaj bildirimleri",
        autoCancel: false,
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high);

    var ios = IOSNotificationDetails();

    var platForm = NotificationDetails(android: androidChannel, iOS: ios);

    await NotificationHandler.flutterNotificationHandlerPlugin
        .show(Random().nextInt(1000), title, body, platForm, payload: "My Payload");
  }
}
