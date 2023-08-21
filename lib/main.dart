import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocalStrings.dart';
import 'package:odlay_services/AppFiles/Utility/_configure_app_variables.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/Utility/notification.dart';
import 'package:odlay_services/AppFiles/Utility/sharedprefrences_keys.dart';
import 'package:odlay_services/AppFiles/screens/pages/AuthPages/enter_phone.dart';

import 'package:odlay_services/AppFiles/screens/pages/SelectionPages/selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:get/get.dart';

import 'AppFiles/Utility/AppConstants.dart';
import 'AppFiles/screens/pages/CombinedPages/conversion_header_cover.dart';
import 'AppFiles/screens/pages/CustomerPages/CustomerPersistanceNavbar/CustomerLandingPage.dart';
import 'AppFiles/screens/pages/ServiceProviderPages/ServiceProviderDrawer/_service_provider_landing_page.dart';



@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.data}');

  String noti_title = message.data["n_title"];
  String noti_message = message.data["n_message"];
  String noti_type = message.data["n_type"];

  // final AppController _appController = Get.put(AppController());
  // _appController.logEvent(QueryLogEvent(
  //     userId: "42996",
  //     eventName: "backroud language",
  //     activityId: 0
  // ),"cmRwa1RRaWxvNnJTeno3ZG12RkJwQk5WVXBPa0ttQmt4VjVVdVdPOQ==");
  sendNotification(title: noti_title, body: noti_message, type: noti_type);

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Constants.sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  // Stripe.publishableKey =
  //     "pk_test_51I0nZcLLGhC7gu4SvTWxHgsRpA8uxd4jBOSt4ZS9fLg5eP1lm1nWaDetrnz6PHp2h81WGReJWE0B7vOjh7W1SUtU00Qus8XIHA";
  int? appRegion =
      Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
  print("SavedRegion${appRegion}");
  if (appRegion != null) {
    ConfigureAppVariable.configureUrls(appRegion);
  } else {
    ConfigureAppVariable.configureUrls(1);
  }
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
if (mapsImplementation is GoogleMapsFlutterAndroid) {
  mapsImplementation.useAndroidViewSurface = false;
}
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//on notfication tap background
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String? data="123";
  if(details!.didNotificationLaunchApp){
    String? payLoad=details.notificationResponse?.payload;
    data=payLoad;
    if(data==FireBaseConstants.typeApplyJob||
        data==FireBaseConstants.typeChat){
      AppConstants.isSlectedUserCustomer =
      true;
    }
    else {
      AppConstants.isSlectedUserCustomer =
      false;
    }
  print("LunchFromNotfication");

  }
  else
  {
    print("LunchFromNormal");
    // String? payLoad=details.notificationResponse?.payload;
    data="Normal";
    

    // didNotificationLaunchApp
  }
  runApp(GetMaterialApp(
    textDirection: TextDirection.ltr,
    translations: LocalString(),
    locale: Locale("en"),
    title: "Odlay Services",
    home: Constants.sharedPreferences
                .getBool(SharedPrefrencesKeys.userLoggedIn) == true?
    details!.didNotificationLaunchApp == true
        ?
    data==FireBaseConstants.typeChat?
    CustomerLandingPage(3):
    data==FireBaseConstants.typeApplyJob||data==FireBaseConstants.applyJobAccepted?
    CustomerLandingPage(2):
    data==FireBaseConstants.typeNewJob?
    ServiceProviderLandingPage(0):
    ServiceProviderLandingPage(2):

    selection_page()
        : EnterPhone(),
  ));
}
