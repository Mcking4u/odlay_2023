import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/AutoFillAddress.dart';
import 'package:odlay_services/AppFiles/Utility/CameraPromt.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/LocationPromt.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/_query_change_permission.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_quer_edit_profile.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/FullImageShowUpload.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:permission_handler/permission_handler.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:get/get.dart';

class HeaderProfileWidgetSp extends StatefulWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  HeaderProfileWidgetSp(this._resposneServiceProviderProfile);
  @override
  State<HeaderProfileWidgetSp> createState() => _HeaderProfileWidgetSpState();
}

class _HeaderProfileWidgetSpState extends State<HeaderProfileWidgetSp> {
  // Datum serviceProvider;
  AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;

  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  bool isSwitched = false;
  String apiKeyAutoCompleteSearch = 'AIzaSyDjBU-oor10ZAk-cq0CEGOFStPFaRq_T-M';
  late var _places;
  late bool _serviceEnabled;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  late SkillCitiesProfessions skillCitiesProfessions;
  String cityName = "";
  int cityId = 0;
  late double userLatitude, userLongitude;
  late BuildContext ProfilePageContext;
  int? appRegion;
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    _places = GoogleMapsPlaces(apiKey: apiKeyAutoCompleteSearch);
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    poulateUserData();
    ProfilePageContext = context;
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        print("OpenCamera");
                        bool cameraAgree = false;
                        if (await Permission.camera.isGranted) {
                          cameraAgree = true;
                        } else {
                          await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return CameraPrompt(
                                    () async {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      cameraAgree = true;
                                    },
                                    "To update your Superdeals profile with your photo, please allow Superdeals to use your camera to take your latest photo.Superdeals will use your profile photo for identity verification.",
                                  );
                                });
                              });
                        }
                        if (cameraAgree) {
                          try {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (image == null) {
                              return;
                            } else {
                              final imageTemp = File(image.path);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      SimplePhotoViewPageViewUpload(
                                          imageTemp)));
                            }
                          } on PlatformException catch (e) {
                            print('Failed to pick image: $e');
                          }
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              AppConstants.PROFILEIMAGESURLS +
                                  responseLoginUser.user.logo.toString()),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 5,
                        bottom: 5,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.green,
                          size: 20,
                        ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: RatingBarIndicator(
                      rating:
                          widget._resposneServiceProviderProfile.rating != null
                              ? double.parse(widget
                                  ._resposneServiceProviderProfile.rating
                                  .toString())
                              : 0.0,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Color.fromRGBO(255, 118, 87, 1),
                      ),
                      itemCount: 5,
                      itemSize: 15.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
                Text(widget._resposneServiceProviderProfile.reviews!=null?
                "(${widget._resposneServiceProviderProfile.reviews!.length})":"(0)", 
                style: Styles.textProfileStyle)
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10, bottom: 5),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/ic_share_flutter.png",
                              fit: BoxFit.contain,
                              width: 30,
                              height: 30,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              height: 30,
                              width: 60,
                              child: Image.asset("assets/ic_share_fb.png"),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showBottomSheetEditProfile(
                                    AppConstants.baseContext);
                              },
                              child: Image.asset(
                                "assets/ic_edit_profile.png",
                                fit: BoxFit.contain,
                                width: 30,
                                height: 30,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/ic_user.png",
                        fit: BoxFit.contain,
                        width: 20,
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(responseLoginUser.user.firstName.toString(),
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: Colors.orange[900],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/ic_company_name.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                overflow: TextOverflow.ellipsis,
                                widget._resposneServiceProviderProfile.title !=
                                        null
                                    ? widget
                                        ._resposneServiceProviderProfile.title
                                        .toString()
                                    : "",
                                style: Styles.textProfileStyle),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/ic_address.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                maxLines: 2,
                                responseLoginUser
                                            .user.serviceProviders.address !=
                                        null
                                    ? responseLoginUser
                                        .user.serviceProviders.address
                                        .toString()
                                    : "",
                                style: Styles.textProfileStyle),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Switch(
                            hoverColor: Colors.green,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: isSwitched,
                            onChanged: (value) async {
                              setState(() {
                                isSwitched = value;
                                if (isSwitched) {
                                  _appController.setPhonePermission(
                                      QueryChangePermission(
                                          id: responseLoginUser
                                              .user.serviceProviders.userId
                                              .toString(),
                                          allowMobileCall: "1"),
                                      apiKey.toString());
                                } else {
                                  _appController.setPhonePermission(
                                      QueryChangePermission(
                                          id: responseLoginUser
                                              .user.serviceProviders.userId
                                              .toString(),
                                          allowMobileCall: "0"),
                                      apiKey.toString());
                                }
                                print("IsSwitched${isSwitched.toString()}");
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('available_on_phone'.tr,
                              style: Styles.textProfileStyle),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheetEditProfile(BuildContext context) {
    print("OpenSheetEditBasic");
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext sheetcontext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 60,
                          color: Colors.grey,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Image.asset(
                            "assets/ic_edit_screen_line.png",
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 2,
                          ),
                        ),
                        Text(
                          'sheet_edit_profile_title'.tr,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 118, 87, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/ic_user_grey.png",
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: fullName,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            filled: false,
                                            hintText: "Enter Full Name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Positioned(
                                  top: 5,
                                  right: 10,
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/ic_phone_grey.png",
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: TextField(
                                          enabled: false,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: phone,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            filled: false,
                                            hintText: "Enter Phone",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Positioned(
                                  top: 5,
                                  right: 10,
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/ic_job_title.png",
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: email,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            filled: false,
                                            hintText: "Enter email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Positioned(
                                  top: 5,
                                  right: 10,
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/ic_company_grey.png",
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: companyName,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            filled: false,
                                            hintText: "Enter Company",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // const Positioned(
                              //     top: 5,
                              //     right: 10,
                              //     child: Text(
                              //       "*",
                              //       style: TextStyle(
                              //           color: Colors.red,
                              //           fontSize: 20,
                              //           fontWeight: FontWeight.bold),
                              //     ))
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/ic_search_grey.png",
                                        fit: BoxFit.contain,
                                        width: 20,
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: TextField(
                                            readOnly: true,
                                            onTap: () async {
                                              Prediction? p =
                                                  await PlacesAutocomplete.show(
                                                context: context,
                                                apiKey:
                                                    apiKeyAutoCompleteSearch,
                                                offset: 0,
                                                radius: 1000,
                                                types: [],
                                                strictbounds: false,
                                                mode: Mode.overlay,
                                                language: "en",
                                                components: [
                                                  new Component(
                                                      Component.country, "pk"),
                                                  new Component(
                                                      Component.country, "fi")
                                                ],
                                              );
                                              if (p != null) {
                                                if (p.placeId
                                                    .toString()
                                                    .isNotEmpty) {
                                                  PlacesDetailsResponse
                                                      response = await _places
                                                          .getDetailsByPlaceId(p
                                                              .placeId
                                                              .toString());
                                                  var location = response.result
                                                      .geometry!.location;
                                                  print(
                                                      "AddressSelected${location}");
                                                  userLatitude = location.lat;
                                                  userLongitude = location.lng;
                                                  try {
                                                    List<geocoding.Placemark>
                                                        placemarks =
                                                        await geocoding
                                                            .placemarkFromCoordinates(
                                                                userLatitude,
                                                                userLongitude);
                                                    geocoding.Placemark
                                                        placeMark =
                                                        placemarks.first;
                                                    String? name =
                                                        placeMark.name;
                                                    String? subLocality =
                                                        placeMark.subLocality;
                                                    String? locality =
                                                        placeMark.locality;
                                                    String? administrativeArea =
                                                        placeMark
                                                            .administrativeArea;
                                                    String? postalCode =
                                                        placeMark.postalCode;
                                                    String? country =
                                                        placeMark.country;
                                                    String? street =
                                                        placeMark.street;
                                                    String? address; 
                                                    if(appRegion==2){
address=
                                                        GenericAppFunctions
                                                            .removeDuplicateAddress(
                                                                "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality}  ${country}");

                                                    }
                                                    else{
                                                    address=
                                                        GenericAppFunctions
                                                            .removeDuplicateAddress(
                                                                "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                                    print("Lora");
                                                    }
                                                    print(address);
                                                    // jobAddress.text = address.toString();
                                                    for (var i = 0;
                                                        i <
                                                            skillCitiesProfessions
                                                                .city.length;
                                                        i++) {
                                                      String city_name =
                                                          skillCitiesProfessions
                                                              .city[i].cityTitle
                                                              .toString();
                                                              String city_name1=
                                                          skillCitiesProfessions
                                                              .city[i].cityTitle2
                                                              .toString();
                                                      if (city_name ==
                                                              locality ||
                                                          city_name ==
                                                              placeMark
                                                                  .subAdministrativeArea) {
                                                        cityId =
                                                            skillCitiesProfessions
                                                                .city[i].cityId;
                                                        cityName = city_name;
                                                        print("CityId$cityId");
                                                      }
                                                      else  if (city_name1 ==
                                                              locality ||
                                                          city_name1 ==
                                                              placeMark
                                                                  .subAdministrativeArea) {
                                                        cityId =
                                                            skillCitiesProfessions
                                                                .city[i].cityId;
                                                        cityName = city_name1;
                                                        print("CityId$cityId");
                                                      }
                                                      print(
                                                          "CityName$city_name");
                                                    }
                                                    setState(() {
                                                      userAddress.text =
                                                          address!;
                                                    });
                                                  } catch (e) {
                                                    showToast("Exception$e",
                                                        backgroundColor:
                                                            Colors.blue);
                                                  }
                                                } else {
                                                  showToast(
                                                      "No Address Selected",
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.lightBlue);
                                                }
                                              }
                                            },
                                            controller: userAddress,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              isDense: true,
                                              filled: false,
                                              hintText: "Select Address",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                      onTap: () async {
                                        bool locationAgree = false;
                                        if (await Permission
                                            .locationWhenInUse.isGranted) {
                                          // Use location.
                                          locationAgree = true;
                                        } else {
                                          await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return LocationPrompt(
                                                    () async {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      locationAgree = true;
                                                    },
                                                  );
                                                });
                                              });
                                        }
                                        if (locationAgree) {
                                          userCurrentLocation.Location
                                              location =
                                              userCurrentLocation.Location();

                                          // Check if location service is enable
                                          _serviceEnabled =
                                              await location.serviceEnabled();
                                          if (!_serviceEnabled) {
                                            _serviceEnabled =
                                                await location.requestService();
                                            if (!_serviceEnabled) {
                                              return;
                                            }
                                          }

                                          // Check if permission is granted
                                          _permissionGranted =
                                              await location.hasPermission();
                                          if (_permissionGranted ==
                                              userCurrentLocation
                                                  .PermissionStatus.denied) {
                                            _permissionGranted = await location
                                                .requestPermission();
                                            if (_permissionGranted !=
                                                userCurrentLocation
                                                    .PermissionStatus.granted) {
                                              return;
                                            }
                                          }

                                          final _locationData =
                                              await location.getLocation();
                                          // setState(() async {

                                          userLatitude =
                                              _locationData.latitude as double;
                                          userLongitude =
                                              _locationData.longitude as double;

                                          List<geocoding.Placemark> placemarks =
                                              await geocoding
                                                  .placemarkFromCoordinates(
                                                      userLatitude,
                                                      userLongitude);
                                          geocoding.Placemark placeMark =
                                              placemarks.first;

                                          String? subLocality =
                                              placeMark.subLocality;
                                          String? locality = placeMark.locality;
                                          String? administrativeArea =
                                              placeMark.administrativeArea;
                                          String? postalCode =
                                              placeMark.postalCode;
                                          String? country = placeMark.country;
                                          String? address =
                                              "${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}";
                                          print("Fucked");
                                          print(address);
                                          String city_name;

                                          for (var i = 0;
                                              i <
                                                  skillCitiesProfessions
                                                      .city.length;
                                              i++) {
                                            city_name = skillCitiesProfessions
                                                .city[i].cityTitle
                                                .toString();
                                            if (city_name == locality) {
                                              cityId = skillCitiesProfessions
                                                  .city[i].cityId;
                                              cityName = city_name;
                                              print("CityId$cityId");
                                            }
                                            print("CityName$city_name");
                                          }
                                          setState(() {
                                            userAddress.text = address;
                                          });
                                        }
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          "assets/ic_pickmylocation.png",
                                          fit: BoxFit.fill,
                                        ),
                                      )))
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            SelectDialog.showModal<City>(
                              context,
                              label: "Select Skills",
                              items: skillCitiesProfessions.city,
                              onChange: (City selectedCity) {
                                setState(() {
                                  print("SelectCityId${selectedCity.cityId}");
                                  print(
                                      "SelectCityName${selectedCity.cityTitle}");
                                  cityId = selectedCity.cityId;
                                  cityName = selectedCity.cityTitle.toString();
                                });
                              },
                            );
                          },
                          child: Container(
                            height: 40,
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 5),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 230, 230, 230),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/ic_address_grey.png",
                                      fit: BoxFit.contain,
                                      width: 20,
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          cityName,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Positioned(
                                    top: 5,
                                    right: 10,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: 20,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 40,
                          width: double.infinity,
                          child: Obx(() => AppElevatedButton(
                                borderRadius: BorderRadius.circular(20),
                                onPressed: () async {
                                  print("preEdit");
                                  await _appController.editProfile(
                                      QueryEditProfile(
                                          cityId: cityId,
                                          email: email.text.toString(),
                                          firstName: fullName.text.toString(),
                                          fullAddress:
                                              userAddress.text.toString(),
                                          id: responseLoginUser
                                              .user.serviceProviders.userId,
                                          isServiceProvider: true,
                                          phone: phone.text.toString(),
                                          latitude: userLatitude,
                                          longitude: userLongitude,
                                          title: companyName.text),
                                      apiKey.toString());
                                  print("postEdit");
                                  if (_appController.generalResponse != null) {
                                    if (_appController
                                            .generalResponse!.status ==
                                        "success") {
                                      showToast("Profile update successfull",
                                          context: context,
                                          backgroundColor: Colors.green);
                                      Navigator.pop(sheetcontext);
                                      Navigator.pushAndRemoveUntil(
                                        ProfilePageContext,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileLandingPage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else {
                                      showToast("Profile not updated",
                                          context: context,
                                          backgroundColor: Colors.red);
                                    }
                                  }
                                },
                                child: Text(_appController.updatingProfile.value
                                    ? 'updating'.tr
                                    : 'update'.tr),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void poulateUserData() {
    fullName.text = responseLoginUser.user.firstName.toString();
    phone.text = responseLoginUser.user.phone.toString();
    email.text = responseLoginUser.user.email.toString();
    print("UserAddress" +
        responseLoginUser.user.serviceProviders.address.toString());
    if (responseLoginUser.user.serviceProviders.address != null) {
      userAddress.text =
          responseLoginUser.user.serviceProviders.address.toString();
      userLatitude = double.parse(
          responseLoginUser.user.serviceProviders.latitude.toString());
      userLongitude = double.parse(
          responseLoginUser.user.serviceProviders.longitude.toString());
      cityId = responseLoginUser.user.serviceProviders.cityId;
      cityName = GenericAppFunctions.getCityNameFromCityId(
          skillCitiesProfessions, cityId);
    } else {
      autoFillLocationFilter();
    }
    if (widget._resposneServiceProviderProfile.title != null) {
      companyName.text =
          widget._resposneServiceProviderProfile.title.toString();
    }
    if (widget._resposneServiceProviderProfile.allowMobileCall == 1) {
      isSwitched = true;
    } else {
      isSwitched = false;
    }
  }

  void resetState() {
    setState(() {});
  }

  Future autoFillLocationFilter() async {
    if (AutoFillAddress.autoLocationAvaviable) {
      userAddress.text = AutoFillAddress.autoLocationAddress;
      userLatitude = AutoFillAddress.autoLocationLat;
      userLongitude = AutoFillAddress.autoLocationLong;
      CityIdName cityIdName = await AutoFillAddress.getCityIdName(
          AutoFillAddress.autoLocationLocality,
          AutoFillAddress.autoLocationSubAdmin,
          skillCitiesProfessions);
      cityId = cityIdName.cityId;
      cityName = cityIdName.cityName;
    }
  }
}
