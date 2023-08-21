import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AutoFillAddress.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/GetChatMessagesJob.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationPromt.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/PostJobModel/_querypostjob.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_direct_job_creation.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/CustomerPersistanceNavbar/CustomerLandingPage.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart' as mainSkill;

import '../../../../../Utility/AppConstants.dart';
import '../../../../../Utility/CameraPromt.dart';


class BodyDirectHire extends StatefulWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  BodyDirectHire(this._resposneServiceProviderProfile);
  @override
  State<BodyDirectHire> createState() => _BodyDirectHireState();
}

class _BodyDirectHireState extends State<BodyDirectHire> {
  late var _places;
  late bool _serviceEnabled;
  bool jobValuePrivate = false;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  final AppController _appController = Get.put(AppController());
  TextEditingController jobTitle = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  TextEditingController jobBudget = TextEditingController();
  TextEditingController jobAddress = TextEditingController();
  String job_deadline = "Select Date";
  bool isJobDealineChanged = false;
  String apiKeyAutoCompleteSearch = 'AIzaSyDjBU-oor10ZAk-cq0CEGOFStPFaRq_T-M';
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  String? jobType = "Open";

  String dropdownValue = 'Male';
  List<String> spinnerItems = ['Male', 'Female'];
  late double jobLatitude, jobLongitude;
  String cityName = "";
  int cityId = 0;
  bool showAdvance = false;
  int? appRegion;
  final List<mainSkill.Skill> _selectedSkill = [];
  final ImagePicker imagePicker = ImagePicker();
  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];

  @override
  void initState() {
    _places = GoogleMapsPlaces(apiKey: apiKeyAutoCompleteSearch);
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    autoFillLocationFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
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
                                textAlignVertical: TextAlignVertical.center,
                                controller: jobTitle,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  filled: false,
                                  hintText: 'job_title'.tr,
                                  hintStyle: TextStyle(color: Colors.grey),
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
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Image.asset(
                            "assets/ic_description.png",
                            fit: BoxFit.contain,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: jobDescription,
                              maxLines: 5,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                filled: false,
                                hintText: 'job_desc'.tr,
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
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
                          appRegion == 2
                              ? "assets/ic_euro.png"
                              : "assets/ic_pkr_grey.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: jobBudget,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                filled: false,
                                hintText: 'apply_enter_job_budget'.tr,
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    SelectDialog.showModal<mainSkill.Skill>(
                      context,
                      label: 'select_skills'.tr,
                      items: skillCitiesProfessions.skills,
                      onChange: (mainSkill.Skill skill) {
                        setState(() {
                          if (_selectedSkill.contains(skill)) {
                            print("This skill is already present");
                          } else {
                            if (_selectedSkill.length < 5) {
                              _selectedSkill.add(skill);
                            } else {
                              showSnackBar(
                                  "You can not add more then 5 skills");
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
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    filled: false,
                                    hintText: 'select_skills'.tr,
                                    hintStyle: TextStyle(color: Colors.grey),
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
                chipList(),
              Container(
                height: 40,
                padding: EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(top: 20),
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
                                        new Component(Component.country, "pk"),
                                        new Component(Component.country, "fi")
                                      ],
                                    );
                                    if (p != null) {
                                      if (p.placeId.toString().isNotEmpty) {
                                        PlacesDetailsResponse response =
                                            await _places.getDetailsByPlaceId(
                                                p.placeId.toString());
                                        var location =
                                            response.result.geometry!.location;
                                        print("AddressSelected${location}");
                                        jobLatitude = location.lat;
                                        jobLongitude = location.lng;
                                        manipulateCityAndAdress();
                                      } else {
                                        showToast("No Address Selected",
                                            context: context,
                                            backgroundColor: Colors.lightBlue);
                                      }
                                    }
                                  },
                                  controller: jobAddress,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    filled: false,
                                    hintText: 'select_address'.tr,
                                    hintStyle: TextStyle(color: Colors.grey),
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
                                _getUserLocation();
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
                        print("SelectCityName${selectedCity.cityTitle}");
                        cityId = selectedCity.cityId;
                        cityName = selectedCity.cityTitle.toString();
                      });
                    },
                  );
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 230, 230, 230),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Radio(
                            value: "Open",
                            groupValue: jobType,
                            onChanged: (value) {
                              setState(() {
                                jobType = value.toString();
                              });
                            },
                          ),
                        ),
                        Text('str_radio_open_job'.tr)
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: "Private",
                          groupValue: jobType,
                          onChanged: (value) {
                            setState(() {
                              jobType = value.toString();
                            });
                          },
                        ),
                        Text('str_radio_private_job'.tr)
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (showAdvance) {
                      showAdvance = false;
                    } else {
                      showAdvance = true;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'advance_options'.tr,
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              showAdvance
                  ? Container(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _presentDatePicker();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/ic_date_calender.png",
                                        fit: BoxFit.contain,
                                        width: 20,
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            job_deadline,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
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
                          GestureDetector(
                              onTap: () {
                                print("OpenImagePicker");
                                _showBottomSheetImageSelction();
                              },
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, bottom: 5),
                                margin: const EdgeInsets.only(top: 20),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/ic_attach_img.png",
                                          fit: BoxFit.contain,
                                          width: 20,
                                          height: 20,
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'attach_images'.tr,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
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
                                margin: const EdgeInsets.only(top: 10),
                                child: compressedImages.length > 0
                                    ? GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: compressedImages.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.file(
                                                    compressedImages[index],
                                                    fit: BoxFit.cover),
                                              ),
                                              Positioned(
                                                  right: 20,
                                                  top: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          "Delete this image");
                                                      compressedImages.remove(
                                                          compressedImages[
                                                              index]);
                                                      setState(() {});
                                                    },
                                                    child: Image.asset(
                                                      "assets/ic_cross_flutter_white.png",
                                                      fit: BoxFit.contain,
                                                      width: 30,
                                                      height: 30,
                                                      color: Colors.red,
                                                    ),
                                                  ))
                                            ],
                                          );
                                        })
                                    : Container())
                        ],
                      ),
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Obx(() => AppElevatedButton(
                      width: double.infinity,
                      onPressed: () async {
//make chat messages

                        if (jobTitle.text.isEmpty) {
                          showSnackBar("Please enter job title");
                        } else if (jobAddress.text.isEmpty) {
                          showSnackBar("Please enter job adress");
                        } else if (jobBudget.text.isNotEmpty) {
                          if (int.parse(jobBudget.text.toString()) <
                              int.parse(responseLoginUser.user.min_amount
                                  .toString())) {
                            showSnackBar(
                                "minimum budget amount is ${responseLoginUser.user.min_amount}");
                            return;
                          } else if (int.parse(jobBudget.text.toString()) >
                              int.parse(responseLoginUser.user.max_amount
                                  .toString())) {
                            showSnackBar(
                                "max budget amount is ${responseLoginUser.user.max_amount}");
                            return;
                          } else {
                            print("DirectHireWithAmount");
                            proceedDirectHire();
                          }
                        } else {
                          print("DirectHireWithoutAmount");
                          proceedDirectHire();
// Get.to(CustomerLandingPage(2));

                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Text(
                          _appController.responsePostJobLoading.value
                              ? 'str_hiring'.tr
                              : 'str_direct_hire'.tr +
                                  '${widget._resposneServiceProviderProfile.firstName}',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                    )),
              )
            ],
          )),
    );
  }

  void manipulateCityAndAdress() async {
    bool cityFound = false;
    try {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(jobLatitude, jobLongitude);
      geocoding.Placemark placeMark = placemarks.first;
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? country = placeMark.country;
      String? street = placeMark.street;
      String? address;
      if(appRegion==2){
address = GenericAppFunctions.removeDuplicateAddress(
          "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
      }
      else{
      address = GenericAppFunctions.removeDuplicateAddress(
          "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
      print("Lora");
      }
      print(address);
      // jobAddress.text = address.toString();
      for (var i = 0; i < skillCitiesProfessions.city.length; i++) {
        String city_name = skillCitiesProfessions.city[i].cityTitle.toString();
        String city_name1 = skillCitiesProfessions.city[i].cityTitle2.toString();
        if (city_name == locality ||
            city_name == placeMark.subAdministrativeArea) {
          cityId = skillCitiesProfessions.city[i].cityId;
          cityFound = true;
          cityName = city_name;
          print("CityId$cityId");
        }
        else if (city_name1 == locality ||
            city_name1 == placeMark.subAdministrativeArea) {
          cityId = skillCitiesProfessions.city[i].cityId;
          cityFound = true;
          cityName = city_name1;
          print("CityId$cityId");
        }
        // if (cityFound) {
        //   cityName = city_name;
        // }
        print("CityName$city_name");
      }
      setState(() {
        jobAddress.text = address!;
      });
    } catch (e) {
      showToast("Exception$e", backgroundColor: Colors.blue);
    }
  }

  Future<void> _getUserLocation() async {
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

    jobLatitude = _locationData.latitude as double;
    jobLongitude = _locationData.longitude as double;

    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(jobLatitude, jobLongitude);
    geocoding.Placemark placeMark = placemarks.first;

    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? street = placeMark.street;
    String? address; 
    if(appRegion==2){
address= GenericAppFunctions.removeDuplicateAddress(
        "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality}  ${country}");
    }
    else{
    address= GenericAppFunctions.removeDuplicateAddress(
        "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
    print("Fucked");
    }
    print(address);
    String city_name;
    String city_name1;

    for (var i = 0; i < skillCitiesProfessions.city.length; i++) {
      city_name = skillCitiesProfessions.city[i].cityTitle.toString();
      city_name1 = skillCitiesProfessions.city[i].cityTitle2.toString();
      if (city_name == locality ||
          city_name == placeMark.subAdministrativeArea) {
        cityId = skillCitiesProfessions.city[i].cityId;
        cityName = city_name;
        print("CityId$cityId");
      }
      else if (city_name1 == locality ||
          city_name1 == placeMark.subAdministrativeArea) {
        cityId = skillCitiesProfessions.city[i].cityId;
        cityName = city_name1;
        print("CityId$cityId");
      }
      print("CityName$city_name");
    }
    setState(() {
      jobAddress.text = address!;
    });
  }

  void showSnackBar(String snackMsg) {
    final snackBar = SnackBar(
      content: Text(snackMsg),
      backgroundColor: (Colors.red),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _presentDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // using state so that the UI will be rerendered when date is picked
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        job_deadline = formattedDate.toString();
        isJobDealineChanged = true;
      });
    });
  }

  Future autoFillLocationFilter() async {
    if (AutoFillAddress.autoLocationAvaviable) {
      jobAddress.text = AutoFillAddress.autoLocationAddress;
      jobLatitude = AutoFillAddress.autoLocationLat;
      jobLongitude = AutoFillAddress.autoLocationLong;
      CityIdName cityIdName = await AutoFillAddress.getCityIdName(
          AutoFillAddress.autoLocationLocality,
          AutoFillAddress.autoLocationSubAdmin,
          skillCitiesProfessions);
      cityId = cityIdName.cityId;
      cityName = cityIdName.cityName;
      setState(() {});
    } else if (responseLoginUser.user.consumer.address != null) {
      jobAddress.text = responseLoginUser.user.consumer.address;
      jobLatitude =
          double.parse(responseLoginUser.user.consumer.latitude.toString());
      jobLongitude =
          double.parse(responseLoginUser.user.consumer.longitude.toString());

      cityId = responseLoginUser.user.consumer.cityId;
      cityName = GenericAppFunctions.getCityNameFromCityId(
          skillCitiesProfessions, responseLoginUser.user.consumer.cityId);
      setState(() {});
    }
  }

  void proceedDirectHire() async {
    String chatMessageCurrent;
    String chatMessageOther;

    chatMessageCurrent = sprintf(
        GetChatMessageJob().getChatMessage(
            FireBaseConstants.CU_INVITE_ON_JOB_CURRENT_USER_MESSAGE),
        [widget._resposneServiceProviderProfile.firstName, jobTitle.text]);

    chatMessageOther = sprintf(
        GetChatMessageJob().getChatMessage(
            FireBaseConstants.CU_INVITE_ON_JOB_OTHER_USER_MESSAGE),
        [responseLoginUser.user.firstName, jobTitle.text]);
    int jobPrivacy;
    if (jobType == "Private") {
      jobPrivacy = 1;
    } else {
      jobPrivacy = 2;
    }
    print("JobHireDirect${jobPrivacy}");
    await _appController.directJobCreation(
        QueryDirectJobCreation(
            address: jobAddress.text.toString(),
            apiKey: apiKey,
            budget: jobBudget.text.toString(),
            consumerId: responseLoginUser.user.consumer.userId.toString(),
            detail: jobDescription.text.toString(),
            cityId: cityId,
            latitude: jobLatitude,
            longitude: jobLongitude,
            serviceId: widget._resposneServiceProviderProfile.id.toString(),
            status: JobConstants.INVITED_FOR_JOB,
            title: jobTitle.text.toString(),
            job_privacy: jobPrivacy,
            deadline: isJobDealineChanged ? job_deadline : "",
            skillId: getSelectedSkillIds()),
        apiKey.toString(),
        responseLoginUser.user.firebaseUid.toString(),
        widget._resposneServiceProviderProfile.firebaseUid.toString(),
        chatMessageCurrent,
        FireBaseConstants.applyJobReward,
        responseLoginUser.user.firstName.toString(),
        chatMessageOther,
        context);
    if (_appController.responseDirectJobCreation != null) {
      if(_appController.responseDirectJobCreation.status.toString()=="success"){
        if (compressedImages.isNotEmpty) {
       _appController.uploadImages(
                _appController.responseDirectJobCreation.jobId.toString(),
                AppConstants.IMAGETYPEJOBS,
                "",
                apiKey.toString(),
                compressedImages);
        }
      showToast("User Hired Successfull",
          context: context, backgroundColor: Colors.green);
      Navigator.pushAndRemoveUntil(
                                        AppConstants.baseContext,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerLandingPage(2)),
                                        (Route<dynamic> route) => false,
                                      );
      }
    }
  }
   chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: <Widget>[
        for (var skill in _selectedSkill)
          _buildChip(skill, Color.fromARGB(255, 189, 188, 188)),
      ],
    );
  }
  Widget _buildChip(mainSkill.Skill skill_label, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(skill_label.skillName[0].toUpperCase()),
      ),
      label: Text(
        skill_label.skillName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      deleteIcon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onDeleted: () {
        setState(() {
          _selectedSkill.remove(skill_label);
        });
      },
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
    );
  }
  _showBottomSheetImageSelction() {
    showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // selectImages();
                      pickImages();
                    },
                    child: const ListTile(
                      title: Text("Gallery"),
                      leading: Icon(Icons.image),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () async {
                      bool cameraAgree = false;
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
                      if (cameraAgree) {
                        Navigator.pop(context);
                        launchCamera();
                      }
                    },
                    child: ListTile(
                      title: Text("Camera"),
                      leading: Icon(Icons.camera),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
   void launchCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return;
      } else {
        print("ImagesSlected");
        final imageTemp = File(image.path);
        // compressImage(image.path);
        compressedImages.add(imageTemp);
        setState(() {});
      }
    } on PlatformException catch (e) {
      print('Failedto pick image: $e');
    }
  }
   pickImages() async {
    print("ShowMeGallery");
    try {
      final pickedImages = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (pickedImages != null && pickedImages.files.isNotEmpty) {
        final image = pickedImages.files.map((e) => e.path!);
        selectedImages.addAll(image);
        temporaryImages.addAll(image);

        for (int i = 0; i < temporaryImages.length; i++) {
          compressImage(temporaryImages[i]);
        }

        Future.delayed(
            const Duration(seconds: 1), () => temporaryImages.clear());
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  compressImage(path) async {
    if (selectedImages.isEmpty) return;
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(path);
    await FlutterNativeImage.compressImage(path,
            quality: 50,
            targetWidth: 600,
            targetHeight:
                (properties.height! * 600 / (properties.width)!).round())
        .then((response) => setState(() => compressedImages.add(response)))
        .catchError((e) => debugPrint("ExceptioonCompresson"));
  }
  String getSelectedSkillIds() {
    String skillIds = "";
    List<int> skillIdList = [];
    for (var selectedSkill in _selectedSkill) {
      skillIdList.add(selectedSkill.skillId);
    }
    skillIds = skillIdList.toString();
    print("SelectedSkillId${skillIdList.toString()}");
    return skillIds;
  }
}
