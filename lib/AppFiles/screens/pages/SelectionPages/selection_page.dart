import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geocoding/geocoding.dart';

// import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:geocode/geocode.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Services/remote_services.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/AutoFillAddress.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';

import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/Utility/firebase_message_provider.dart';
import 'package:odlay_services/AppFiles/Utility/privacy_policy_agreement.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/LogEvents/query_log_event.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/_query_change_language.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_change_lang.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/CustomerPersistanceNavbar/CustomerLandingPage.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ServiceProviderDrawer/_service_provider_landing_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/test_bottom_sheet.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:location/location.dart' as userCurrentLocation;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocode/geocode.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:video_player/video_player.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

import '../../../Utility/notification_services.dart';

class selection_page extends StatefulWidget {

  selection_page();
  @override
  State<selection_page> createState() => _selection_pageState();
}

class _selection_pageState extends State<selection_page> {
  AppController _appController = Get.put(AppController());
  late bool _serviceEnabled;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  userCurrentLocation.LocationData? _userLocation;
  late ResponseLoginUser responseLoginUser;
  bool wait_loaction = true;
  late VideoPlayerController _controller;
  int? appRegion;
  int? languageIntials;
  bool languageChnaged = false;
    NotificationServices notificationServices = NotificationServices();
  static final facebookAppEvents = FacebookAppEvents();
  @override
  void initState() {
    super.initState();
    NotificationListenerProvider().getMessage(context);
    facebookAppEvents.setAutoLogAppEventsEnabled(true);
    facebookAppEvents.setAdvertiserTracking(enabled: true);

    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value){
    //   if (kDebugMode) {
    //     print('device token');
    //     print(value);
    //   }
    // });
  
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);

//add
    String? stripPubKey =
    Constants.sharedPreferences.getString(SharePrefrencesValues.STRIPE_SAVED_KEY);
    if(stripPubKey!=null) {
      Stripe.publishableKey = stripPubKey.toString();
    }
    _controller = VideoPlayerController.asset("assets/video_devided_intro.mp4")
      ..initialize().then((_) {
        setState(() {});
      });
     printDeviceTokebn();
    manageUserConsentDisclouser();
    print("UserId${responseLoginUser.user.id}");
  //    for (var data_latln in data_latln) {
  //    getAddressFromLatLng(data_latln.latitude, data_latln.longitude);
  // }
    
