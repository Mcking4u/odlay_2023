import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/GetChatMessagesJob.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_change_job_status.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/Tabs/_started_jobs_widgets/_item_started_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/Tabs/_started_jobs_widgets/_item_started_jobs_sp.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:sprintf/sprintf.dart';
import 'package:get/get.dart';

class SpStartedJobs extends StatefulWidget {
  @override
  State<SpStartedJobs> createState() => _SpStartedJobsState();
}

class _SpStartedJobsState extends State<SpStartedJobs> {
  late ResponseLoginUser responseLoginUser;
  AppController _appController = Get.put(AppController());
  late String? apiKey;
  int viewIndex = -1;
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
              itemCount: JobConstants.list_sp_started_jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      viewIndex = index;
                      _showBottomSheetJobDetail(
                          context, JobConstants.list_sp_started_jobs[index]);
                    },
                    child: ItemServiceProviderStartedJobs(
                        JobConstants.list_sp_started_jobs[index],
                        responseLoginUser));
              })),
    );
  }

  _showBottomSheetJobDetail(BuildContext context, Applied startedJob) {
    print("OpenSheet");
    String buttonText = getMessageButton(startedJob.status);
    bool areaButton = showValueJob(startedJob.status);
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
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
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 10, top: 20),
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
                      startedJob.jobTitle.toString(),
                      style: Styles.textStyleJobTitle,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, left: 20),
                    child: Text(
                      startedJob.jobDesc.toString(),
                      style: Styles.simpleText,
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
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 80,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                AppConstants.PROFILEIMAGESURLS +
                                    startedJob.logo.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  responseLoginUser.user.firstName.toString(),
                                  style: Styles.textStyleJobSheetHeading,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          'created_date'.tr,
                                          style: Styles.simpleText,
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          'str_dealine'.tr,
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
                                          GenericAppFunctions.getFormattedDate(
                                              startedJob.createdAt.toString()),
                                          style: Styles.simpleTextColored,
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          startedJob.deadline != null
                                              ? GenericAppFunctions
                                                  .getFormattedDate(startedJob
                                                      .deadline
                                                      .toString())
                                              : "",
                                          style: Styles.simpleTextColored,
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
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'location'.tr,
                      style: Styles.simpleText,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      startedJob.address.toString(),
                      style: Styles.headingText,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 10),
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
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child:Text(
                                  startedJob.bidAmount != null
                                      ? responseLoginUser.user.currencySymbol
                                      .toString() +
                                      startedJob.bidAmount.toString()
                                      : "",
                                  style: Styles.textStyleJobSheetbudget,
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  startedJob.spReceivableAmount != null
                                      ? responseLoginUser.user.currencySymbol
                                      .toString() +
                                      startedJob.spReceivableAmount
                                          .toString()
                                      : "",
                                  style: Styles.textStyleJobSheetbudgetColored,
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
                        margin: const EdgeInsets.only(
                            top: 10, left: 10, bottom: 10),
                        child: Text(
                            getStatusMessage(startedJob.status, startedJob),
                            style: Styles.textStyleStatusColor),
                      ),
                      areaButton
                          ? Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),

                                        // width: double.infinity,
                                        child: ElevatedButton(
                                          style: Styles
                                              .appElevatedJobStatusButtonStyle,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDisclaimerDialog(
                                                context,
                                                getDisclaimernMessages(
                                                    startedJob.status),
                                                startedJob);
                                          },
                                          child: Text(buttonText),
                                        )),
                                  ),
                                  Expanded(
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 20, left: 10),

                                        // width: double.infinity,
                                        child: ElevatedButton(
                                          style: Styles
                                              .appElevatedJobStatusButtonStyle,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            showDisclaimerDialogDispute(context,responseLoginUser.user.spMessages.sp_job_dispute_discl.message.toString(),startedJob);
                                            
                                          },
                                          child:  Text('btn_dispute'.tr),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(
                                  bottom: 20, left: 10, right: 10),
                              height: 30,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: Styles.appElevatedJobStatusButtonStyle,
                                onPressed: () {
                                  Navigator.pop(context);
                                  HandleClickListner(
                                      startedJob.status, startedJob);
                                },
                                child:  Text('btn_dispute'.tr),
                              ))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  String getStatusMessage(int? status, Applied _applied) {
    print("JobStatusSheet$status");
    String statusMsg = "";
    if (status == JobConstants.SP_ACCEPTED) {
      statusMsg = sprintf(
          responseLoginUser.user.spMessages.spPaymentAlert.message,
          [_applied.consumerName.toString()]);
    }
    if (status == JobConstants.HIRED_STATUS) {
      statusMsg = sprintf(responseLoginUser.user.spMessages.awarded.message,
          [_applied.consumerName.toString()]);
    }
    if (status == JobConstants.INVITED_FOR_JOB) {
      statusMsg = sprintf(
          responseLoginUser.user.spMessages.invitedforjob.message,
          [_applied.consumerName.toString()]);
    }
    if (status == JobConstants.STARTED_STATUS) {
      statusMsg = responseLoginUser.user.spMessages.spJobStartedInfo.message;
    }
    if (status == JobConstants.DISPUTED_STATUS) {
      statusMsg = responseLoginUser.user.spMessages.custComplaint.message;
    }
    if (status == JobConstants.DELIVERED_STATUS) {
      statusMsg = responseLoginUser.user.spMessages.spJobFinish.message;
    }
    if (status == JobConstants.NOT_VIEWED_STATUS ||
        status == JobConstants.USER_APPLIED_AFTER_INVITATION ||
        status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {
      statusMsg = sprintf(
          responseLoginUser.user.spMessages.spJobApplied.message,
          [_applied.consumerName.toString()]);
    }
    if (status == JobConstants.PAYMENTDONE) {
      print("TataMethod");
      if (_applied.paymentMethod == JobConstants.CARD_PAYMENT) {
        statusMsg = sprintf(
            responseLoginUser.user.spMessages.payspMentOnlineSuccessful.message,
            [_applied.consumerName.toString()]);
      } else {
        statusMsg = sprintf(
            responseLoginUser.user.spMessages.spCashPaymentWarning.message,
            [_applied.consumerName.toString()]);
      }
    }
    return statusMsg;
  }

//getting messages button
  String getMessageButton(int? status) {
    String btnText = "";
    if (status == JobConstants.STARTED_STATUS) {
      btnText = "btn_sp_complete".tr;
    } else {
      //Do nothing
    }
    return btnText;
  }

  bool showValueJob(int? status) {
    bool btnText = false;

    if (status == JobConstants.STARTED_STATUS) {
      btnText = true;
    }
    return btnText;
  }

  void HandleClickListner(int? status, Applied appliedJob) async {
    print("StartedJobStatus${status}");
    if (status == JobConstants.SP_ACCEPTED) {}
    if (status == JobConstants.HIRED_STATUS) {
      String chatMessageCurrent;
      String chatMessageOther;
    }
    if (status == JobConstants.INVITED_FOR_JOB) {}
    if (status == JobConstants.STARTED_STATUS) {
      print("CompletedJob");

      String chatMessageCurrent;
      String chatMessageOther;
      chatMessageCurrent = sprintf(
          GetChatMessageJob()
              .getChatMessage(FireBaseConstants.deliverJobCurrentUserMessage),
          [appliedJob.jobTitle.toString(), appliedJob.consumerName.toString()]);

      chatMessageOther = sprintf(
          GetChatMessageJob()
              .getChatMessage(FireBaseConstants.deliverJobOtherUserMessage),
          [
            responseLoginUser.user.firstName.toString(),
            appliedJob.jobTitle.toString()
          ]);

      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: appliedJob.jobId.toString(),
              status: JobConstants.DELIVERED_STATUS.toString(),
              userId: appliedJob.userId.toString()),
          apiKey.toString(),
          responseLoginUser.user.firebaseUid.toString(),
          appliedJob.firebaseUid.toString(),
          chatMessageCurrent,
          FireBaseConstants.applyJobAccepted,
          responseLoginUser.user.firstName.toString(),
          chatMessageOther,
          context);
      if (_appController.generalResponse != null) {
        if (_appController.generalResponse!.status == "success") {
          JobConstants.list_sp_started_jobs[viewIndex].status =
              JobConstants.DELIVERED_STATUS;
          showToast("Job Deliverd successfully ",
              context: context, backgroundColor: Colors.green);
          setState(() {});
        } else {
          showToast(_appController.generalResponse!.message,
              context: context, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to complete this job",
            context: context, backgroundColor: Colors.red);
      }
    }
    if (status == JobConstants.DISPUTED_STATUS) {}
    if (status == JobConstants.DELIVERED_STATUS) {}
    if (status == JobConstants.NOT_VIEWED_STATUS ||
        status == JobConstants.USER_APPLIED_AFTER_INVITATION ||
        status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {}
    if (status == JobConstants.PAYMENTDONE) {
      print("HandlePaymentDone");
    }
  }

  void showDisclaimerDialog(
      BuildContext context, String text, Applied statetedJob) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (BuildContext dialogueContext, __, ___) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: 400,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 118, 87, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            'title_disclaimer'.tr,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(dialogueContext);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Html(data: text, style: {
                          'li': Style(
                              color: Colors.black,
                              fontSize: FontSize(10.0),
                              ),
                          'h4': Style(color: Color.fromARGB(255, 53, 52, 52),
                            fontSize: FontSize(13.0),)
                        }),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogueContext);
                              },
                              style: Styles.appElevatedJobStatusButtonStyle,
                              child: Text('decline'.tr)),
                        ),
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogueContext);
                                HandleClickListner(
                                    statetedJob.status, statetedJob);
                              },
                              style: Styles.appElevatedJobStatusButtonStyle,
                              child: Text('accept'.tr)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  String getDisclaimernMessages(int? status) {
    String discaimerMessage = "";
    if (status == JobConstants.STARTED_STATUS) {
      discaimerMessage =
          responseLoginUser.user.spMessages.spJobFinishDiscl.message;
    }
    return discaimerMessage;
  }
  void showDisclaimerDialogDispute(
      BuildContext context, String text, Applied statetedJob) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (BuildContext dialogueContext, __, ___) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: 400,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 118, 87, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            'title_disclaimer'.tr,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(dialogueContext);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Html(data: text, style: {
                          'li': Style(
                              color: Colors.black,
                              fontSize: FontSize(10.0),
                              ),
                          'h4': Style(color: Color.fromARGB(255, 53, 52, 52),
                            fontSize: FontSize(13.0),)
                        }),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogueContext);
                              },
                              style: Styles.appElevatedJobStatusButtonStyle,
                              child: Text('decline'.tr)),
                        ),
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogueContext);
                                updateDispute(statetedJob);
                              },
                              style: Styles.appElevatedJobStatusButtonStyle,
                              child: Text('accept'.tr)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
  void updateDispute(Applied startedJob)async{
    String chatMessageCurrent;
                                            String chatMessageOther;

                                            chatMessageCurrent = sprintf(
                                                GetChatMessageJob()
                                                    .getChatMessage(
                                                        FireBaseConstants
                                                            .DISPUTE_CU_JOB_CURRENT_USER_MESSAGE),
                                                [
                                                  startedJob.consumerName,
                                                  startedJob.jobTitle
                                                ]);
                                            chatMessageOther = sprintf(
                                                GetChatMessageJob()
                                                    .getChatMessage(
                                                        FireBaseConstants
                                                            .DISPUTE_CU_JOB_OTHER_USER_MESSAGE),
                                                [
                                                  responseLoginUser
                                                      .user.firstName,
                                                  startedJob.jobTitle
                                                ]);
                                            await _appController
                                                .changeJobStatus(
                                                    QueryChangeJobStatus(
                                                        jobId: startedJob.jobId
                                                            .toString(),
                                                        status: JobConstants
                                                            .DISPUTED_STATUS
                                                            .toString(),
                                                        userId: startedJob
                                                            .userId
                                                            .toString()),
                                                    apiKey.toString(),
                                                    responseLoginUser
                                                        .user.firebaseUid
                                                        .toString(),
                                                    startedJob
                                                        .firebaseUid
                                                        .toString(),
                                                    chatMessageCurrent,
                                                    FireBaseConstants
                                                        .applyJobFinish,
                                                    responseLoginUser
                                                        .user.firstName
                                                        .toString(),
                                                    chatMessageOther,
                                                    context);

                                            if (_appController
                                                    .generalResponse !=
                                                null) {
                                              if (_appController
                                                      .generalResponse!
                                                      .status ==
                                                  "success") {
                                                
                                                JobConstants
                                                        .list_sp_started_jobs[
                                                            viewIndex]
                                                        .status =
                                                    JobConstants
                                                        .DISPUTED_STATUS;
                                                setState(() {});
                                              } else {
                                                
                                                showToast(
                                                    _appController
                                                        .generalResponse!
                                                        .message,
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.red);
                                              }
                                            } else {
                                              
                                              showToast(
                                                  "Unable to create dispute",
                                                  context: context,
                                                  backgroundColor: Colors.red);
                                            }
  }
}
