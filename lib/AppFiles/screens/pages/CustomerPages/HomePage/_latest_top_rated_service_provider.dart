import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_response_featured_gigs.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_service_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_view_all_service_provider.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/visit_service_provider_profile_tabs.dart';
import 'package:odlay_services/Styles/styles.dart';

class LatestTopRatedServiceProvider extends StatefulWidget {
  @override
  State<LatestTopRatedServiceProvider> createState() =>
      _LatestTopRatedServiceProviderState();
}

class _LatestTopRatedServiceProviderState
    extends State<LatestTopRatedServiceProvider> {
  final AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  int? appRegion;
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    responseLoginUser = responseLoginUserFromJson(userData!);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    print("SavedKey${apiKey}");
    print("LatestJobLatitude${LocationConstants.USERCURRENTLATITUDE}");
    print("LatestJobLongitude${LocationConstants.USERCURRENTLONGITUDE}");

    _appController.getTopRatedSerViceProvider(
        HeaderFilterConstant.defualtCityId.toString(),
        responseLoginUser.user.language.toString(),
        "1",
        apiKey.toString(),
        LocationConstants.USERCURRENTLATITUDE.toString(),
        LocationConstants.USERCURRENTLONGITUDE.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'top_rated_professionals'.tr,
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: () {
                    print("ViewAllServiceProvider");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewAllServiceProvider()));
                  },
                  child: Text(
                    'view_all'.tr,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          Obx(() {
            if (_appController.isLoadingTopRatedServiceProvider.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return _appController
                            .topRatedServiceProviders!.serviceproviders.data !=
                        null &&
                    _appController.topRatedServiceProviders!.serviceproviders
                        .data.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _appController
                        .topRatedServiceProviders!.serviceproviders.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          var serviceProvider = _appController
                              .topRatedServiceProviders!
                              .serviceproviders
                              .data[index];
                          print("UserName${serviceProvider.firstName}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProfileLandingVisitPage(serviceProvider)));
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 60,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(AppConstants
                                                                .PROFILEIMAGESURLS +
                                                            _appController
                                                                .topRatedServiceProviders!
                                                                .serviceproviders
                                                                .data[index]
                                                                .logo
                                                                .toString()),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            height: 60,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _appController
                                                          .topRatedServiceProviders!
                                                          .serviceproviders
                                                          .data[index]
                                                          .firstName
                                                          .toString(),
                                                      style: GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .orange[900],
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        maxLines: 1,
                                                        _appController
                                                                    .topRatedServiceProviders!
                                                                    .serviceproviders
                                                                    .data[index]
                                                                    .skills !=
                                                                null
                                                            ? GenericAppFunctions.getSkillNameFromSkillList(
                                                                    _appController
                                                                        .topRatedServiceProviders!
                                                                        .serviceproviders
                                                                        .data[
                                                                            index]
                                                                        .skills)
                                                                .substring(1)
                                                            : "",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                textStyle:
                                                                    const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ))),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        maxLines: 1,
                                                        _appController
                                                            .topRatedServiceProviders!
                                                            .serviceproviders
                                                            .data[index]
                                                            .address
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.roboto(
                                                                textStyle:
                                                                    const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10,
                                                        ))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: RatingBarIndicator(
                                            rating: _appController
                                                        .topRatedServiceProviders!
                                                        .serviceproviders
                                                        .data[index]
                                                        .rating !=
                                                    null
                                                ? double.parse(_appController
                                                    .topRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[index]
                                                    .rating
                                                    .toString())
                                                : 0,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.orange[900],
                                            ),
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 5, right: 5),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                maxLines: 1,
                                                "${_appController.topRatedServiceProviders!.serviceproviders.data[index].distance}km",
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              appRegion == 2
                                  ? Container()
                                  : Positioned(
                                      right: 0,
                                      top: 0,
                                      child: isUserCerfified(
                                              _appController
                                                  .topRatedServiceProviders!
                                                  .serviceproviders
                                                  .data[index]
                                                  .idCardStatus,
                                              _appController
                                                  .topRatedServiceProviders!
                                                  .serviceproviders
                                                  .data[index]
                                                  .addressProofStatus,
                                              _appController
                                                  .topRatedServiceProviders!
                                                  .serviceproviders
                                                  .data[index]
                                                  .profilePicStatus)
                                          ? Row(
                                              children: [
                                                Text(
                                                  "fully Verfied",
                                                  style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  textAlign: TextAlign.end,
                                                ),
                                                Image.asset(
                                                  "assets/ic_fully_varified.PNG",
                                                  fit: BoxFit.fill,
                                                  width: 30,
                                                  height: 30,
                                                )
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Text(
                                                  "partially Verfied",
                                                  style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  textAlign: TextAlign.end,
                                                ),
                                                Image.asset(
                                                  "assets/ic_partical_varified.PNG",
                                                  fit: BoxFit.fill,
                                                  width: 30,
                                                  height: 30,
                                                )
                                              ],
                                            ))
                            ],
                          ),
                        ),
                      );
                    })
                : Container(
                    child: Text(
                      "No Data found",
                      style: Styles.headingText,
                    ),
                  );
          })
        ],
      ),
    );
  }

  bool isUserCerfified(
      int? idCardStatus, int? addressStatus, int? profileStatus) {
    bool userCertified = false;
    if (idCardStatus == 1 && addressStatus == 1 && profileStatus == 1) {
      userCertified = true;
    } else {
      userCertified = false;
    }
    return userCertified;
  }
}