    //getDeviceToken();

  }

  @override
  Widget build(BuildContext context) {
    RemoteServices.client = http.Client();
    String? apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    languageIntials = Constants.sharedPreferences
        .getInt(SharePrefrencesValues.LANGUAGE_INTIALS);
    _runsAfterBuild();
    //showToast(widget.payLoad,context: context,backgroundColor: Colors.green);
    print("dkfkdfkdjfdkfdfdfdfd");
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img_login_header.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: <Widget>[
          Expanded(
              flex: 4,
              child: Stack(
                children: [
                  _controller.value.isInitialized
                      ? Container(
                          width: double.infinity,
                          child: VideoPlayer(_controller))
                      : Container(),
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 50),
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        "assets/launcher_icon.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ))
                ],
              )),
          Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg_enter_phone.png"),
                        fit: BoxFit.cover),
                    color: Color.fromARGB(255, 247, 247, 247),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        // padding: EdgeInsets.all(1),
                        margin: EdgeInsets.only(top: 10, right: 10),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: Color.fromRGBO(255, 118, 87, 1))),
                        child: appRegion == 2
                            ? ToggleSwitch(
                                minWidth: 60.0,
                                minHeight: 90.0,
                                fontSize: 10.0,
                                initialLabelIndex: languageIntials == 1 ? 1 : 0,
                                activeBgColor: [
                                  Color.fromRGBO(255, 118, 87, 1)
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.white,
                                inactiveFgColor: Colors.grey[900],
                                totalSwitches: 2,
                                labels: ['English', 'Suomi'],
                                onToggle: (index) async {
                                  if (index == 0) {
                                    print("SetLangEnglish");
                                    await _appController.changeLanguage(
                                        QueryChangeLanguage(
                                            id: responseLoginUser.user.id
                                                .toString(),
                                            language: AppConstants
                                                .LANGUAGE_ENGLISH
                                                .toString()),
                                        apiKey.toString());

                                    await _appController.updateProfile(
                                        responseLoginUser.user.id.toString(),
                                        AppConstants.LANGUAGE_ENGLISH,
                                        apiKey.toString());
                                    _appController.readSkillCities(
                                        AppConstants.LANGUAGE_ENGLISH,
                                        apiKey.toString());
                                    Constants.sharedPreferences.setInt(
                                        SharePrefrencesValues.LANGUAGE_INTIALS,
                                        0);
                                    var locale = Locale('en');
                                    Get.updateLocale(locale);
                                  } else {
                                    print("SetLangSuomi");
                                    await _appController.changeLanguage(
                                        QueryChangeLanguage(
                                            id: responseLoginUser.user.id
                                                .toString(),
                                            language: AppConstants
                                                .LANGUAGE_SUOMI
                                                .toString()),
                                        apiKey.toString());
                                    await _appController.updateProfile(
                                        responseLoginUser.user.id.toString(),
                                        AppConstants.LANGUAGE_SUOMI,
                                        apiKey.toString());
                                    _appController.readSkillCities(
                                        AppConstants.LANGUAGE_SUOMI,
                                        apiKey.toString());
                                    Constants.sharedPreferences.setInt(
                                        SharePrefrencesValues.LANGUAGE_INTIALS,
                                        1);
                                    var locale = Locale('fi');
                                    Get.updateLocale(locale);
                                  }
                                },
                              )
                            : ToggleSwitch(
                                minWidth: 60.0,
                                minHeight: 90.0,
                                fontSize: 10.0,
                                initialLabelIndex: languageIntials == 1 ? 1 : 0,
                                activeBgColor: [
                                  Color.fromRGBO(255, 118, 87, 1)
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.white,
                                inactiveFgColor: Colors.grey[900],
                                totalSwitches: 2,
                                labels: ['English', 'Urdu'],
                                onToggle: (index) async {
                                  if (index == 0) {
                                    print("SetLangEnglish");
                                    Constants.sharedPreferences.setInt(
                                        SharePrefrencesValues.LANGUAGE_INTIALS,
                                        0);
                                    var locale = Locale('en');
                                    Get.updateLocale(locale);
                                  } else {
                                    print("SetLangUrdu");
                                    Constants.sharedPreferences.setInt(
                                        SharePrefrencesValues.LANGUAGE_INTIALS,
                                        1);
                                    var locale = Locale('ur');
                                    Get.updateLocale(locale);
                                  }
                                },
                              ),
                      ),
                    ),
                    wait_loaction
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "title_sp_selec".tr,
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange[600],
                                              fontSize: 15)),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        AppConstants.isSlectedUserCustomer =
                                            false;

                                       Get.to(ServiceProviderLandingPage(0));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: 150,
                                          height: 130,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(
                                                "assets/ic_seller_serller.png"),
                                            fit: BoxFit.fill,
                                          ))),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (() {
                                    AppConstants.isSlectedUserCustomer = true;
                                    Get.to(CustomerLandingPage(0));
                                  }),
                                  child: Column(
                                    children: [
                                      Text(
                                        "title_cus_selec".tr,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.orange[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: 150,
                                          height: 130,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(
                                                "assets/ic_select_customer.png"),
                                            fit: BoxFit.fill,
                                          )))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Center(
                            child: Container(
                              child: Column(
                                children: [
                                  const CircularProgressIndicator(),
                                  Text(
                                    "Wait Location Is Fetching",
                                    style: Styles.headingTextColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }

  chekAppMode() {
    if (kReleaseMode) {
      showToast("App is in release Mode",
          context: context, backgroundColor: Colors.red);
    } else {
      showToast("App is in debug Mode",
          context: context, backgroundColor: Colors.blue);
    }
  }

  void decrtyptKey(String apiKey) async {
    print("KeyToBeDecrypted${apiKey}");
    print("KeyDecrypted${responseLoginUser.user.apiPlanText}");
    // String result = DeCryptom().text(apiKey);
    // print("Decrtptedresult$result");
  }

  void manageUserConsentDisclouser() async {
    var status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {
      print("StatusNotGranted");
      if (Constants.sharedPreferences
              .getBool(SharePrefrencesValues.LOCATIONPERMISSIONPERMANENT) ==
          true) {
      } else {
        createNewMessage();
      }
    } else {
      print("StatusGranted");
      setState(() {
        wait_loaction = false;
      });
      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() {
          wait_loaction = true;
        });
      });
      _getUserLocation();

      // createNewMessage();
    }
  }

  createNewMessage() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Image.asset(
                          "assets/business_location.png",
                          fit: BoxFit.fill,
                          width: 20,
                          height: 20,
                        )),
                        Text("Your Location Permission",
                            style: GoogleFonts.kodchasan(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                        Container(
                            margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Text(
                                "To use your location to automatically see the latest jobs or service providers around your area, please allow Odlay Services to use your location when the application is open or running.",
                                style: GoogleFonts.kodchasan(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                )))),
                        Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Text(
                                "Odlay Services will use your location to fetch the latest jobs or closest service providers around your area and will order them by distance from your location",
                                style: GoogleFonts.kodchasan(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                )))),
                        Spacer(),
                        Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: Image.asset(
                              "assets/ic_map-location.png",
                              fit: BoxFit.fill,
                              width: 150,
                              height: 130,
                            )),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    _getUserLocation();
                                  },
                                  icon: const Icon(
                                    // <-- Icon

                                    Icons.camera_alt_outlined,
                                    size: 0.0,
                                  ),
                                  label: Text(
                                    'I Agree',
                                    style: GoogleFonts.kodchasan(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    primary: wait_loaction
                                        ? Colors.orange[900]
                                        : Colors.orange[900],
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  icon: const Icon(
                                    // <-- Icon

                                    Icons.camera_alt_outlined,
                                    size: 0.0,
                                  ),
                                  label: Text(
                                    'Not now',
                                    style: GoogleFonts.kodchasan(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    primary: wait_loaction
                                        ? Colors.grey
                                        : Colors.grey,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                  onPressed: () async {
                                    Constants.sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    Constants.sharedPreferences.setBool(
                                        SharePrefrencesValues
                                            .LOCATIONPERMISSIONPERMANENT,
                                        true);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    try {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "You have declined the location permission for Odlay Services app. You can enable the location permission again from the settings in order to automatically see the latest deals around your area.")));
                                    } catch (e) {}
                                  },
                                  icon: const Icon(
                                    // <-- Icon

                                    Icons.camera_alt_outlined,
                                    size: 0.0,
                                  ),
                                  label: Text(
                                    'No Thanks',
                                    style: GoogleFonts.kodchasan(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    primary: wait_loaction
                                        ? Colors.grey
                                        : Colors.grey,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }

  Future<void> _getUserLocation() async {
    try{
    userCurrentLocation.Location location = userCurrentLocation.Location();
    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    final _locationData = await location.getLocation();
    // setState(() async {
    _userLocation = _locationData;
    LocationConstants.USERCURRENTLATITUDE = _userLocation!.latitude as double;
    LocationConstants.USERCURRENTLONGITUDE = _userLocation!.longitude as double;
    var test_location = LocationConstants.USERCURRENTLONGITUDE;
    print("UserLocation$test_location");
    getAddressFromLatLng(
        _userLocation!.latitude as double, _userLocation!.longitude as double);
    }
    catch(e){
      print("ExceptionGetLocation${e}");
    }
  }

  void showDisclaimerDialog(BuildContext context, String disclaimerMessage) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (BuildContext dialogueContext, __, ___) {
        return Center(
          child: Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 118, 87, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          "Disclaimer",
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Positioned(
                          right: 10,
                          top: 10,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Html(
                        data: disclaimerMessage,
                        style: {
                          'li': Style(
                              color: Colors.black,
                              fontSize: FontSize(12),
                              ),
                          'h4': Style(color: Color.fromARGB(255, 53, 52, 52))
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogueContext);
                            },
                            style: Styles.appElevatedJobStatusButtonStyle,
                            child: Text('decline'.tr)),
                      ),
                      SizedBox(
                        width: 80,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogueContext);
                            },
                            style: Styles.appElevatedJobStatusButtonStyle,
                            child: Text('accept'.tr)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void getAddressFromLatLng(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark placeMark = placemarks.first;
    print("SelectedFullAddress${placeMark}");
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? subAdministrativeArea = placeMark.subAdministrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? thoughFare = placeMark.thoroughfare;
    String? SubThoughFare = placeMark.subThoroughfare;
    String? street = placeMark.street;

    String? uiAddress; 
    if(appRegion==2){
uiAddress= GenericAppFunctions.removeDuplicateAddress(
        "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
    }
    else{
    uiAddress= GenericAppFunctions.removeDuplicateAddress(
        "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
    }
print("RemovedDuplicateAddress${uiAddress}");
//set you location for auto fill parameter
    AutoFillAddress.autoLocationAvaviable = true;
    AutoFillAddress.autoLocationAddress = uiAddress;
    AutoFillAddress.autoLocationLat = lat;
    AutoFillAddress.autoLocationLong = lng;
    AutoFillAddress.autoLocationLocality = locality.toString();
    AutoFillAddress.autoLocationSubAdmin =
        placeMark.subAdministrativeArea.toString();
  }

  void getDeviceToken() {
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print("token is $token");
    });
  }

  _runsAfterBuild() async {
    await Future.delayed(Duration(seconds: 5));
    print("Chnage_Language");
    if (responseLoginUser.user.language == AppConstants.LANGUAGE_SUOMI) {
      if (!languageChnaged) {
        languageChnaged = true;
        var locale = Locale('fi');
        Get.updateLocale(locale);
      }
    }
  }
  void printDeviceTokebn(){
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print("device_token_selection is: $token");
      
    });
  }

}
