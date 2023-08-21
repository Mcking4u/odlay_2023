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
import 'package:odlay_services/AppFiles/model/CustomerModels/jobs_model.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/HomePage/_view_all_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/SubDetailPages/customerJobDetail/_apply_job_detail.dart';
import 'package:get/get.dart';

class LatesJobsPage extends StatefulWidget {
  @override
  State<LatesJobsPage> createState() => _LatesJobsPageState();
}

class _LatesJobsPageState extends State<LatesJobsPage> {
  final AppController _appController = Get.put(AppController());
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  @override
  void initState() {
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    responseLoginUser = responseLoginUserFromJson(user_data!);

    _appController.getLatestJob(
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
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'lates_posted_job'.tr,
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: () {
                    print("ViewAllJibs");
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ViewAllJobs()));
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
            if (_appController.isLoadingJobsModel.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _appController.jobsModel!.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Datum jobsModel;
                            jobsModel = _appController.jobsModel!.data[index];
                            print("ClickedJob${jobsModel.title}");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ApplyJobDetail(jobsModel)));
                          },
                          child: Card(
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
                                              _appController
                                                          .jobsModel!
                                                          .data[index]
                                                          .jobImages !=
                                                      null
                                                  ? GenericAppFunctions
                                                      .getJobImagesFromString(
                                                          _appController
                                                              .jobsModel!
                                                              .data[index]
                                                              .jobImages)[0]
                                                  : AppConstants
                                                          .PROFILEIMAGESURLS +
                                                      _appController.jobsModel!
                                                          .data[index].userLogo
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
                                                maxLines:2,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(

                                                  children: [
                                                    TextSpan(

                                                        text: _appController
                                                            .jobsModel!
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
                                                                fontSize: 11,
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
                                                left: 10, top: 2),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: _appController
                                                            .jobsModel!
                                                            .data[index]
                                                            .createrFirstName
                                                            .toString(),
                                                        style: GoogleFonts.roboto(
                                                            textStyle: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
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
                                                left: 10, top: 2),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: GenericAppFunctions
                                                            .getFormattedDate(
                                                                _appController
                                                                    .jobsModel!
                                                                    .data[index]
                                                                    .createdAt
                                                                    .toString()),
                                                        style:
                                                            GoogleFonts.roboto(
                                                                textStyle:
                                                                    const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 9,
                                                        ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 2),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                maxLines: 1,
                                                text: TextSpan(
                                                  children: [
                                                    // const WidgetSpan(
                                                    //   child: Icon(
                                                    //       color: Colors.grey,
                                                    //       Icons.location_on,
                                                    //       size: 14),
                                                    // ),
                                                    TextSpan(
                                                        text: _appController
                                                            .jobsModel!
                                                            .data[index]
                                                            .address
                                                            .toString(),
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
                                              "Budget: \n ${responseLoginUser.user.currencySymbol}${_appController.jobsModel!.data[index].budget}",
                                              style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      color: Colors.orange[800],
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              textAlign: TextAlign.end,
                                            ),
                                            Text(
                                                "${_appController.jobsModel!.data[index].distance} km",
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
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
                    }));
          })
        ],
      ),
    );
  }
}
