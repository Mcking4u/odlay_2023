import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/SearchModels/customerModel/_response_simple_search_all_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_gig_detail_page.dart';
import 'package:odlay_services/Styles/styles.dart';

class RelatedSkillsGigs extends StatefulWidget {
  SearchedGigs searchedGigs;
  RelatedSkillsGigs(this.searchedGigs);
  @override
  State<RelatedSkillsGigs> createState() => _RelatedSkillsGigsState();
}

class _RelatedSkillsGigsState extends State<RelatedSkillsGigs> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;

  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    responseLoginUser = responseLoginUserFromJson(userData!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchedGigs != null && widget.searchedGigs.data!.length > 0
        ? Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                SizedBox(
                    height: 130,
                    child: ListView.builder(
                        itemCount: widget.searchedGigs.data!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 130,
                            width: 130,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserGigDetailPage(
                                        widget.searchedGigs.data![index].gigId
                                            .toString(),
                                        responseLoginUser
                                            .user.serviceProviders.serviceId
                                            .toString(),
                                        false,
                                        widget.searchedGigs.data![index]
                                            .gigPrice)));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    //set border radius more than 50% of height and width to make circle
                                  ),
                                  child: Column(
                                    children: [
                                      widget.searchedGigs.data![index]
                                                  .gigImages !=
                                              null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              child: Image.network(
                                                GenericAppFunctions
                                                    .getGigListFromString(widget
                                                        .searchedGigs
                                                        .data![index]
                                                        .gigImages)[0],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 60,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              child: Image.asset(
                                                "assets/test_gig_image.jpg",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 60,
                                              ),
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
                                                        maxLines: 1,
                                                        widget
                                                            .searchedGigs
                                                            .data![index]
                                                            .gigTitle
                                                            .toString(),
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
                                                        maxLines: 1,
                                                        responseLoginUser.user
                                                                .currencySymbol
                                                                .toString() +
                                                            widget
                                                                .searchedGigs
                                                                .data![index]
                                                                .gigPrice
                                                                .toString(),
                                                        textAlign:
                                                            TextAlign.center,
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
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    maxLines: 1,
                                                    widget.searchedGigs
                                                        .data![index].gigDetail
                                                        .toString(),
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
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          GenericAppFunctions
                                                              .getCityNameFromCityId(
                                                                  skillCitiesProfessions,
                                                                  widget
                                                                      .searchedGigs
                                                                      .data![
                                                                          index]
                                                                      .cityId),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts.roboto(
                                                              textStyle: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          211,
                                                                          210,
                                                                          210),
                                                                  fontSize: 10,
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
                                                      rating: 2,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Icon(
                                                        Icons.star,
                                                        color:
                                                            Colors.orange[900],
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
          )
        : Text(
            "No Related Services found",
            style: Styles.headingTextColor,
          );
  }
}
