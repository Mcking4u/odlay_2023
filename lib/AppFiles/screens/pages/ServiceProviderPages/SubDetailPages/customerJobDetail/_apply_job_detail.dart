import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/AutoFillAddress.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/LocationPromt.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_update_address.dart';
import 'package:odlay_services/AppFiles/model/UpdateSkills/_update_service_provider_skill.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';

import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/SubDetailPages/customerJobDetail/_apply_bottom_sheet_job_detail.dart';
import 'package:odlay_services/AppFiles/model/CustomerModels/jobs_model.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/SubDetailPages/customerJobDetail/_body_apply_bottom_sheet.dart';
import 'package:odlay_services/AppFiles/screens/pages/test_bottom_sheet.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';

import 'package:odlay_services/Styles/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';

class ApplyJobDetail extends StatefulWidget {
  Datum jobsModel;
  ApplyJobDetail(this.jobsModel);
  @override
  State<ApplyJobDetail> createState() => _ApplyJobDetailState(jobsModel);
}

class _ApplyJobDetailState extends State<ApplyJobDetail> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  Datum jobsModel;
  _ApplyJobDetailState(this.jobsModel);
  AppController _appController = Get.put(AppController());
  late int? appRegion;
//update address
  TextEditingController filterAddress = TextEditingController();
  late double filterSearchLatitude, filtersearchLongitude;
  String filterCityName = "";
  int filterCityId = 0;
  String apiKeyAutoCompleteSearch = 'AIzaSyDjBU-oor10ZAk-cq0CEGOFStPFaRq_T-M';
  late var _places;
  late bool _serviceEnabled;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  final List<Skill> _selectedSkill = [];
  late String? apiKey;
  List<Marker> _markers = <Marker>[];
  

  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    print("ServiceId${responseLoginUser.user.serviceProviders.userId}");
    String? user_skills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    _places = GoogleMapsPlaces(apiKey: apiKeyAutoCompleteSearch);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(user_skills!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
        appRegion =Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    addMarkerJobMarker(double.parse(widget.jobsModel.latitude.toString()),
        double.parse(widget.jobsModel.longitude.toString()));
    super.initState();

    print("PlainApiText${responseLoginUser.user.apiPlanText}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text('job_detail_app_bar'.tr),
          backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          )),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height * .62,
                    width: double.infinity,
                    child: GoogleMap(
                      buildingsEnabled: false,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              double.parse(jobsModel.latitude.toString()),
                              double.parse(jobsModel.longitude.toString())),
                          zoom: 15.5),
                      markers: Set<Marker>.of(_markers),
                    )),
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .38,
                  right: 0.0,
                  left: 0.0),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    ApplyBottomSheetJobDetail(
                        jobsModel, responseLoginUser, skillCitiesProfessions),
                    Positioned(
                        right: 30,
                        child: Container(
                          child: Row(children: [
                            Container(
                              height: 30,
                              child: ElevatedButton(
                                style: Styles.appElevatedButtonStyle,
                                onPressed: () {
                                  String? user_dataSKill =
                                      Constants.sharedPreferences.getString(
                                          SharePrefrencesValues.SAVEDUSERDATA);
                                  responseLoginUser = responseLoginUserFromJson(
                                      user_dataSKill!);
                                  print("ApplyCLikd${jobsModel.skillId}");
                                  if (responseLoginUser
                                          .user.serviceProviders.address !=
                                      null) {
                                    if (responseLoginUser.user.skills != null &&
                                        responseLoginUser
                                            .user.skills!.isNotEmpty &&
                                        jobSkillAvaialbleInUserSkills()) {
                                      _showBottomSheetApply(
                                          AppConstants.baseContext,
                                          responseLoginUser,
                                          widget.jobsModel);
                                    } else {
                                      showAddSkillDialog(context);
                                    }
                                  } else {
                                    _bottomSheetUpdateAddress(context);
                                  }
                                },
                                child: Text('btn_apply'.tr),
                              ),
                            ),
                          ]),
                        ))
                  ],
                ),
              ),
            )
          ],
        ));
  }

  _showBottomSheetApply(BuildContext mainContext,
      ResponseLoginUser responseLoginUser, Datum jobModel) {
    print("OpenSheet");
    showModalBottomSheet<void>(
        context: mainContext,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(mainContext).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Image.asset(
                      "assets/ic_edit_screen_line.png",
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 4,
                    ),
                  ),
                  BodyApplyBottomSheet(jobsModel, responseLoginUser)
                ],
              ),
            ),
          );
        });
  }

  _bottomSheetUpdateAddress(BuildContext context) async {
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
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                  child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      color: Colors.grey,
                      margin: const EdgeInsets.only(
                          bottom: 10, top: 20, left: 10, right: 10),
                      child: Image.asset(
                        "assets/ic_edit_screen_line.png",
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 4,
                      ),
                    ),
                    Text('please_update_address'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                color: Color.fromRGBO(255, 118, 87, 1),
                                fontSize: 17,
                                fontWeight: FontWeight.normal))),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(left: 10),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 230),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
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
                                              new Component(
                                                  Component.country, "fi")
                                            ],
                                          );
                                          if (p != null) {
                                            if (p.placeId
                                                .toString()
                                                .isNotEmpty) {
                                              PlacesDetailsResponse response =
                                                  await _places
                                                      .getDetailsByPlaceId(
                                                          p.placeId.toString());
                                              var location = response
                                                  .result.geometry!.location;
                                              print(
                                                  "AddressSelected${location}");
                                              filterSearchLatitude =
                                                  location.lat;
                                              filtersearchLongitude =
                                                  location.lng;
                                              try {
                                                List<geocoding.Placemark>
                                                    placemarks = await geocoding
                                                        .placemarkFromCoordinates(
                                                            filterSearchLatitude,
                                                            filtersearchLongitude);
                                                geocoding.Placemark placeMark =
                                                    placemarks.first;
                                                String? name = placeMark.name;
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
                                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
                                                }
                                                else{
                                                address=
                                                    GenericAppFunctions
                                                        .removeDuplicateAddress(
                                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                                }
                                                print("Lora");
                                                print(address);
                                                filterAddress.text =
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
                                                    filterCityId =
                                                        skillCitiesProfessions
                                                            .city[i].cityId;
                                                    print(
                                                        "CityId$filterCityId");
                                                    filterCityName = city_name;
                                                  }
                                                  else  if (city_name1 == locality ||
                                                      city_name1 ==
                                                          placeMark
                                                              .subAdministrativeArea) {
                                                    filterCityId =
                                                        skillCitiesProfessions
                                                            .city[i].cityId;
                                                    print(
                                                        "CityId$filterCityId");
                                                    filterCityName = city_name1;
                                                  }
                                                  print("CityName$city_name");
                                                }
                                                setState(() {
                                                  filterAddress.text = address!;
                                                });
                                              } catch (e) {
                                                showToast("Exception$e",
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.blue);
                                              }
                                            } else {
                                              showToast("No Address Selected",
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.lightBlue);
                                            }
                                          }
                                        },
                                        controller: filterAddress,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          filled: false,
                                          hintText: 'select_address'.tr,
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
                                    print("PermissionGrandted");
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
                                    print("PostAwait");
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

                                      filterSearchLatitude =
                                          _locationData.latitude as double;
                                      filtersearchLongitude =
                                          _locationData.longitude as double;

                                      List<geocoding.Placemark> placemarks =
                                          await geocoding
                                              .placemarkFromCoordinates(
                                                  filterSearchLatitude,
                                                  filtersearchLongitude);
                                      geocoding.Placemark placeMark =
                                          placemarks.first;

                                      String? subLocality =
                                          placeMark.subLocality;
                                      String? locality = placeMark.locality;
                                      String? administrativeArea =
                                          placeMark.administrativeArea;
                                      String? postalCode = placeMark.postalCode;
                                      String? country = placeMark.country;
                                      String? street = placeMark.street;
                                      String? address; 
                                      if(appRegion==2){
                                      address= GenericAppFunctions
                                          .removeDuplicateAddress(
                                              "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");  
                                      }
                                      else{
                                      address= GenericAppFunctions
                                          .removeDuplicateAddress(
                                              "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                      }
                                      print("Fucked");
                                      print(address);
                                      String city_name;
                                      String city_name1;

                                      for (var i = 0;
                                          i <
                                              skillCitiesProfessions
                                                  .city.length;
                                          i++) {
                                        city_name = skillCitiesProfessions
                                            .city[i].cityTitle
                                            .toString();
                                            city_name1 = skillCitiesProfessions
                                            .city[i].cityTitle2
                                            .toString();
                                        if (city_name == locality) {
                                          filterCityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          filterCityName = city_name;
                                          print("CityId$filterCityId");
                                        }
                                        else if (city_name1 == locality) {
                                          filterCityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          filterCityName = city_name1;
                                          print("CityId$filterCityId");
                                        }
                                        print("CityName$city_name");
                                      }
                                      setState(() {
                                        filterAddress.text = address!;
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
                          label: "Select City",
                          items: skillCitiesProfessions.city,
                          onChange: (City selectedCity) {
                            setState(() {
                              print("SelectCityId${selectedCity.cityId}");
                              print("SelectCityName${selectedCity.cityTitle}");
                              filterCityId = selectedCity.cityId;
                              filterCityName =
                                  selectedCity.cityTitle.toString();
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
                                      margin: EdgeInsets.only(top: 10),
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
                                    flex: 4,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        filterCityName,
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
                        child: Text('note_address'.tr,
                            style: Styles.noteTextColorAddress),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: AppElevatedButton(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: () async {
                                print("SelectCityId${filterCityId}");
                                print("SelectCityName${filterCityName}");
                                print("PreUpdateAddress");
                                await _appController.updateAddress(
                                    QueryUpdateAddress(
                                        cityId: filterCityId,
                                        fullAddress:
                                            filterAddress.text.toString(),
                                        isServiceProvider: 1,
                                        id: responseLoginUser
                                            .user.serviceProviders.userId,
                                        latitude:
                                            filterSearchLatitude.toString(),
                                        longitude:
                                            filtersearchLongitude.toString()),
                                    apiKey.toString());
                                print("PostUpdateAddress");
                                await _appController.updateProfile(
                                    responseLoginUser.user.id.toString(),
                                    responseLoginUser.user.language,
                                    apiKey.toString());
                                Navigator.pop(context);
                              },
                              child: const Text('Update'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
            );
          }));
        });
  }

  showBottomSheetEditSkill(BuildContext mainContext) {
    print("OpenSheet");
    populateSkillsbottomsheet();
    showModalBottomSheet<void>(
        context: mainContext,
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
                      'add_skill'.tr,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        SelectDialog.showModal<Skill>(
                          context,
                          label: 'select_skills'.tr,
                          items: skillCitiesProfessions.skills,
                          onChange: (Skill skill) {
                            setState(() {
                              if (_selectedSkill.contains(skill)) {
                              } else {
                                if (_selectedSkill.length < 5) {
                                  _selectedSkill.add(skill);
                                } else {
                                  showToast(
                                      "You can not add more then 5 skills",
                                      context: context,
                                      backgroundColor: Colors.blue);
                                }
                              }
                            });
                          },
                        );
                      },
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 230, 230, 230),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/ic_skill_grey.png",
                                  fit: BoxFit.contain,
                                  width: 20,
                                  height: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: const TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        filled: false,
                                        hintText: "Select Skills",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
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
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: <Widget>[
                        for (var skill in _selectedSkill)
                          Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Text(skill.skillName[0].toUpperCase()),
                            ),
                            label: Text(
                              skill.skillName,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 15, 3, 0),
                              ),
                            ),
                            deleteIcon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onDeleted: () {
                              setState(() {
                                _selectedSkill.remove(skill);
                              });
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 189, 188, 188),
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                          )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 40,
                      width: double.infinity,
                      child: Obx(() => AppElevatedButton(
                            borderRadius: BorderRadius.circular(20),
                            onPressed: () async {
                              print("PreUpdateSkill");
                              await _appController.updateUserSkills(
                                  QueryUpdateSkill(
                                      apiKey: responseLoginUser.user.apiPlanText
                                          .toString(),
                                      userId: responseLoginUser
                                          .user.serviceProviders.userId
                                          .toString(),
                                      skills: getSelectedSkillIds()),
                                  apiKey.toString());
                              print("PostUpdateSkill");
                              await _appController.updateProfile(
                                  responseLoginUser.user.serviceProviders.userId
                                      .toString(),
                                  responseLoginUser.user.language,
                                  apiKey.toString());
                              print("AfterUpdatingSkill");
                              Navigator.pop(context);

                              print("AfterPoping");
                            },
                            child: Text(_appController.updatingSkill.value
                                ? 'updating'.tr
                                : 'update'.tr),
                          )),
                    )
                  ],
                ),
              ),
            );
          }));
        });
  }

  void populateSkillsbottomsheet() {
    if (_selectedSkill.isNotEmpty) {
      _selectedSkill.clear();
    }
    print("UserSkillsAre${responseLoginUser.user.skills}");
    final List<String> _jobSKills = [];
    for (var sId in responseLoginUser.user.skills!) {
      int skillIndex = skillCitiesProfessions.skills
          .indexWhere((skill) => skill.skillId == sId);
      print("MySkill${skillIndex}");
      print("SkillFullData");
      _selectedSkill.add(skillCitiesProfessions.skills[skillIndex]);
    }
  }

  List<int> getSelectedSkillIds() {
    List<int> skillIdList = [];
    for (var selectedSkill in _selectedSkill) {
      skillIdList.add(selectedSkill.skillId);
    }
    print("SelectedSkillId${skillIdList.toString()}");
    return skillIdList;
  }

  bool jobSkillAvaialbleInUserSkills() {
    bool skillAvailable = false;
    print("JobsSkills${jobsModel.skillId}");
    print("UserSkills${responseLoginUser.user.skills}");
    if (jobsModel.skillId.isNotEmpty) {
      for (var skillId in responseLoginUser.user.skills!) {
        if (jobsModel.skillId[0] == 26230) {
          skillAvailable = true;
        } else if (jobsModel.skillId.contains(skillId)) {
          skillAvailable = true;
        }
      }
    } else {
      skillAvailable = true;
    }

    return skillAvailable;
  }

  void showAddSkillDialog(
    BuildContext context,
  ) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (BuildContext dialogueContext, __, ___) {
        return Center(
          child: Container(
            height: 200,
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
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'add_skill'.tr,
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
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'add_skill_Alert'.tr,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogueContext);
                            },
                            style: Styles.appElevatedJobStatusButtonStyle,
                            child: Text('decline'.tr)),
                      ),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogueContext);
                              showBottomSheetEditSkill(context);
                            },
                            style: Styles.appElevatedJobStatusButtonStyle,
                            child: Text('add_skill'.tr)),
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

  addMarkerJobMarker(double jobLat, double jobLng) {
    print("AddMarker");
    _markers.add(Marker(
      onTap: (() => {}),
      markerId: MarkerId('JobLocation'),
      position: LatLng(jobLat, jobLng),
      icon: BitmapDescriptor.defaultMarkerWithHue(10.0),
    ));
  }

  Future autoFillLocationFilter() async {
    if (AutoFillAddress.autoLocationAvaviable) {
      filterAddress.text = AutoFillAddress.autoLocationAddress;
      filterSearchLatitude = AutoFillAddress.autoLocationLat;
      filtersearchLongitude = AutoFillAddress.autoLocationLong;
      CityIdName cityIdName = await AutoFillAddress.getCityIdName(
          AutoFillAddress.autoLocationLocality,
          AutoFillAddress.autoLocationSubAdmin,
          skillCitiesProfessions);
      filterCityId = cityIdName.cityId;
      filterCityName = cityIdName.cityName;
    }
  }
}
