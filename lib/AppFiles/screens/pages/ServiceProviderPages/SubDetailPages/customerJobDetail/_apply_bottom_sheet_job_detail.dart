import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/JobDetailModels/ResponseJobDetail.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/FullImageShow.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:odlay_services/AppFiles/model/CustomerModels/jobs_model.dart';
import 'package:get/get.dart';

class ApplyBottomSheetJobDetail extends StatelessWidget {
  Datum jobsModel;
  ResponseLoginUser? responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  List<String> jobImagesUrl = [];
  ApplyBottomSheetJobDetail(
      this.jobsModel, this.responseLoginUser, this.skillCitiesProfessions);
  @override
  Widget build(BuildContext context) {
//get job images if not null
    if (jobsModel.jobImages != null) {
      jobImagesUrl =
          GenericAppFunctions.getJobImagesFromString(jobsModel.jobImages);
    }
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Column(
          children: [
            Container(
              width: 50,
              color: Color.fromARGB(255, 72, 72, 72),
              margin: EdgeInsets.only(bottom: 10),
              child: Image.asset(
                "assets/ic_edit_screen_line.png",
                fit: BoxFit.contain,
                width: double.infinity,
                height: 2,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        jobsModel.title.toString(),
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 30,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  jobsModel.detail.toString(),
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            chipList(),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            AppConstants.PROFILEIMAGESURLS +
                                jobsModel.userLogo.toString(),
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('name'.tr,
                                            style: Styles.simpleText),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            child: Text('job_budget'.tr,
                                                style: Styles.simpleText)),
                                      ))
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                            child: Text(
                                                jobsModel.createrFirstName
                                                    .toString(),
                                                style: Styles.simpleTextData))),
                                    Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              child: Text(
                                                  responseLoginUser!
                                                          .user.currencySymbol
                                                          .toString() +
                                                      jobsModel.budget
                                                          .toString(),
                                                  style:
                                                      Styles.simpleTextData)),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                            child: Text('str_created_at'.tr,
                                                style: Styles.simpleText))),
                                    Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              child: Text('str_dealine'.tr,
                                                  style: Styles.simpleText)),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                            child: Text(
                                                jobsModel.createdAt != null
                                                    ? GenericAppFunctions
                                                        .getFormattedDate(
                                                            jobsModel.createdAt
                                                                .toString())
                                                    : "",
                                                style: Styles.simpleTextData))),
                                    Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              child: Text(
                                                  jobsModel.deadline != null
                                                      ? GenericAppFunctions
                                                          .getFormattedDate(
                                                              jobsModel.deadline
                                                                  .toString())
                                                      : "",
                                                  style:
                                                      Styles.simpleTextData)),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          child:
                              Text('location'.tr, style: Styles.simpleText))),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            child:
                                Text('distance'.tr, style: Styles.simpleText)),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                          child: Text(jobsModel.address.toString(),
                              style: Styles.textProfileStyle1))),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            child: Text("${jobsModel.distance}.km",
                                style: Styles.textProfileStyle1)),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'str_job_images'.tr,
                  style: Styles.headingText,
                ),
              ),
            ),
            jobImagesUrl.isNotEmpty
                ? Container(
                    height: 80,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ListView.builder(
                          itemCount: GenericAppFunctions.getJobImagesFromString(
                                  jobsModel.jobImages.toString())
                              .length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SimplePhotoViewPage(
                                        jobImagesUrl[index])));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 80,
                                width: 80,
                                child: InteractiveViewer(
                                  panEnabled:
                                      false, // Set it to false to prevent panning.
                                  boundaryMargin: EdgeInsets.all(80),
                                  minScale: 0.5,
                                  maxScale: 4,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    child: Image.network(
                                      jobImagesUrl[index],
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'job_has_no_images'.tr,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  chipList() {
    print("skillList${jobsModel.skillId}");
    final List<String> _jobSKills = [];
    for (var sId in jobsModel.skillId) {
      print("SkilId$sId");
      var Skill =
          skillCitiesProfessions.skills.where((skill) => skill.skillId == sId);
      print("SKillName${Skill.first}");
      _jobSKills.add(Skill.first.toString());
    }
    return Wrap(
      spacing: 6.0,
      runSpacing: 0.0,
      children: <Widget>[
        for (var jobSkill in _jobSKills)
          _buildChip(jobSkill, Color.fromARGB(255, 189, 188, 188)),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
    );
  }
}
