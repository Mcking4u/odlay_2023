import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Dialogues/_quick_update_dialogue.dart';
import 'package:odlay_services/AppFiles/Utility/AutoFillAddress.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationPromt.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/UpdateUserDetail.dart/_query_quick_update.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/Tuple.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_home_page_categories.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_homepager_header.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_top_rated_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/HomePage/_lates_jobs_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_latest_top_rated_service_provider.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/_job_post_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/customerJobDetail/_customer_job_detail.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';

class HomePage1 extends StatefulWidget {
  @override
  State<HomePage1> createState() => HomePageState();
}

class HomePageState extends State<HomePage1> {
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  TextEditingController userAddress = TextEditingController();
  late bool _serviceEnabled;
  String cityName = "";
  int cityId = 0;
  late double userLatitude, userLongitude;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  final AppController _appController = Get.put(AppController());
  late String? apiKey;
  RxBool userCurrentLocationWait = true.obs;
  String apiKeyAutoCompleteSearch = 'AIzaSyDjBU-oor10ZAk-cq0CEGOFStPFaRq_T-M';
  late var _places;
  late int? appRegion;

  @override
  void initState() {
    print("HomePagReInistiate");
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    _places = GoogleMapsPlaces(apiKey: apiKeyAutoCompleteSearch);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    appRegion =Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    if (HeaderFilterConstant.isFilterApplied) {
      userCurrentLocationWait(false);
    } else {
      if (responseLoginUser.user.consumer.address != null) {
        if (LocationConstants.USERCURRENTLATITUDE != 0.0 &&
            LocationConstants.USERCURRENTLONGITUDE != 0.0) {
          maipulateCurrentLocation();
        } else {
          userCurrentLocationWait(false);
          HeaderFilterConstant.defaultCityAddress =
              responseLoginUser.user.consumer.address.toString();
          HeaderFilterConstant.defaultCityName =
              GenericAppFunctions.getCityNameFromCityId(skillCitiesProfessions,
                  responseLoginUser.user.consumer.cityId);
          HeaderFilterConstant.defualtCityId =
              responseLoginUser.user.consumer.cityId;
          LocationConstants.USERCURRENTLATITUDE =
              double.parse(responseLoginUser.user.consumer.latitude.toString());
          LocationConstants.USERCURRENTLONGITUDE = double.parse(
              responseLoginUser.user.consumer.longitude.toString());
        }
      } else {
//populate fill address
        
  if (LocationConstants.USERCURRENTLATITUDE != 0.0 &&
            LocationConstants.USERCURRENTLONGITUDE != 0.0) {
          maipulateCurrentLocation();
        }
        else{
userCurrentLocationWait(false);
        }
       // maipulateCurrentLocation();
        
        WidgetsBinding.instance
            .addPostFrameCallback((_) => qucikUpdate(context, false));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("HomePageRebuild");
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          if (userCurrentLocationWait.value) {
            return Center(
              child: Container(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Please Waitt....",
                      style: Styles.headingTextColor,
                    )
                  ],
                ),
              ),
            );
          }
          return Container(
            color: const Color.fromARGB(255, 237, 236, 236),
            child: Column(
              children: [
                HomePageHeader(true),
                const SizedBox(
                  height: 106,
                ),
                HomePageCategories(),
                TopRatedGigs(),
                LatestTopRatedServiceProvider()
              ],
            ),
          );
        }),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          print("OpenJobPostLol");
