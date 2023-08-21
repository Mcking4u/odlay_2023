import 'package:flutter/material.dart';
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
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_header_viewAll.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_homepager_header.dart';
import 'package:odlay_services/AppFiles/model/CustomerModels/jobs_model.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/SubDetailPages/customerJobDetail/_apply_job_detail.dart';

class ViewAllJobs extends StatefulWidget {
  @override
  State<ViewAllJobs> createState() => _ViewAllJobsState();
}

class _ViewAllJobsState extends State<ViewAllJobs> {
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
//fetch all jobs
    _appController.getAllJobs(
        HeaderFilterConstant.defualtCityId.toString(),
        responseLoginUser.user.language.toString(),
        currentpage.toString(),
        apiKey.toString(),
        LocationConstants.USERCURRENTLATITUDE.toString(),
        LocationConstants.USERCURRENTLONGITUDE.toString());
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        print("LoadMoreJobs");
        currentpage++;
        _appController.getAllJobs(
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
              if (_appController.isLoadingJobsModelViewAlll.value) {
                return Center(
                  child: _appController.isLoadingJobsModelViewAlllMore == true
                      ? CircularProgressIndicator()
                      : Container(),
                );
              }
              return Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    itemCount: _appController.jobsModelViewAll!.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Datum jobsModel;
                            jobsModel =
                                _appController.jobsModelViewAll!.data[index];
                            print("ClickedJob${jobsModel.title}");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ApplyJobDetail(jobsModel)));
                          },
                          child: Card(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        height: 80,
                                        margin: EdgeInsets.only(left: 10),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              AppConstants.PROFILEIMAGESURLS +
                                                  _appController
                                                      .jobsModelViewAll!
                                                      .data[index]
                                                      .userLogo
                                                      .toString()),
                                        )),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: _appController
                                                            .jobsModelViewAll!
                                                            .data[index]
                                                            .title,
                                                        style: GoogleFonts.roboto(
                                                            textStyle: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        85,
                                                                        84,
                                                                        84),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, top: 2),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const WidgetSpan(
                                                      child: Icon(Icons.person,
                                                          size: 14,
                                                          color: Colors.grey),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            " ${_appController.jobsModelViewAll!.data[index].createrFirstName}",
                                                        style: GoogleFonts.roboto(
                                                            textStyle: const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 2),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const WidgetSpan(
                                                      child: Icon(
                                                          color: Colors.grey,
                                                          Icons.calendar_month,
                                                          size: 14),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            " ${_appController.jobsModelViewAll!.data[index].createdAt}",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                textStyle:
                                                                    const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 2),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const WidgetSpan(
                                                      child: Icon(
                                                          color: Colors.grey,
                                                          Icons.location_on,
                                                          size: 14),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            " ${GenericAppFunctions.getCityNameFromCityId(skillCitiesProfessions, _appController.jobsModelViewAll!.data[index].cityId)}",
                                                        style: GoogleFonts.roboto(
                                                            textStyle: const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
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
                                    child: Container(
                                      height: 100,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Budget: \n ${responseLoginUser.user.currencySymbol}${_appController.jobsModelViewAll!.data[index].budget}",
                                              style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      color: Colors.orange[800],
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              textAlign: TextAlign.end,
                                            ),
                                            Text(
                                                "${_appController.jobsModelViewAll!.data[index].distance} km",
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                textAlign: TextAlign.end)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
}
