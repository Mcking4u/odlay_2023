import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/Utility/notification.dart';

class NotificationListenerProvider {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void getMessage(BuildContext context) {
    print(":::::::::::::::::::::::onForegroundMessageReceived:::::::::::::::::::::::::::");
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("EventOccured${event.data}");
      String noti_title = event.data["n_title"];
      String noti_message = event.data["n_message"];
      String noti_type = event.data["n_type"];
      sendNotification(title: noti_title, body: noti_message, type: noti_type);
    });


  }
}