//make refresh data again
          String? userSavedData = Constants.sharedPreferences
              .getString(SharePrefrencesValues.SAVEDUSERDATA);
          ResponseLoginUser responseLoginUserRefresh =
              responseLoginUserFromJson(userSavedData!);

          if (responseLoginUserRefresh.user.consumer.address != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => JobPostPage(null, false)));
          } else {
            qucikUpdate(context, true);
          }
        },
        child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/post_my_needs_eng.png'),
                fit: BoxFit.contain,
              ),
            )),
      ),
    );
  }

  qucikUpdate(BuildContext context, bool isProceed) async {
    print("OpenSheet");
    await autoFillLocationFilter();
    showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Container(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 230, 230, 230),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  child: TextFormField(
                                    minLines: 1,
                                    readOnly: true,
                                    controller: userAddress,
                                    onTap: () async {
                                      Prediction? p =
                                          await PlacesAutocomplete.show(
                                        context: context,
                                        apiKey: apiKeyAutoCompleteSearch,
                                        offset: 0,
                                        radius: 1000,
                                        types: [],
                                        strictbounds: false,
                                        mode: Mode.overlay,
                                        language: "en",
                                        components: [
                                          new Component(
                                              Component.country, "pk"),
                                          new Component(Component.country, "fi")
                                        ],
                                      );
                                      if (p != null) {
                                        if (p.placeId.toString().isNotEmpty) {
                                          PlacesDetailsResponse response =
                                              await _places.getDetailsByPlaceId(
                                                  p.placeId.toString());
                                          var location = response
                                              .result.geometry!.location;
                                          print("AddressSelected${location}");
                                          // showToast("AddressSlectied",
                                          //     context: context,
                                          //     backgroundColor: Colors.blue);
                                          userLatitude = location.lat;
                                          userLongitude = location.lng;
                                          try {
                                            List<geocoding.Placemark>
                                                placemarks = await geocoding
                                                    .placemarkFromCoordinates(
                                                        userLatitude,
                                                        userLongitude);
                                            geocoding.Placemark placeMark =
                                                placemarks.first;
                                            String? name = placeMark.name;
                                            String? street = placeMark.street;
                                            String? subLocality =
                                                placeMark.subLocality;
                                            String? locality =
                                                placeMark.locality;
                                            String? administrativeArea =
                                                placeMark.administrativeArea;
                                            String? postalCode =
                                                placeMark.postalCode;
                                            String? country = placeMark.country;
                                            String? address; 
                                            if(appRegion==2){
address = GenericAppFunctions
                                                .removeDuplicateAddress(
                                                    "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
                                            }
                                            else{
                                           address = GenericAppFunctions
                                                .removeDuplicateAddress(
                                                    "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                            print("Lora");
                                            }
                                            // showToast("Address${address}",
                                            //     context: context,
                                            //     backgroundColor: Colors.blue);
                                            print(address);
                                            userAddress.text =
                                                address.toString();
                                            for (var i = 0;
                                                i <
                                                    skillCitiesProfessions
                                                        .city.length;
                                                i++) {
                                              String city_name =
                                                  skillCitiesProfessions
                                                      .city[i].cityTitle
                                                      .toString();
                                              String city_name1 =
                                                  skillCitiesProfessions
                                                      .city[i].cityTitle2
                                                      .toString();        
                                              if (city_name == locality ||
                                                  city_name ==
                                                      placeMark
                                                          .subAdministrativeArea) {
                                                cityId = skillCitiesProfessions
                                                    .city[i].cityId;
                                                cityName = city_name;
                                                print("CityId$cityId");
                                              }
                                              else if (city_name1 == locality ||
                                                  city_name1 ==
                                                      placeMark
                                                          .subAdministrativeArea) {
                                                cityId = skillCitiesProfessions
                                                    .city[i].cityId;
                                                cityName = city_name1;
                                                print("CityId$cityId");
                                              }
                                              print("CityName$city_name");
                                            }
                                            setState(() {
                                              userAddress.text = address!;
                                            });
                                          } catch (e) {
                                            showToast("Exception$e",
                                                context: context,
                                                backgroundColor: Colors.blue);
                                          }
                                        } else {
                                          showToast("No Address Selected",
                                              context: context,
                                              backgroundColor:
                                                  Colors.lightBlue);
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: 'str_enter_address'.tr,
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ))),
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
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return LocationPrompt(
                                              () async {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                locationAgree = true;
                                              },
                                            );
                                          });
                                        });
                                  }
                                  if (locationAgree) {
                                    userCurrentLocation.Location location =
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
                                      _permissionGranted =
                                          await location.requestPermission();
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
                                                userLatitude, userLongitude);
                                    geocoding.Placemark placeMark =
                                        placemarks.first;

                                    String? subLocality = placeMark.subLocality;
                                    String? locality = placeMark.locality;
                                    String? administrativeArea =
                                        placeMark.administrativeArea;
                                    String? postalCode = placeMark.postalCode;
                                    String? country = placeMark.country;
                                    String? street = placeMark.street;
                                    String? address; 
                                    if(appRegion==2){

address = GenericAppFunctions
                                        .removeDuplicateAddress(
                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
                                    ;
                                    }
                                    else{
                                   address = GenericAppFunctions
                                        .removeDuplicateAddress(
                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                    ;
                                    }
                                    print("Fucked");
                                    print(address);
                                    String city_name;
                                    String city_name1;
                                    for (var i = 0;
                                        i < skillCitiesProfessions.city.length;
                                        i++) {
                                      city_name = skillCitiesProfessions
                                          .city[i].cityTitle
                                          .toString();
                                      city_name1 = skillCitiesProfessions
                                          .city[i].cityTitle2
                                          .toString();    
                                      if (city_name == locality ||
                                          city_name ==
                                              placeMark.subAdministrativeArea) {
                                        cityId = skillCitiesProfessions
                                            .city[i].cityId;
                                        cityName = city_name;
                                        print("CityId$cityId");
                                      }
                                      if (city_name1 == locality ||
                                          city_name1 ==
                                              placeMark.subAdministrativeArea) {
                                        cityId = skillCitiesProfessions
                                            .city[i].cityId;
                                        cityName = city_name1;
                                        print("CityId$cityId");
                                      }
                                      print("CityName$city_name");
                                    }
                                    setState(() {
                                      userAddress.text = address!;
                                    });
                                  }
                                },
                                child: Container(
                                    color: Colors.grey[200],
                                    child: Image.asset(
                                      "assets/ic_pickmylocation.png",
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: 55,
                                    )),
                              ))
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
                              print("SelectCityName${selectedCity.cityTitle}");
                              cityId = selectedCity.cityId;
                              cityName = selectedCity.cityTitle.toString();
                            });
                          },
                        );
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 230, 230, 230),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Stack(
                          children: [
                            Container(
                              height: 40,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      height: 40,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Image.asset(
                                              "assets/ic_address_grey.png",
                                              fit: BoxFit.contain,
                                              width: 20,
                                              height: 20,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        cityName,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      height: 40,
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Note: Please enter your location.Info: Your address is only used for verification purposes and will not be shown publically. However, you may use it in the job description if the task location is your address.",
                            style: Styles.noteTextColorAddress),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: AppElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: const Text('close')),
                          ),
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: AppElevatedButton(
                                onPressed: () async {
                                  await _appController.quickUpdate(
                                      QueryQuickUpdate(
                                          cityId: cityId,
                                          fullAddress:
                                              userAddress.text.toString(),
                                          isServiceProvider: false,
                                          latitude: userLatitude,
                                          longitude: userLongitude,
                                          skills: [],
                                          id: responseLoginUser
                                              .user.consumer.userId),
                                      apiKey.toString());
                                  if (_appController.quickUpdateResponse !=
                                      null) {
                                    if (_appController
                                            .quickUpdateResponse.status ==
                                        "success") {
                                      await _appController.updateProfile(
                                          responseLoginUser
                                              .user.serviceProviders.userId
                                              .toString(),
                                          responseLoginUser.user.language,
                                          apiKey.toString());

                                      Navigator.pop(context);
                                      UpdateAfterQuickUpdate();
                                      if (isProceed) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JobPostPage(null, false)));
                                      }
                                    } else {
                                      showToast(
                                          _appController
                                              .quickUpdateResponse.message
                                              .toString(),
                                          context: context,
                                          backgroundColor: Colors.red);
                                    }
                                  } else {
                                    showToast("Unable to update profile",
                                        context: context,
                                        backgroundColor: Colors.red);
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: const Text('Update')),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        });
  }

  void maipulateCurrentLocation() async {
    await GenericAppFunctions.getCityAndAddress(
        skillCitiesProfessions,
        LocationConstants.USERCURRENTLATITUDE,
        LocationConstants.USERCURRENTLONGITUDE,
        appRegion);
    print("PostAddress");
    userCurrentLocationWait(false);
  }

  void UpdateAfterQuickUpdate() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    userCurrentLocationWait(true);
    if (responseLoginUser.user.consumer.address != null) {
      HeaderFilterConstant.defaultCityAddress =
          responseLoginUser.user.consumer.address.toString();
      HeaderFilterConstant.defaultCityName =
          GenericAppFunctions.getCityNameFromCityId(
              skillCitiesProfessions, responseLoginUser.user.consumer.cityId);
      HeaderFilterConstant.defualtCityId =
          responseLoginUser.user.consumer.cityId;
      LocationConstants.USERCURRENTLATITUDE =
          double.parse(responseLoginUser.user.consumer.latitude.toString());
      LocationConstants.USERCURRENTLONGITUDE =
          double.parse(responseLoginUser.user.consumer.longitude.toString());
      userCurrentLocationWait(false);
    }
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
