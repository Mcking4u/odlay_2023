import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CustomerModels/jobs_model.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/SubDetailPages/customerJobDetail/_apply_job_detail.dart';

class ItemSearchJobs extends StatelessWidget {
  JobsModel? jobsModel;
  SkillCitiesProfessions skillCitiesProfessions;
  ResponseLoginUser responseLoginUser;
  ScrollController _scrollController;
  ItemSearchJobs(this.jobsModel, this.skillCitiesProfessions,
      this.responseLoginUser, this._scrollController);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: jobsModel!.data.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    Datum jobModel;
                    jobModel = jobsModel!.data[index];
                    print("ClickedJob${jobModel.title}");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ApplyJobDetail(jobModel)));
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
                                  backgroundImage:
                                      jobsModel!.data[index].jobImages != null
                                          ? NetworkImage(GenericAppFunctions
                                                  .getJobImagesFromString(
                                                      jobsModel!.data[index]
                                                          .jobImages)[0]
                                              .toString())
                                          : NetworkImage(AppConstants
                                                  .PROFILEIMAGESURLS +
                                              jobsModel!.data[index].userLogo
                                                  .toString()),
                                )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 5, bottom: 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        maxLines:2,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: jobsModel!
                                                    .data[index].title,
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 85, 84, 84),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, top: 2),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            // const WidgetSpan(
                                            //   child: Icon(Icons.person,
                                            //       size: 14, color: Colors.grey),
                                            // ),
                                            TextSpan(
                                                text: jobsModel!.data[index]
                                                    .createrFirstName
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, top: 2),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            // const WidgetSpan(
                                            //   child: Icon(
                                            //       color: Colors.grey,
                                            //       Icons.calendar_month,
                                            //       size: 14),
                                            // ),
                                            TextSpan(
                                                text: jobsModel!
                                                    .data[index].createdAt
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 9,
                                                ))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, top: 2),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: jobsModel!
                                                    .data[index].address,
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold))),
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
                                      "Budget: \n ${responseLoginUser.user.currencySymbol}${jobsModel!.data[index].budget}",
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.orange[800],
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                        "${jobsModel!.data[index].distance} km",
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
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
  }
}
