import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_item_searched_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_related_skill_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_search_service_provider.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_searchpage_header.dart';
import 'package:odlay_services/Styles/styles.dart';

class SimpleSearchSericeProvider extends StatefulWidget {
  bool isSearchProfession;
  String skillValue;
  SimpleSearchSericeProvider(this.skillValue, this.isSearchProfession);
  @override
  State<SimpleSearchSericeProvider> createState() =>
      _SimpleSearchSericeProviderState();
}

class _SimpleSearchSericeProviderState
    extends State<SimpleSearchSericeProvider> {
  final AppController _appController = Get.find();
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
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
    print("SavedKey${apiKey}");
    print("CityId${responseLoginUser.user.consumer.cityId}");
    if (AppConstants.isSlectedUserCustomer) {
      if (widget.isSearchProfession) {
        _appController.readSearchServicePsearchSpByProfession(
            HeaderFilterConstant.defualtCityId.toString(),
            responseLoginUser.user.language.toString(),
            currentpage.toString(),
            apiKey.toString(),
            LocationConstants.USERCURRENTLATITUDE,
            LocationConstants.USERCURRENTLONGITUDE,
            widget.skillValue);
      } else {
        _appController.readSearchServiceProviderAndGigs(
            HeaderFilterConstant.defualtCityId.toString(),
            responseLoginUser.user.language.toString(),
            currentpage.toString(),
            apiKey.toString(),
            LocationConstants.USERCURRENTLATITUDE,
            LocationConstants.USERCURRENTLONGITUDE,
            widget.skillValue);
      }
    } else {
      print("MakeBodyWithJobs");
      if (widget.isSearchProfession) {
        _appController.searchJobNyProfession(
            HeaderFilterConstant.defualtCityId.toString(),
            responseLoginUser.user.language.toString(),
            currentpage.toString(),
            apiKey.toString(),
            LocationConstants.USERCURRENTLATITUDE,
            LocationConstants.USERCURRENTLONGITUDE,
            widget.skillValue);
      } else {
        _appController.searechSimpleJobs(
            HeaderFilterConstant.defualtCityId.toString(),
            responseLoginUser.user.language.toString(),
            currentpage.toString(),
            apiKey.toString(),
            LocationConstants.USERCURRENTLATITUDE,
            LocationConstants.USERCURRENTLONGITUDE,
            widget.skillValue);
      }
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        currentpage++;
        if (AppConstants.isSlectedUserCustomer) {
          if (widget.isSearchProfession) {
            _appController.readSearchServicePsearchSpByProfession(
                HeaderFilterConstant.defualtCityId.toString(),
                responseLoginUser.user.language.toString(),
                currentpage.toString(),
                apiKey.toString(),
                LocationConstants.USERCURRENTLATITUDE,
                LocationConstants.USERCURRENTLONGITUDE,
                widget.skillValue);
          } else {
            _appController.readSearchServiceProviderAndGigs(
                HeaderFilterConstant.defualtCityId.toString(),
                responseLoginUser.user.language.toString(),
                currentpage.toString(),
                apiKey.toString(),
                LocationConstants.USERCURRENTLATITUDE,
                LocationConstants.USERCURRENTLONGITUDE,
                widget.skillValue);
          }
        } else {
          print("MakeBodyWithJobs");
          if (widget.isSearchProfession) {
            _appController.searchJobNyProfession(
                HeaderFilterConstant.defualtCityId.toString(),
                responseLoginUser.user.language.toString(),
                currentpage.toString(),
                apiKey.toString(),
                LocationConstants.USERCURRENTLATITUDE,
                LocationConstants.USERCURRENTLONGITUDE,
                widget.skillValue);
          } else {
            _appController.searechSimpleJobs(
                HeaderFilterConstant.defualtCityId.toString(),
                responseLoginUser.user.language.toString(),
                currentpage.toString(),
                apiKey.toString(),
                LocationConstants.USERCURRENTLATITUDE,
                LocationConstants.USERCURRENTLONGITUDE,
                widget.skillValue);
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          SearchPageHeader(false),
          const SizedBox(
            height: 106,
          ),
          AppConstants.isSlectedUserCustomer
              ? Expanded(
                  child: Obx(() {
                    if (_appController.responseSearchAllServiceProvidersValue ==
                        true) {
                      return Center(
                        child: _appController
                                    .responseSearchAllServiceProvidersValueMore ==
                                true
                            ? Container()
                            : CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.isSearchProfession
                                    ? "Search for:" +
                                        getProfessionNameFromId(
                                            widget.skillValue)
                                    : "Search for: ${widget.skillValue}",
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        color: Color.fromRGBO(255, 118, 87, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          _appController.responseSearchAllServiceProviders !=
                                      null &&
                                  _appController
                                      .responseSearchAllServiceProviders
                                      .gigs
                                      .data!
                                      .isNotEmpty
                              ? RelatedSkillsGigs(_appController
                                  .responseSearchAllServiceProviders.gigs)
                              : Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "No Services found",
                                    style: Styles.headingText,
                                  ),
                                ),
                          _appController.responseSearchAllServiceProviders !=
                                      null &&
                                  _appController
                                      .responseSearchAllServiceProviders
                                      .serviceproviders
                                      .data
                                      .isNotEmpty
                              ? SearchServiceProvider(
                                  _appController
                                      .responseSearchAllServiceProviders
                                      .serviceproviders,
                                  scrollController)
                              : Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "No Service Provider found",
                                    style: Styles.headingText,
                                  ),
                                )
                        ],
                      ),
                    );
                  }),
                )
              : Expanded(child: Container(child: Obx(() {
                  if (_appController.searchJobsModelValue == true) {
                    return Center(
                      child: _appController.searchJobsModelValueMore == true
                          ? CircularProgressIndicator()
                          : Container(),
                    );
                  }
                  return ItemSearchJobs(
                      _appController.searchJobsModel,
                      skillCitiesProfessions,
                      responseLoginUser,
                      scrollController);
                })))
        ],
      ),
    ));
  }

  String getProfessionNameFromId(String professionId) {
    String professionName = "";
    for (var profession in skillCitiesProfessions.professions) {
      if (professionId == profession.professionId.toString()) {
        professionName = profession.professionName.toString();
      }
    }
    return professionName;
  }
}
