import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_chat_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/Tabs/_started_jobs_widgets/_item_closed_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/Tabs/_started_jobs_widgets/_item_started_jobs_sp.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

class SpClosedJobs extends StatefulWidget {
  @override
  State<SpClosedJobs> createState() => _SpClosedJobsState();
}

class _SpClosedJobsState extends State<SpClosedJobs> {
  late ResponseLoginUser responseLoginUser;
  AppController _appController = Get.put(AppController());
  late String? apiKey;

  @override
  void initState() {
    //getting user data
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
//getting api key
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 1), () async {
          print("RefreshViewCalled");
          await _appController.getSpAppliedJobs(
              ServiceproviderJobsShowQuery(
                  apiKey: apiKey.toString(),
                  language: responseLoginUser.user.language,
                  userId:
                      responseLoginUser.user.serviceProviders.userId.toString(),
                  callFrom: "refresh"),
              apiKey.toString(),
              false);
          setState(() {});
        });
      },
      child: Container(
          child: ListView.builder(
              itemCount: JobConstants.list_sp_closed_jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      showBottomSheetClosedJob(
                          context, JobConstants.list_sp_closed_jobs[index]);
                    },
                    child: ItemServiceProviderClosedJobs(
                        JobConstants.list_sp_closed_jobs[index],
                        responseLoginUser));
              })),
    );
  }

  showBottomSheetClosedJob(BuildContext context, Applied completedJob) {
    print("OpenSheetClose");
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Image.asset(
                      "assets/ic_edit_screen_line.png",
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        completedJob.jobTitle.toString(),
                        style: Styles.textStyleJobTitle,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    AppConstants.PROFILEIMAGESURLS +
                                        completedJob.logo.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 10,
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(AppConstants.baseContext).push(
                                      MaterialPageRoute(
                                          builder: (context) => ChatDetailPage(
                                              completedJob.consumerName
                                                  .toString(),
                                              completedJob.firebaseUid
                                                  .toString(),
                                              completedJob.logo.toString(),
                                              completedJob.logo.toString())));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Image.asset(
                                    "assets/ic_chat.gif",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Customer",
                                    style: Styles.simpleText,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      completedJob.consumerName.toString(),
                                      style: Styles.textStyleJobSheetHeading,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            'started_job'.tr,
                                            style: Styles.simpleText,
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            'created_date'.tr,
                                            style: Styles.simpleText,
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            GenericAppFunctions
                                                .getFormattedDate(completedJob
                                                    .updatedAt
                                                    .toString()),
                                            style: Styles.simpleTextData,
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            GenericAppFunctions
                                                .getFormattedDate(completedJob
                                                    .createdAt
                                                    .toString()),
                                            style: Styles.simpleTextData,
                                          ))
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('payment_method_str'.tr,
                            style: Styles.noteTextColor),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: completedJob.paymentMethod ==
                                  JobConstants.CARD_PAYMENT
                              ? Image.asset(
                                  "assets/payment_by_cash.png",
                                  height: 40,
                                  width: 40,
                                )
                              : Image.asset(
                                  "assets/payment_by_cash.png",
                                  height: 40,
                                  width: 40,
                                ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Delivered By",
                            style: Styles.textStyleJobTitleNote)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    AppConstants.PROFILEIMAGESURLS +
                                        completedJob.logo.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        responseLoginUser.user.firstName
                                            .toString(),
                                        style: Styles.textProfileStyle1),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              'bid_amount'.tr,
                                              style: Styles.simpleText,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              'receivable_amount'.tr,
                                              style: Styles.simpleText,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              completedJob.bidAmount != null
                                                  ? responseLoginUser
                                                          .user.currencySymbol
                                                          .toString() +
                                                      completedJob.bidAmount
                                                          .toString()
                                                  : "",
                                              style: Styles
                                                  .textStyleJobSheetbudgetColoredCustomer,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              completedJob.spReceivableAmount !=
                                                  null
                                                  ? responseLoginUser.user
                                                  .currencySymbol! +
                                                  completedJob
                                                      .spReceivableAmount
                                                      .toString()
                                                  : "",
                                              style: Styles
                                                  .textStyleJobSheetbudgetColoredCustomer,
                                            ))
                                      ],
                                    ),
                                  ),


                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 10, left: 0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Odlay fee(VAT Included)",
                                            style:
                                                Styles.textStyleJobTitleNote)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('skills'.tr,
                                            style: Styles.textProfileStyle)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        completedJob.jobskills != null &&
                                                completedJob
                                                    .jobskills.isNotEmpty
                                            ? GenericAppFunctions
                                                    .getSkillFromJobSkill(
                                                        completedJob.jobskills)
                                                .substring(1)
                                            : "",
                                        style: Styles.textProfileStyle1,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('location'.tr,
                                            style: Styles.textProfileStyle)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        responseLoginUser
                                            .user.serviceProviders.address
                                            .toString(),
                                        style: Styles.textProfileStyle1,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('sp_bid_amount_message'.tr,
                            style: Styles.sp_note_style),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, bottom: 0),
                    child: Text(
                        getStatusMessage(completedJob.status, completedJob),
                        style: Styles.textStyleStatusColor),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String getStatusMessage(int? status, Applied _applied) {
    String statusMsg = "";

    if (status == JobConstants.COMPLETED_STATUS) {
      statusMsg = responseLoginUser
          .user.userMessages.job_completed_with_success.message
          .toString();
    }
    if (status == JobConstants.CANCELED_STATUS) {
      statusMsg =
          responseLoginUser.user.userMessages.job_cancelled.message.toString();
    }
    if (status == JobConstants.APPLICANT_WITHDRAW_REQUEST) {
      print("Write WithDraw Request");
      statusMsg =
          responseLoginUser.user.spMessages.sp_job_caceled.message.toString();
    }
    if (status == JobConstants.APPLICANT_UNSUCCESSFULL) {
      print("this status indicated user awarded job to someone else");
      statusMsg =
          responseLoginUser.user.spMessages.sp_job_app_unsuccessful.message.toString();
    }
    if (status == JobConstants.DELIVERED_STATUS) {
      statusMsg = responseLoginUser.user.spMessages.spJobFinish.message;
    }

    return statusMsg;
  }
}
