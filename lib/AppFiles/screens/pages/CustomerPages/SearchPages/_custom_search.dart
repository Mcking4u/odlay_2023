import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_item_searched_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_related_skill_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_search_service_provider.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_searchpage_header.dart';
import 'package:odlay_services/Styles/styles.dart';

class CustomSearch extends StatefulWidget {
  String language;
  String lat1;
  String lng1;
  String profession;
  String skills;
  String serachField;
  int search_distance;
  CustomSearch(this.language, this.lat1, this.lng1, this.profession,
      this.skills, this.serachField, this.search_distance);
  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
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

//make you api calls heres
    if (AppConstants.isSlectedUserCustomer) {
//make call to get related service provider
      print("SearchLatitude${widget.lat1}");
      print("SearchLongitude${widget.lng1}");

      _appController.searchCustomServiceProvider(
          widget.language,
          widget.lat1,
          widget.lng1,
          widget.profession,
          widget.skills,
          widget.serachField,
          apiKey.toString(),
          widget.search_distance,
          currentpage.toString());
    } else {
//make call to get related jobs
      _appController.customSearchJob(
          widget.language,
          widget.lat1,
          widget.lng1,
          widget.profession,
          widget.skills,
          widget.serachField,
          apiKey.toString(),
          widget.search_distance,
          currentpage.toString());
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        currentpage++;
        if (AppConstants.isSlectedUserCustomer) {
        _appController.searchCustomServiceProvider(
            widget.language,
            widget.lat1,
            widget.lng1,
            widget.profession,
            widget.skills,
            widget.serachField,
            apiKey.toString(),
            widget.search_distance,
            currentpage.toString());
      } else {
//make call to get related jobs
        _appController.customSearchJob(
            widget.language,
            widget.lat1,
            widget.lng1,
            widget.profession,
            widget.skills,
            widget.serachField,
            apiKey.toString(),
            widget.search_distance,
            currentpage.toString());
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
            SearchPageHeader(true),
            const SizedBox(
              height: 106,
            ),
            AppConstants.isSlectedUserCustomer
                ? Expanded(
                    child: Obx(() {
                      if (_appController
                              .responseSearchAllServiceProvidersValue ==
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
                                    child: Text(
                                      "No Data found",
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
                            ? Container()
                            : CircularProgressIndicator(),
                      );
                    }
                    return 
                    _appController.searchJobsModel!=null&&
                    _appController.searchJobsModel!.data.isNotEmpty
                    ?
              ItemSearchJobs(
                        _appController.searchJobsModel,
                        skillCitiesProfessions,
                        responseLoginUser,
                        scrollController):Container(child: Text(
                                      "No Data found",
                                      style: Styles.headingText,
                                    ));
                  })))
          ],
        ),
      ),
    );
  }
}
