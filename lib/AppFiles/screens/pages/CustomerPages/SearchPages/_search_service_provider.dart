import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';

import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/SearchModels/customerModel/_response_simple_search_all_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_simple_search_serice_provider.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';

class SearchServiceProvider extends StatefulWidget {
  SearchServiceproviders serviceProviders;
  ScrollController _scrollController;
  SearchServiceProvider(this.serviceProviders, this._scrollController);
  @override
  State<SearchServiceProvider> createState() => _SearchServiceProviderState();
}

class _SearchServiceProviderState extends State<SearchServiceProvider> {
  final AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  int? appRegion;

  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: widget._scrollController,
                  itemCount: widget.serviceProviders.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var currentUser = widget.serviceProviders.data[index];
                    return Container(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Datum serviceProvider = Datum(
                              id: currentUser.id,
                              firebaseUid: currentUser.firebaseUid,
                              deviceToken: currentUser.deviceToken,
                              serviceId: currentUser.serviceId,
                              address: currentUser.address,
                              cityId: 3,
                              streetNo: "",
                              latitude: currentUser.latitude,
                              longitude: currentUser.longitude,
                              defaultView: currentUser.logo.toString(),
                              title: "",
                              companyId: 1,
                              email: "",
                              firstName: currentUser.firstName,
                              lastName: "",
                              logo: currentUser.logo,
                              phone: currentUser.phone,
                              roleId: 1,
                              status: 1,
                              idCardStatus: currentUser.idCardStatus,
                              addressProofStatus:
                                  currentUser.addressProofStatus,
                              profilePicStatus: currentUser.profilePicStatus,
                              portfolioImages: currentUser.portfolioImages,
                              allowMobileCall: currentUser.allowMobileCall,
                              rating: currentUser.rating.toString(),
                              distance: currentUser.distance,
                              reviewsCount: currentUser.reviews!.length,
                              spcount: 1,
                              skills: currentUser.skills,
                              gigs: currentUser.gigs);
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
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(AppConstants
                                                                .PROFILEIMAGESURLS +
                                                            currentUser.logo
                                                                .toString()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              height: 60,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        currentUser.firstName
                                                            .toString(),
                                                        style: GoogleFonts.roboto(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                        .orange[
                                                                    900],
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          maxLines: 1,
                                                          currentUser.skills !=
                                                                      null &&
                                                                  currentUser
                                                                      .skills!
                                                                      .isNotEmpty
                                                              ? GenericAppFunctions
                                                                      .getSkillNameFromSkillList(
                                                                          currentUser
                                                                              .skills)
                                                                  .substring(1)
                                                              : "",
                                                          style: GoogleFonts.roboto(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
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
                                                          currentUser.address
                                                              .toString(),
                                                          style: GoogleFonts.roboto(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                    ),
                                                  )
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
                                              rating: currentUser.rating != null
                                                  ? double.parse(currentUser
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
                                            margin: EdgeInsets.only(
                                                top: 5, right: 5),
                                            child: Text(
                                                "${currentUser.distance}km",
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                textAlign: TextAlign.end),
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
                                        child: Row(
                                          children: [
                                            Text(
                                              "partially Verfied",
                                              style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                            )),
                      ),
                    );
                  }),
            )
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
}
