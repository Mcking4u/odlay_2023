import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_query_top_rated_gigs_modle.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_header_viewAll.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/ListItems/item_view_all_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_homepager_header.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_profile_page.dart';

class ViewAllServiceProvider extends StatefulWidget {
  @override
  State<ViewAllServiceProvider> createState() => _ViewAllServiceProviderState();
}

class _ViewAllServiceProviderState extends State<ViewAllServiceProvider> {
  final AppController _appController = Get.find();
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  int? appRegion;
  int currentpage = 1;
  final ScrollController scrollController = ScrollController();
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
    _appController.viewAllServiceProvider(
        HeaderFilterConstant.defualtCityId.toString(),
        responseLoginUser.user.language.toString(),
        currentpage.toString(),
        apiKey.toString(),
        LocationConstants.USERCURRENTLATITUDE.toString(),
        LocationConstants.USERCURRENTLONGITUDE.toString());
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        print("LoadMoreData");
        currentpage++;
        _appController.viewAllServiceProvider(
            HeaderFilterConstant.defualtCityId.toString(),
            responseLoginUser.user.language.toString(),
            currentpage.toString(),
            apiKey.toString(),
            LocationConstants.USERCURRENTLATITUDE.toString(),
            LocationConstants.USERCURRENTLONGITUDE.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 237, 236, 236),
        child: Column(
          children: [
            HeaderViewAll(),
            const SizedBox(
              height: 106,
            ),
            Obx(() {
              if (_appController.isLoadingViewAllServiceProvider.value) {
                return Center(
                  child:
                      _appController.isLoadingViewAllMoreServiceProvider == true
                          ? CircularProgressIndicator()
                          : Container(),
                );
              }
              return Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    itemCount: _appController
                        .viewAllServiceProviders!.serviceproviders.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          var serviceProvider = _appController
                              .viewAllServiceProviders!
                              .serviceproviders
                              .data[index];
                          print("UserName${serviceProvider.firstName}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProfileLandingVisitPage(serviceProvider)));
                        },
                        child: Card(
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 80,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  AppConstants
                                                          .PROFILEIMAGESURLS +
                                                      _appController
                                                          .viewAllServiceProviders!
                                                          .serviceproviders
                                                          .data[index]
                                                          .logo
                                                          .toString()),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: RatingBarIndicator(
                                              rating: 2,
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                Icons.star,
                                                color: Colors.orange[900],
                                              ),
                                              itemCount: 5,
                                              itemSize: 12.0,
                                              direction: Axis.horizontal,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  _appController
                                                      .viewAllServiceProviders!
                                                      .serviceproviders
                                                      .data[index]
                                                      .firstName
                                                      .toString(),
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          color: Colors
                                                              .orange[900],
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    maxLines: 2,
                                                    _appController
                                                                .viewAllServiceProviders!
                                                                .serviceproviders
                                                                .data[index]
                                                                .skills !=
                                                            null
                                                        ? GenericAppFunctions
                                                            .getSkillNameFromSkillList(
                                                                _appController
                                                                    .viewAllServiceProviders!
                                                                    .serviceproviders
                                                                    .data[index]
                                                                    .skills)
                                                        : "",
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ))),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    GenericAppFunctions
                                                        .getCityNameFromCityId(
                                                            skillCitiesProfessions,
                                                            _appController
                                                                .viewAllServiceProviders!
                                                                .serviceproviders
                                                                .data[index]
                                                                .cityId),
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ))),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  "${_appController.viewAllServiceProviders!.serviceproviders.data[index].distance}km",
                                                  style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  textAlign: TextAlign.end)
                                            ],
                                          ),
                                        ),
                                      ),
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
                                                  .viewAllServiceProviders!
                                                  .serviceproviders
                                                  .data[index]
                                                  .idCardStatus,
                                              _appController
                                                  .viewAllServiceProviders!
                                                  .serviceproviders
                                                  .data[index]
                                                  .addressProofStatus,
                                              _appController
                                                  .viewAllServiceProviders!
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
                    }),
              );
            })
          ],
        ),
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

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}
