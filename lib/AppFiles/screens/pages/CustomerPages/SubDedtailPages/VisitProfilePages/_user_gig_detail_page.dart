import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
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
import 'package:odlay_services/AppFiles/model/CreateGigModel/_quer_read_single_gig_detail.dart';
import 'package:odlay_services/AppFiles/model/CreateGigModel/_response_single_gig_detail.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_direct_job_creation.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/FullImageShow.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

import '../../CustomerPersistanceNavbar/CustomerLandingPage.dart';

class UserGigDetailPage extends StatefulWidget {
  String gigId;
  int? gigPrice;
  String serviceId;
  bool is_self;
  UserGigDetailPage(this.gigId, this.serviceId, this.is_self, this.gigPrice);
  @override
  State<UserGigDetailPage> createState() => _UserGigDetailPageState(gigId);
}

class _UserGigDetailPageState extends State<UserGigDetailPage> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  TextEditingController userAddress = TextEditingController();
  late bool _serviceEnabled;
  late int? appRegion;
  String cityName = "";
  int cityId = 0;
  late double userLatitude, userLongitude;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  final AppController _appController = Get.put(AppController());
  late var _places;
  String gigId;
  _UserGigDetailPageState(this.gigId);
  RxInt currentPurchaedQuntity = 1.obs;
  late int? newPrice;
  String apiKeyAutoCompleteSearch = 'AIzaSyDjBU-oor10ZAk-cq0CEGOFStPFaRq_T-M';

  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    _appController.readGigDetail(
        QueryReadSingleGigDetail(
            gigId: gigId, language: responseLoginUser.user.language.toString()),
        apiKey.toString());
    _places = GoogleMapsPlaces(apiKey: apiKeyAutoCompleteSearch);
    appRegion =Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    newPrice = widget.gigPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text("Service Detail"),
        backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: Obx(() {
        if (_appController.readSingleGigDetailValue.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .62,
                      width: double.infinity,
                      color: Color.fromARGB(44, 0, 150, 135),
                    ),
                    _appController.readSingleGigDetail.gigImages != null
                        ? CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: false,
                            ),
                            items: GenericAppFunctions.getGigListFromString(
                                    _appController
                                        .readSingleGigDetail.gigImages)
                                .cast<String>()
                                .map((item) => ClipRRect(
                                      child: GestureDetector(
                                        onTap: () {
                                          print("ImageClick");
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SimplePhotoViewPage(
                                                          item)));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: item,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        : Positioned(
                            child: _appController.readSingleGigDetail.skills !=
                                        null &&
                                    _appController
                                        .readSingleGigDetail.skills!.isNotEmpty
                                ? Image.network(
                                    AppConstants.IMAGESLIBRARYURLS +
                                        _appController
                                            .readSingleGigDetail.skills![0].gid!
                                            .toLowerCase()
                                            .replaceAll(" ", "") +
                                        ".jpg",
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/test_gig_image.jpg",
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      );
                                    },
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                : Image.asset(
                                    "assets/test_gig_image.jpg",
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  )),
                    Positioned(
                        right: 10,
                        child: Container(
                          height: 60,
                          width: 120,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/price_bg.png"),
                            fit: BoxFit.fill,
                          )),
                          child: Center(
                            child: Text(
                              responseLoginUser.user.currencySymbol.toString() +
                                  _appController.readSingleGigDetail.gigPrice
                                      .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .18,
                  right: 0.0,
                  left: 0.0),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 35),
                      padding: const EdgeInsets.only(top: 40),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      child: SingleChildScrollView(
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        _appController
                                            .readSingleGigDetail.gigTitle
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/ic_share_flutter.png",
                                          fit: BoxFit.contain,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          height: 30,
                                          width: 60,
                                          child: Image.asset(
                                              "assets/ic_share_fb.png"),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _appController.readSingleGigDetail.gigDetail
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              child: Image.network(
                                                AppConstants.PROFILEIMAGESURLS +
                                                    _appController
                                                        .readSingleGigDetail
                                                        .logo
                                                        .toString(),
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  _appController
                                                      .readSingleGigDetail
                                                      .firstName
                                                      .toString(),
                                                  style:
                                                      Styles.textStyleGigTitle),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: RatingBarIndicator(
                                                  rating: _appController
                                                              .readSingleGigDetail
                                                              .rating !=
                                                          null
                                                      ? double.parse(
                                                          _appController
                                                              .readSingleGigDetail
                                                              .rating
                                                              .toString())
                                                      : 0,
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.orange[900],
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 12.0,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/ic_skills.png",
                                                    fit: BoxFit.contain,
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text("Skills",
                                                        style: Styles
                                                            .profileHeadings),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _appController.readSingleGigDetail
                                                                  .skills !=
                                                              null &&
                                                          _appController
                                                              .readSingleGigDetail
                                                              .skills!
                                                              .isNotEmpty
                                                      ? getSkillName(_appController
                                                              .readSingleGigDetail
                                                              .skills)
                                                          .substring(1)
                                                      : "",
                                                  style:
                                                      Styles.textProfileStyle1,
                                                ),
                                              ),
                                            ),
                                            widget.is_self
                                                ? Container()
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Text("Service Quantity",
                                                            style: Styles
                                                                .profileHeadings),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (currentPurchaedQuntity >=
                                                                  2) {
                                                                currentPurchaedQuntity--;
                                                                newPrice = _appController
                                                                        .readSingleGigDetail
                                                                        .gigPrice! *
                                                                    currentPurchaedQuntity
                                                                        .value;
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Image.asset(
                                                              "assets/ic_sqr-bg-minus.png",
                                                              fit: BoxFit
                                                                  .contain,
                                                              width: 5,
                                                              height: 10,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            currentPurchaedQuntity
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              currentPurchaedQuntity++;
                                                              newPrice = _appController
                                                                      .readSingleGigDetail
                                                                      .gigPrice! *
                                                                  currentPurchaedQuntity
                                                                      .value;
                                                            });
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Image.asset(
                                                              "assets/ic_sqr-bg-plus.png",
                                                              fit: BoxFit
                                                                  .contain,
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            // Container(
                                            //   margin: const EdgeInsets.only(
                                            //       top: 10),
                                            //   child: Align(
                                            //     alignment: Alignment.centerLeft,
                                            //     child: Text(
                                            //       "Odlay Fee",
                                            //       style:
                                            //           Styles.textStyleGigTitle,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Container(
                                            //   margin: const EdgeInsets.only(
                                            //       top: 10),
                                            //   child: Align(
                                            //     alignment: Alignment.centerLeft,
                                            //     child: widget.is_self
                                            //         ? Text(
                                            //             _appController
                                            //                         .readSingleGigDetail
                                            //                         .gigPrice !=
                                            //                     null
                                            //                 ? calculateOdlayFeeSp(
                                            //                     _appController
                                            //                         .readSingleGigDetail
                                            //                         .gigPrice,
                                            //                     currentPurchaedQuntity
                                            //                         .value)
                                            //                 : "",
                                            //             style: const TextStyle(
                                            //                 color: Colors.black,
                                            //                 fontSize: 18,
                                            //                 fontWeight:
                                            //                     FontWeight
                                            //                         .bold),
                                            //           )
                                            //         : Text(
                                            //             _appController
                                            //                         .readSingleGigDetail
                                            //                         .gigPrice !=
                                            //                     null
                                            //                 ? calculateOdlayFee(
                                            //                     _appController
                                            //                         .readSingleGigDetail
                                            //                         .gigPrice,
                                            //                     currentPurchaedQuntity
                                            //                         .value)
                                            //                 : "",
                                            //             style: const TextStyle(
                                            //                 color: Colors.black,
                                            //                 fontSize: 18,
                                            //                 fontWeight:
                                            //                     FontWeight
                                            //                         .bold),
                                            //           ),
                                            //   ),
                                            // ),
                                            widget.is_self
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "Receivable Amout",
                                                              style: Styles
                                                                  .textStyleGigTitle),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              _appController
                                                                          .readSingleGigDetail
                                                                          .gigPrice !=
                                                                      null
                                                                  ? receiveAbleAmount(
                                                                      _appController
                                                                          .readSingleGigDetail
                                                                          .gigPrice,
                                                                      currentPurchaedQuntity
                                                                          .value)
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(),

                                          ],
                                        ))
                                  ],
                                ),
                              ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10,left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  widget.is_self?
                                  sprintf(
                                    responseLoginUser.user.spMessages.sp_gig_info.message,
                                      [(double.parse(responseLoginUser.user.spfee.toString())*100).toString()+" %"]
                                  ):
                                  sprintf(
                                      responseLoginUser.user.custMessages.cust_gig_info.message,
                                      [(double.parse(responseLoginUser.user.custfee.toString())*100).toString()+" %"]
                                  ),
                                  style:
                                  Styles.sp_note_style),
                            ),
                          ),
                              widget.is_self
                                  ? Container()
                                  : Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 20, 10, 10),
                                      height: 40,
                                      width: double.infinity,
                                      child: AppElevatedButton(
                                        borderRadius: BorderRadius.circular(20),
                                        onPressed: () {
                                          addressBottomSheet(context);
                                        },
                                        child: Text(
                                          'Hire ${_appController.readSingleGigDetail.firstName}: ${calculatedPrice(_appController.readSingleGigDetail.gigPrice, currentPurchaedQuntity.value)}',
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                    _appController.readSingleGigDetail.gigImages != null
                        ? Positioned(
                            child: Container(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(10.0),
                              itemCount:
                                  GenericAppFunctions.getGigListFromString(
                                          _appController
                                              .readSingleGigDetail.gigImages)
                                      .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: Image.network(
                                          fit: BoxFit.fill,
                                          width: 50,
                                          height: 80,
                                          GenericAppFunctions
                                              .getGigListFromString(
                                                  _appController
                                                      .readSingleGigDetail
                                                      .gigImages)[index]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ))
                        : Container()
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  // String populateSkillName(List<GigSkill>? gigSkills) {
  //   String SkillName = "";
  //   for (var skill in gigSkills!) {
  //     SkillName = SkillName + "," + skill.title.toString();
  //   }
  //   return SkillName;
  // }
  addressBottomSheet(BuildContext context) async {
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
                                    readOnly: true,
                                    minLines: 1,
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
                                            String? subLocality =
                                                placeMark.subLocality;
                                            String? locality =
                                                placeMark.locality;
                                            String? administrativeArea =
                                                placeMark.administrativeArea;
                                            String? postalCode =
                                                placeMark.postalCode;
                                            String? country = placeMark.country;
                                            String? street = placeMark.street;
                                            String? address; 
                                            if(appRegion==2){
address= GenericAppFunctions
                                                .removeDuplicateAddress(
                                                    "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
                                            ;
                                            }
                                            else{
                                            address= GenericAppFunctions
                                                .removeDuplicateAddress(
                                                    "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                            ;
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
                                                cityId = skillCitiesProfessions
                                                    .city[i].cityId;
                                                print("CityId$cityId");
                                                cityName = city_name;
                                              }
                                              else if (city_name1 == locality ||
                                                  city_name1 ==
                                                      placeMark
                                                          .subAdministrativeArea) {
                                                cityId = skillCitiesProfessions
                                                    .city[i].cityId;
                                                print("CityId$cityId");
                                                cityName = city_name1;
                                              }
                                              print("CityName$city_name");
                                            }
                                            setState(() {
                                              userAddress.text = address!;
                                            });
                                          } catch (e) {
                                            showToast("Exception$e",
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
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: "Enter Address",
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
                                    }
                                    else{
                                   address = GenericAppFunctions
                                        .removeDuplicateAddress(
                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                    print("Fucked");
                                    }
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
                                          .city[i].cityTitle
                                          .toString();
                                      if (city_name == locality ||
                                          city_name ==
                                              placeMark.subAdministrativeArea) {
                                        cityId = skillCitiesProfessions
                                            .city[i].cityId;
                                        cityName = city_name;
                                        print("CityId$cityId");
                                      }
                                      else if (city_name1 == locality ||
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
                    Container(
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
                                            "assets/ic_skill_grey.png",
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
                    Container(
                      margin: const EdgeInsets.all(20),
                      height: 40,
                      width: double.infinity,
                      child: SizedBox(
                        height: 30,
                        child: AppElevatedButton(
                            onPressed: () async {
                              String chatMessageCurrent;
                              String chatMessageOther;

                              chatMessageCurrent = sprintf(
                                  GetChatMessageJob().getChatMessage(
                                      FireBaseConstants
                                          .gigInviteCurrentUserMessage),
                                  [
                                    _appController
                                        .readSingleGigDetail.firstName,
                                    _appController.readSingleGigDetail.title,
                                    currentPurchaedQuntity,
                                    newPrice
                                  ]);

                              chatMessageOther = sprintf(
                                  GetChatMessageJob().getChatMessage(
                                      FireBaseConstants
                                          .gigInviteOtherUserMessage),
                                  [
                                    _appController.readSingleGigDetail.gigTitle,
                                    responseLoginUser.user.firstName,
                                    currentPurchaedQuntity,
                                    newPrice
                                  ]);
                              print("HiredServiceCurrent${chatMessageCurrent}");
                              print("HiredServiceOther${chatMessageOther}");
                              print(
                                  "UUIDCurrent${responseLoginUser.user.firebaseUid.toString()}");
                              print(
                                  "UUIDOther${_appController.readSingleGigDetail.firebaseUid.toString()}");
                              await _appController.directJobCreation(
                                  QueryDirectJobCreation(
                                      address: userAddress.text.toString(),
                                      apiKey: apiKey.toString(),
                                      budget: _appController
                                          .readSingleGigDetail.gigPrice
                                          .toString(),
                                      consumerId: responseLoginUser
                                          .user.consumer.userId
                                          .toString(),
                                      gigId: _appController
                                          .readSingleGigDetail.gigId
                                          .toString(),
                                      gigQty: currentPurchaedQuntity.value,
                                      detail: _appController
                                          .readSingleGigDetail.gigDetail,
                                      cityId: cityId,
                                      latitude: userLatitude,
                                      longitude: userLongitude,
                                      serviceId: widget.serviceId,
                                      status: JobConstants.INVITED_FOR_JOB,
                                      title: _appController
                                          .readSingleGigDetail.gigTitle,
                                          skillId: ""),
                                  apiKey.toString(),
                                  responseLoginUser.user.firebaseUid.toString(),
                                  _appController.readSingleGigDetail.firebaseUid
                                      .toString(),
                                  chatMessageCurrent,
                                  FireBaseConstants.applyJobReward,
                                  responseLoginUser.user.firstName.toString(),
                                  chatMessageOther,
                                  context);
                              if (_appController.responseDirectJobCreation !=
                                  null) {
                                Navigator.pop(context);
                                showToast("Gig has been Hired",
                                    context: context,
                                    backgroundColor: Colors.green);
                                Navigator.pushAndRemoveUntil(
                                        AppConstants.baseContext,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerLandingPage(2)),
                                        (Route<dynamic> route) => false,
                                      );
                              }
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Text('Proceed',
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)))),
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        });
  }

  String calculateOdlayFee(int? gigPrice, int quantity) {
    String odlayFee = "";
    int? newPrice = gigPrice! * quantity;
    double amount = double.parse(responseLoginUser.user.custfee.toString()) *
        double.parse(newPrice.toString());
    odlayFee = responseLoginUser.user.currencySymbol.toString() +
        amount.ceil().toString();
    return odlayFee;
  }

  String receiveAbleAmount(int? gigPrice, int quantity) {
    String receiveAble = "";
    int? newPrice = gigPrice! * quantity;
    double amount = double.parse(responseLoginUser.user.spfee.toString()) *
        double.parse(newPrice.toString());
    receiveAble = responseLoginUser.user.currencySymbol.toString() +
        (newPrice - amount).floor().toString();
    return receiveAble;
  }

  String calculateOdlayFeeSp(int? gigPrice, int quantity) {
    String odlayFee = "";
    int? newPrice = gigPrice! * quantity;
    double amount = double.parse(responseLoginUser.user.spfee.toString()) *
        double.parse(newPrice.toString());
    odlayFee = responseLoginUser.user.currencySymbol.toString() +
        amount.ceil().toString();
    return odlayFee;
  }

  double odlyFeePrice(int? gigPrice, int quantity) {
    double odlayFee;
    int? newPrice = gigPrice! * quantity;
    double amount = double.parse(responseLoginUser.user.custfee.toString()) *
        double.parse(newPrice.toString()).ceil();
    odlayFee = amount;
    return odlayFee;
  }

  String getSkillName(List<SingleGigSkill>? SingleGigskills) {
    String skillName = "";
    for (var skill in SingleGigskills!) {
      skillName = skillName + "," + skill.skillName.toString();
    }
    if (skillName.isNotEmpty) {
      skillName.substring(1);
    }

    return skillName;
  }

  String calculatedPrice(int? price, int quantity) {
    return responseLoginUser.user.currencySymbol.toString() +
        "${(price! * quantity) + odlyFeePrice(_appController.readSingleGigDetail.gigPrice, currentPurchaedQuntity.value).ceil()}";
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
    } else if (responseLoginUser.user.consumer.address != null) {
      userAddress.text = responseLoginUser.user.consumer.address;
      userLatitude =
          double.parse(responseLoginUser.user.consumer.latitude.toString());
      userLongitude =
          double.parse(responseLoginUser.user.consumer.longitude.toString());

      cityId = responseLoginUser.user.consumer.cityId;
      cityName = GenericAppFunctions.getCityNameFromCityId(
          skillCitiesProfessions, responseLoginUser.user.consumer.cityId);
    }
  }
}
