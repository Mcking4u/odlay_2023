import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_query_top_rated_gigs_modle.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_view_all_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_gig_detail_page.dart';
import 'package:get/get.dart';

class TopRatedGigs extends StatefulWidget {
  @override
  State<TopRatedGigs> createState() => _TopRatedGigsState();
}

class _TopRatedGigsState extends State<TopRatedGigs> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  final AppController _appController = Get.find();
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    String? apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    print("SavedKey${apiKey}");
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    responseLoginUser = responseLoginUserFromJson(userData!);
    print("FeaturedCallApi");
    _appController.getFeaturedGigs(
        QueryTopRatedGigsModle(cityId: 3), apiKey.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Obx(() {
      if (_appController.isLoadingFeaturedGigs.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return _appController.responseFeaturedGigs == null ||
              _appController.responseFeaturedGigs!.data.isEmpty
          ? Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "No Featured Services Found",
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
            )
          : Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'featured_services'.tr,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("ViewAllGigsChecked");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewAllGigs()));
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
                  SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount:
                              _appController.responseFeaturedGigs!.data.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 150,
                              width: 150,
                              child: GestureDetector(
                                onTap: () {
                                  print(
                                      "CliekdUserGig${_appController.responseFeaturedGigs!.data[index]}");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserGigDetailPage(
                                          _appController.responseFeaturedGigs!
                                              .data[index].gigId
                                              .toString(),
                                          _appController.responseFeaturedGigs!
                                              .data[index].userId
                                              .toString(),
                                          false,
                                          _appController.responseFeaturedGigs!
                                              .data[index].gigPrice)));
                                },
                                child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        _appController.responseFeaturedGigs!
                                                    .data[index].gigImages !=
                                                null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  GenericAppFunctions
                                                      .getGigListFromString(
                                                          _appController
                                                              .responseFeaturedGigs!
                                                              .data[index]
                                                              .gigImages)[0],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: 80,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                child:
                                                    // _appController
                                                    //                 .responseFeaturedGigs!
                                                    //                 .data[index]
                                                    //                 .skills !=
                                                    //             null &&
                                                    //         _appController
                                                    //             .responseFeaturedGigs!
                                                    //             .data[index]
                                                    //             .skills!
                                                    //             .isNotEmpty
                                                    //     ? Image.network(
                                                    //         AppConstants
                                                    //                 .IMAGESLIBRARYURLS +
                                                    //             _appController
                                                    //                 .responseFeaturedGigs!
                                                    //                 .data[index]
                                                    //                 .skills![0]
                                                    //                 .gid
                                                    //                 .toLowerCase()
                                                    //                 .replaceAll(
                                                    //                     " ", "") +
                                                    //             ".jpg",
                                                    //         errorBuilder: (context,
                                                    //             error, stackTrace) {
                                                    //           return Image.asset(
                                                    //               "assets/test_gig_image.jpg",
                                                    //               fit: BoxFit.cover,
                                                    //               width: double
                                                    //                   .infinity,
                                                    //               height: 80);
                                                    //         },
                                                    //         fit: BoxFit.cover,
                                                    //         width: double.infinity,
                                                    //         height: 80,
                                                    //       )
                                                    //     :
                                                    Image.asset(
                                                        "assets/test_gig_image.jpg",
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 80),
                                              ),
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          _appController
                                                              .responseFeaturedGigs!
                                                              .data[index]
                                                              .gigTitle
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 1,
                                                          style: GoogleFonts.roboto(
                                                              textStyle: const TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          118,
                                                                          87,
                                                                          1),
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          responseLoginUser.user
                                                                  .currencySymbol! +
                                                              _appController
                                                                  .responseFeaturedGigs!
                                                                  .data[index]
                                                                  .gigPrice
                                                                  .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          style: GoogleFonts.roboto(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _appController
                                                              .responseFeaturedGigs!
                                                              .data[index]
                                                              .gigDetail!
                                                              .isEmpty
                                                          ? ""
                                                          : _appController
                                                              .responseFeaturedGigs!
                                                              .data[index]
                                                              .gigDetail
                                                              .toString(),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 1,
                                                      style: GoogleFonts.roboto(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            GenericAppFunctions
                                                                .getCityNameFromCityId(
                                                                    skillCitiesProfessions,
                                                                    _appController
                                                                        .responseFeaturedGigs!
                                                                        .data[
                                                                            index]
                                                                        .cityId),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                            style: GoogleFonts.roboto(
                                                                textStyle: const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            211,
                                                                            210,
                                                                            210),
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                          child:
                                                              RatingBarIndicator(
                                                        rating: _appController
                                                                    .responseFeaturedGigs!
                                                                    .data[index]
                                                                    .rating !=
                                                                null
                                                            ? double.parse(
                                                                _appController
                                                                    .responseFeaturedGigs!
                                                                    .data[index]
                                                                    .rating
                                                                    .toString())
                                                            : 0,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .orange[900],
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 7.0,
                                                        direction:
                                                            Axis.horizontal,
                                                      )),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            );
                          }))
                ],
              ),
            );
    }));
  }

  String gigImage(String? gigImage, String skillName) {
    String gigImageUrl = "";

    gigImageUrl = "${AppConstants.GIGIMAGESURLS}${gigImage}";

    return gigImageUrl;
  }
}
