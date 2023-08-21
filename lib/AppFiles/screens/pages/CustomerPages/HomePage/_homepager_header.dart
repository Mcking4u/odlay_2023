import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chip_list/chip_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/AutoFillAddress.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationPromt.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/CustomerPersistanceNavbar/CustomerLandingPage.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/home_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_custom_search.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_simple_search_serice_provider.dart';

import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/AppFiles/screens/widgets/Header.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:get/get.dart';

class HomePageHeader extends StatefulWidget {
  bool isCityFilterAvaiable;
  HomePageHeader(this.isCityFilterAvaiable);
  @override
  State<HomePageHeader> createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader>
    with WidgetsBindingObserver {
  late List<String> listBannerImages = [];
  late SkillCitiesProfessions skillCitiesProfessions;
  final List<Skill> _selectedSkill = [];
  List<String> spinnerItems = ['5km', '10km', '15km', '25km', '50km'];
  String dropdownValue = '5km';
  FocusNode searchFocus = FocusNode();
  TextEditingController userAddress = TextEditingController();
  TextEditingController businessName = TextEditingController();
  late int? appRegion;

//controller  city filtert
  TextEditingController filterAddress = TextEditingController();
  late double filterSearchLatitude, filtersearchLongitude;
  String filterCityName = "";
  int filterCityId = 0;

  String cityName = "";
  int cityId = 0;
  late String? apiKey;

  final AppController _appController = Get.find();

  late double searchLatitude, searchLongitude;
  String apiKeyAutoCompleteSearch = 'AIzaSyDjBU-oor10ZAk-cq0CEGOFStPFaRq_T-M';
  late var _places;
  late bool _serviceEnabled;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  late OverlayEntry? overlay1;
  final FocusNode inputFocusNode = FocusNode();
  late StreamSubscription<bool> keyboardSubscription;
//checkpermission
  bool _permissionValid = false;
  late ResponseLoginUser responseLoginUser;
  @override
  void initState() {
    print("PageReload");
    WidgetsBinding.instance.addObserver(this);
    getBannerList();
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    _places = GoogleMapsPlaces(apiKey: apiKeyAutoCompleteSearch);
    appRegion =Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      if (visible == false) {
        hideOverLayEntry();
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("AppTapped");
                maangepermissionCheck();
                _showBottomSheetCityChange(context);
              },
              child: Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(255, 102, 102, 1),
                          Color.fromRGBO(255, 133, 76, 1)
                        ]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                child: SafeArea(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("HeaderClickkked");
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, right: 15),
                          child: GestureDetector(
                            onTap: () {
                              print("MainAreaClciked");
                              if (widget.isCityFilterAvaiable) {
                                _showBottomSheetCityChange(context);
                              } else {
                                showToast(
                                    "Please go to home page and click on the address bar on the top to change your current address",
                                    context: context,
                                    backgroundColor: Colors.blue);
                              }
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print("CityChangeClicked");
                                        if (widget.isCityFilterAvaiable) {
                                          _showBottomSheetCityChange(context);
                                        } else {
                                          showToast(
                                              "Please go to home page and click on the address bar on the top to change your current address",
                                              context: context,
                                              backgroundColor: Colors.blue);
                                        }
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: HeaderFilterConstant
                                                    .defaultCityName,
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            WidgetSpan(
                                              child: widget.isCityFilterAvaiable
                                                  ? Icon(
                                                      Icons.arrow_drop_down,
                                                      size: 20,
                                                      color: Colors.white,
                                                    )
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text("Odlay Services",
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        maxLines: 1,
                                        HeaderFilterConstant.defaultCityAddress,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 35,
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 15),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Autocomplete<Skill>(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          _showOverlay(context);
                                          return const Iterable<Skill>.empty();
                                        }
                                        hideOverLayEntry();

                                        return skillCitiesProfessions.skills
                                            .where((Skill skill) => skill
                                                .skillName
                                                .toLowerCase()
                                                .startsWith(textEditingValue
                                                    .text
                                                    .toLowerCase()))
                                            .toList();
                                      },
                                      displayStringForOption: (Skill option) =>
                                          option.skillName,
                                      fieldViewBuilder: (BuildContext context,
                                          TextEditingController
                                              fieldTextEditingController,
                                          inputFocusNode,
                                          VoidCallback onFieldSubmitted) {
                                        return TextField(
                                          textInputAction:
                                              TextInputAction.search,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.search,
                                                color: Colors.grey),
                                            isDense: true,
                                            hintText:
                                                'Plumber,Electrian,Designer.......',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (String value) {
                                            print("SearcKeyWoird${value}");
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SimpleSearchSericeProvider(
                                                            value.toString(),
                                                            false)));
                                          },
                                          controller:
                                              fieldTextEditingController,
                                          focusNode: inputFocusNode,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                        );
                                      },
                                      onSelected: (Skill selection) {
                                        print(
                                            "SelectUserSkill${selection.skillName}");

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SimpleSearchSericeProvider(
                                                        selection.skillName
                                                            .toString(),
                                                        false)));
                                      },
                                      optionsViewBuilder: (BuildContext context,
                                          AutocompleteOnSelected<Skill>
                                              onSelected,
                                          Iterable<Skill> options) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            child: Container(
                                              width: 300,
                                              color: Colors.white,
                                              child: ListView.builder(
                                                padding: EdgeInsets.all(10.0),
                                                itemCount: options.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final Skill option =
                                                      options.elementAt(index);

                                                  return GestureDetector(
                                                    onTap: () {
                                                      onSelected(option);
                                                    },
                                                    child: ListTile(
                                                      title: Text(
                                                          option.skillName,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showBottomSheetAdvanceSearch(
                                        AppConstants.baseContext, context);
                                  },
                                  child: Container(
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 209, 208, 208),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0)),
                                    ),
                                    child: Image.asset(
                                      "assets/ic_advance_search.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              // ignore: sort_child_properties_last
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 140,
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                      ),
                      items: listBannerImages
                          .cast<String>()
                          .map((item) => ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                child: CachedNetworkImage(
                                  imageUrl: item,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              right: 0,
              left: 0,
              bottom: -100,
            ),
          ],
        ),
      ),
    );
  }

  void getBannerList() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    late ResponseLoginUser responseLoginUser =
        responseLoginUserFromJson(user_data!);
    print("BaannerImages${responseLoginUser.user.bannerImages}");
    for (var bannerImage in responseLoginUser.user.bannerImages) {
      String ImageUrl = "${AppConstants.BANNERIMAGESURLS}$bannerImage.jpg";
      print("BannerImage$ImageUrl");
      listBannerImages.add(ImageUrl);
    }
  }

  _showBottomSheetAdvanceSearch(
      BuildContext context, BuildContext mainContext) async {
    await autoFillLocationCustomSearch();
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
                    Text('title_custom_search_filter'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                color: Color.fromRGBO(255, 118, 87, 1),
                                fontSize: 17,
                                fontWeight: FontWeight.normal))),
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
                                      controller: businessName,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        filled: false,
                                        hintText: 'search_by_b_name'.tr,
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
                    GestureDetector(
                      onTap: () {
                        SelectDialog.showModal<Skill>(
                          context,
                          label: 'select_skills'.tr,
                          items: skillCitiesProfessions.skills,
                          onChange: (Skill skill) {
                            setState(() {
                              if (_selectedSkill.contains(skill)) {
                                print("This skill is already present");
                              } else {
                                if (_selectedSkill.length < 5) {
                                  _selectedSkill.add(skill);
                                } else {
                                  // showSnackBar("You can not add more then 5 skills");
                                }
                              }
                            });
                          },
                        );
                      },
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        margin: const EdgeInsets.only(top: 10),
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
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        filled: false,
                                        hintText: 'select_skills'.tr,
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
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 230, 230, 230),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 0.30),
                        ),
                        child: DropdownButton<String>(
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value.toString();
                            });
                          },
                          value: dropdownValue,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          items: spinnerItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                                              searchLatitude = location.lat;
                                              searchLongitude = location.lng;
                                              try {
                                                List<geocoding.Placemark>
                                                    placemarks = await geocoding
                                                        .placemarkFromCoordinates(
                                                            searchLatitude,
                                                            searchLongitude);
                                                geocoding.Placemark placeMark =
                                                    placemarks.first;
                                                String? name = placeMark.name;
                                                String? street =
                                                    placeMark.street;
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
                                                }
                                                print("Lora");

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
                                                    cityId =
                                                        skillCitiesProfessions
                                                            .city[i].cityId;
                                                    print("CityId$cityId");
                                                  }
                                                  else if (city_name1 == locality ||
                                                      city_name1 ==
                                                          placeMark
                                                              .subAdministrativeArea) {
                                                    cityId =
                                                        skillCitiesProfessions
                                                            .city[i].cityId;
                                                    print("CityId$cityId");
                                                  }
                                                  print("CityName$city_name");
                                                }
                                                setState(() {
                                                  userAddress.text = address!;
                                                });
                                              } catch (e) {
                                                showToast("Exception$e",
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
                                        controller: userAddress,
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
                                    bool locationAgree = false;
                                    if (await Permission.locationWhenInUse
                                        .serviceStatus.isEnabled) {
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

                                      searchLatitude =
                                          _locationData.latitude as double;
                                      searchLongitude =
                                          _locationData.longitude as double;

                                      List<geocoding.Placemark> placemarks =
                                          await geocoding
                                              .placemarkFromCoordinates(
                                                  searchLatitude,
                                                  searchLongitude);
                                      geocoding.Placemark placeMark =
                                          placemarks.first;
                                      String? street = placeMark.street;
                                      String? subLocality =
                                          placeMark.subLocality;
                                      String? locality = placeMark.locality;
                                      String? administrativeArea =
                                          placeMark.administrativeArea;
                                      String? postalCode = placeMark.postalCode;
                                      String? country = placeMark.country;
                                      String? address; 
                                      if(appRegion==2){
address = GenericAppFunctions
                                          .removeDuplicateAddress(
                                              "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality}  ${country}");
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
                                        if (city_name == locality ||
                                            city_name ==
                                                placeMark
                                                    .subAdministrativeArea) {
                                          cityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          cityName = city_name;
                                          print("CityId$cityId");
                                        }
                                         if (city_name1 == locality ||
                                            city_name1 ==
                                                placeMark
                                                    .subAdministrativeArea) {
                                          cityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          cityName = city_name;
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
                                    child: Image.asset(
                                      "assets/ic_pickmylocation.png",
                                      fit: BoxFit.fill,
                                    ),
                                  )))
                        ],
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
                              onPressed: () {
                                _selectedSkill.clear();
                                userAddress.text = "";
                                businessName.text = "";
                                setState(() {});
                              },
                              child: Text('btn_reset'.tr),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: AppElevatedButton(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: () {
                                String selectSkill = "";
                                if (_selectedSkill.isNotEmpty) {
                                  selectSkill =
                                      _selectedSkill[0].skillId.toString();
                                }
                                print(
                                    "CliekdLatLang${searchLatitude}${searchLongitude}");
                                if(userAddress.text.isNotEmpty){
                                Navigator.pop(context);
                                Navigator.of(mainContext)
                                    .push(MaterialPageRoute(
                                  builder: (context) => CustomSearch(
                                      responseLoginUser.user.language
                                          .toString(),
                                      searchLatitude.toString(),
                                      searchLongitude.toString(),
                                      "",
                                      selectSkill,
                                      businessName.text,
                                      int.parse(
                                          dropdownValue.replaceAll("km", ""))),
                                ));
                                }
                                else{
                                  showToast("Please Enter Address",context: context,backgroundColor: Colors.red);
                                }
                              },
                              child: Text('btn_apply'.tr),
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

  void _showOverlay(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);

    overlay1 = OverlayEntry(builder: (context) {
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.02,
        top: MediaQuery.of(context).size.height * 0.19,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.21,
            color: Colors.white,
            child: Material(
              child: GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 3,
                childAspectRatio: (5 / 1),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                //physics:BouncingScrollPhysics(),
                // padding: const EdgeInsets.fromLTRB(2, 2, 10, 0),
                children: skillCitiesProfessions.topSkills
                    .map(
                      (skill) => GestureDetector(
                          onTap: () {
                            hideOverLayEntry();
                            inputFocusNode.unfocus();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SimpleSearchSericeProvider(
                                        skill.skillName.toString().toString(),
                                        false)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(skill.skillName.toString(),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold))),
                            ),
                          )),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );
    });

    overlayState.insertAll([overlay1!]);
  }

  void hideOverLayEntry() {
    if (overlay1 != null) {
      overlay1?.remove();
      overlay1 = null;
    }
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

//filter of city change
  _showBottomSheetCityChange(BuildContext context) async {
//poulate addd
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
                    Text('title_apply_filter'.tr,
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
                                              searchLatitude = location.lat;
                                              searchLongitude = location.lng;
                                              try {
                                                List<geocoding.Placemark>
                                                    placemarks = await geocoding
                                                        .placemarkFromCoordinates(
                                                            searchLatitude,
                                                            searchLongitude);
                                                geocoding.Placemark placeMark =
                                                    placemarks.first;
                                                    print("SelectdLocationFullAddres${placeMark}");
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
                                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality}  ${country}");
                                                }
                                                else{
                                                address=
                                                    GenericAppFunctions
                                                        .removeDuplicateAddress(
                                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                                }
                                                print(
                                                    "FetchAddressINtialls:${placeMark.subAdministrativeArea}");
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
                                                    print("CityId$cityId");
                                                    filterCityName = city_name;
                                                  }
                                                  else if (city_name1 == locality ||
                                                      city_name1 ==
                                                          placeMark
                                                              .subAdministrativeArea) {
                                                    filterCityId =
                                                        skillCitiesProfessions
                                                            .city[i].cityId;
                                                    print("CityId$cityId");
                                                    filterCityName = city_name1;
                                                  }
                                                  print("CityName$city_name");
                                                }
                                                setState(() {
                                                  filterAddress.text = address!;
                                                });
                                              } catch (e) {
                                                showToast("Exception$e",
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
                                    bool locationAgree = false;
                                    print("PermissionGrandted");
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

                                      searchLatitude =
                                          _locationData.latitude as double;
                                      searchLongitude =
                                          _locationData.longitude as double;

                                      List<geocoding.Placemark> placemarks =
                                          await geocoding
                                              .placemarkFromCoordinates(
                                                  searchLatitude,
                                                  searchLongitude);
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
address = GenericAppFunctions
                                          .removeDuplicateAddress(
                                              "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
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
                                          i <
                                              skillCitiesProfessions
                                                  .city.length;
                                          i++) {
                                        city_name = skillCitiesProfessions
                                            .city[i].cityTitle
                                            .toString();
                                        city_name1 = skillCitiesProfessions
                                            .city[i].cityTitle
                                            .toString();    
                                        if (city_name == locality) {
                                          filterCityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          filterCityName = city_name;
                                          print("CityId$cityId");
                                        }
                                        else if (city_name1 == locality) {
                                          filterCityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          filterCityName = city_name1;
                                          print("CityId$cityId");
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
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: AppElevatedButton(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: () {
                                Navigator.pop(context);
                                print("SelectCityId${filterCityId}");
                                print("SelectCityName${filterCityName}");
                                updateFilter();
                              },
                              child: Text('btn_apply'.tr),
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

  void updateFilter() {
    setState(() {
      HeaderFilterConstant.defualtCityId = filterCityId;
      HeaderFilterConstant.defaultCityName = filterCityName.toString();
      HeaderFilterConstant.defaultCityAddress = filterAddress.text.toString();
      LocationConstants.USERCURRENTLATITUDE = searchLatitude;
      LocationConstants.USERCURRENTLONGITUDE = searchLongitude;
      HeaderFilterConstant.isFilterApplied = true;
      if (AppConstants.isSlectedUserCustomer) {
        _appController.getTopRatedSerViceProvider(
            HeaderFilterConstant.defualtCityId.toString(),
            responseLoginUser.user.language.toString(),
            "1",
            apiKey.toString(),
            LocationConstants.USERCURRENTLATITUDE.toString(),
            LocationConstants.USERCURRENTLONGITUDE.toString());
      } else {
        _appController.getLatestJob(
            HeaderFilterConstant.defualtCityId.toString(),
            responseLoginUser.user.language.toString(),
            "1",
            apiKey.toString(),
            LocationConstants.USERCURRENTLATITUDE.toString(),
            LocationConstants.USERCURRENTLONGITUDE.toString());
      }
    });
  }

  void maangepermissionCheck() async {
    userCurrentLocation.Location location = userCurrentLocation.Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionValid = false;
      print("permission_denied");
    } else {
      print("permission_granted");
      _permissionValid = true;
    }
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
    } else if (responseLoginUser.user.consumer.address != null) {
      filterAddress.text = responseLoginUser.user.consumer.address;
      filterSearchLatitude =
          double.parse(responseLoginUser.user.consumer.latitude.toString());
      filtersearchLongitude =
          double.parse(responseLoginUser.user.consumer.longitude.toString());

      filterCityId = responseLoginUser.user.consumer.cityId;
      filterCityName = GenericAppFunctions.getCityNameFromCityId(
          skillCitiesProfessions, responseLoginUser.user.consumer.cityId);
    }
  }

//set customsearch autofill
  Future autoFillLocationCustomSearch() async {
    if (AutoFillAddress.autoLocationAvaviable) {
      userAddress.text = AutoFillAddress.autoLocationAddress;
      searchLatitude = AutoFillAddress.autoLocationLat;
      searchLongitude = AutoFillAddress.autoLocationLong;
      print("AutoLat${searchLatitude}");
      print("AutoLng${searchLongitude}");
      CityIdName cityIdName = await AutoFillAddress.getCityIdName(
          AutoFillAddress.autoLocationLocality,
          AutoFillAddress.autoLocationSubAdmin,
          skillCitiesProfessions);
      cityId = cityIdName.cityId;
      cityName = cityIdName.cityName;
    } else {
      if (AppConstants.isSlectedUserCustomer) {
        if (responseLoginUser.user.consumer.address != null) {
          userAddress.text = responseLoginUser.user.consumer.address;
          searchLatitude =
              double.parse(responseLoginUser.user.consumer.latitude.toString());
          searchLongitude = double.parse(
              responseLoginUser.user.consumer.longitude.toString());

          cityId = responseLoginUser.user.consumer.cityId;
          cityName = GenericAppFunctions.getCityNameFromCityId(
              skillCitiesProfessions, responseLoginUser.user.consumer.cityId);
        }
      } else {
        if (responseLoginUser.user.serviceProviders.address != null) {
          userAddress.text =
              responseLoginUser.user.serviceProviders.address.toString();
          searchLatitude = double.parse(
              responseLoginUser.user.serviceProviders.latitude.toString());
          searchLongitude = double.parse(
              responseLoginUser.user.serviceProviders.longitude.toString());

          cityId = responseLoginUser.user.serviceProviders.cityId;
          cityName = GenericAppFunctions.getCityNameFromCityId(
              skillCitiesProfessions,
              responseLoginUser.user.serviceProviders.cityId);
        }
      }
    }
  }
}
