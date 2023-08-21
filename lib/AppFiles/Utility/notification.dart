

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/conversion_header_cover.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/CustomerPersistanceNavbar/CustomerLandingPage.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ServiceProviderDrawer/_service_provider_landing_page.dart';

import '../Controller/app_controller.dart';
import '../model/LogEvents/query_log_event.dart';
import 'AppConstants.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print("SeletedNotficatioؓBackgroudn${global_noti_type}");
  if (global_noti_type == FireBaseConstants.typeApplyJob ||
      global_noti_type==FireBaseConstants.applyJobAccepted

  ) {
    print("OpenCustomerLanding");
    AppConstants.allowCustLoad=true;
    Navigator.pushAndRemoveUntil(
      AppConstants.baseContext,
      MaterialPageRoute(
          builder: (context) =>
              CustomerLandingPage(2)),
          (Route<dynamic> route) => false,
    );
    // Get.to(CustomerLandingPage(2));
  } else if (global_noti_type == FireBaseConstants.applyJobReward||
      global_noti_type==FireBaseConstants.applyJobPayment||
      global_noti_type==FireBaseConstants.applyJobApprove) {
    print("OpenServiceLanding");
    AppConstants.allowSpLoad=true;
    Navigator.pushAndRemoveUntil(
      AppConstants.baseContext,
      MaterialPageRoute(
          builder: (context) =>
              ServiceProviderLandingPage(2)),
          (Route<dynamic> route) => false,
    );
  } else {
    print("OpenChatHeader");

    Get.to(ConversationCover());
  }

  }
@pragma('vm:entry-point')
late String? global_noti_type;

void sendNotification({String? title, String? body, String? type}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  global_noti_type = type;
  ////Set the settings for various platform
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse:
      (NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        if (type == FireBaseConstants.typeApplyJob ||
            type==FireBaseConstants.applyJobAccepted

        ) {
          print("OpenCustomerLanding");
          AppConstants.allowCustLoad=true;
          Navigator.pushAndRemoveUntil(
            AppConstants.baseContext,
            MaterialPageRoute(
                builder: (context) =>
                    CustomerLandingPage(2)),
                (Route<dynamic> route) => false,
          );
          // Get.to(CustomerLandingPage(2));
        } else if (type == FireBaseConstants.applyJobReward||
            type==FireBaseConstants.applyJobPayment||
            type==FireBaseConstants.applyJobApprove) {
          print("OpenServiceLanding");
          AppConstants.allowSpLoad=true;
          Navigator.pushAndRemoveUntil(
            AppConstants.baseContext,
            MaterialPageRoute(
                builder: (context) =>
                    ServiceProviderLandingPage(2)),
                (Route<dynamic> route) => false,
          );
        } else {
          print("OpenChatHeader");

          Get.to(ConversationCover());
        }
          break;
      case NotificationResponseType.selectedNotificationAction:

        break;
    }
  },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,);

  ///
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_channel',
    'High Importance Notification',
    description: "This channel is for important notification",
  );

  flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,

    NotificationDetails(
      android: AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          priority: Priority.high,
          importance: Importance.max),


    ),
    payload: type,
  );

}
