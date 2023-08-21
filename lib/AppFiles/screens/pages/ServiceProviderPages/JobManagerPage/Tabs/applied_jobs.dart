import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
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
import 'package:odlay_services/AppFiles/model/ApplyJob/_query_apply_job.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_query_edit_proposal.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/Tabs/_started_jobs_widgets/_item_started_jobs_sp.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:sprintf/sprintf.dart';
import 'package:get/get.dart';

class ServiceProviderAppliedJobs extends StatefulWidget {
  @override
  State<ServiceProviderAppliedJobs> createState() =>
      _ServiceProviderAppliedJobsState();
}

class _ServiceProviderAppliedJobsState
    extends State<ServiceProviderAppliedJobs> {
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;
  AppController _appController = Get.put(AppController());
  TextEditingController budgetAmount = TextEditingController();
  TextEditingController timeToComplete = TextEditingController();
  TextEditingController serviceDescription = TextEditingController();
  TextEditingController editbudgetAmount = TextEditingController();
  String dropdownValue = 'Fixed';
  List<String> spinnerItems = ['Fixed', 'Hourly', 'Monthly'];
  late BuildContext mContext;
  int viewJobIndex = -1;
  String odlayfee = "";
  String odlayfeePecentage = "";
  String receivableAmount = "";
  RxBool amountChange = false.obs;
//edit proposal
  String odlayfeeEditProposal = "";
  String receivableAmountEditProposal = "";
  RxBool amountChangeEditProposal = false.obs;
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    odlayfeePecentage=(double.parse(responseLoginUser.user.spfee!.toString())*100).toString();
    super.initState();
    print("ListSize${JobConstants.list_sp_applied_jobs.length}");
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
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
              itemCount: JobConstants.list_sp_applied_jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      viewJobIndex = index;
                      _showBottomSheetJobDetail(
                          context, JobConstants.list_sp_applied_jobs[index]);
                    },
                    child: ItemServiceProviderStartedJobs(
                        JobConstants.list_sp_applied_jobs[index],
                        responseLoginUser));
              })),
    );
  }

  _showBottomSheetJobDetail(BuildContext context, Applied appliedJob) {
    print("OpenSheet");
    String buttonText = getMessageButton(appliedJob.status);
    bool areaButton = showValueJob(appliedJob.status);
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
            child: Container(
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
                        appliedJob.jobTitle.toString(),
                        style: Styles.textStyleJobTitle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, left: 20),
                      child: Text(
                        appliedJob.jobDesc.toString(),
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
                                      appliedJob.logo.toString(),
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
                                    appliedJob.consumerName.toString(),
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
                                            appliedJob.createdAt != null
                                                ? GenericAppFunctions
                                                    .getFormattedDate(appliedJob
                                                        .createdAt
                                                        .toString())
                                                : "",
                                            style: Styles.simpleTextColored,
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            appliedJob.deadline != null
                                                ? GenericAppFunctions
                                                    .getFormattedDate(appliedJob
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
                        appliedJob.address.toString(),
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
                                  child: GestureDetector(
                                    onTap: (){
          if (appliedJob.status ==
          JobConstants
              .USER_APPLIED_TO_OPEN_JOB) {
          Navigator.pop(context);
          editProposalBottomSheet(
          AppConstants.baseContext,
          appliedJob);}
                                    },
                                    child: Row(children: [
                                      Text(
                                        'bid_amount'.tr,
                                        style: Styles.simpleText,
                                      ),appliedJob.status ==
                                          JobConstants
                                              .USER_APPLIED_TO_OPEN_JOB
                                          ? const Icon(
                                        Icons.edit,
                                        color: Colors.red,
                                        size: 20,
                                      )
                                          : SizedBox()
                                    ],),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      // if (appliedJob.status ==
                                      //     JobConstants
                                      //         .USER_APPLIED_TO_OPEN_JOB) {
                                      //   Navigator.pop(context);
                                      //   editProposalBottomSheet(
                                      //       AppConstants.baseContext,
                                      //       appliedJob);
                                      // }
                                    },
                                    child: Row(children: [
                                      Text(
                                        'receivable_amount'.tr,
                                        style: Styles.simpleText,
                                      ),

                                    ]),
                                  )
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    appliedJob.bidAmount != null
                                        ? responseLoginUser
                                        .user.currencySymbol! +
                                        appliedJob.bidAmount.toString()
                                        : "",
                                    style: Styles.textStyleJobSheetbudget,
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    appliedJob.spReceivableAmount != null
                                        ? responseLoginUser
                                        .user.currencySymbol! +
                                        appliedJob.spReceivableAmount
                                            .toString()
                                        : "",
                                    style:
                                    Styles.textStyleJobSheetbudgetColored,
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
                              getStatusMessage(appliedJob.status, appliedJob),
                              style: Styles.textStyleStatusColor),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              areaButton
                                  ? Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 20, left: 5, right: 10),

                                          // width: double.infinity,
                                          child: ElevatedButton(
                                            style: Styles
                                                .appElevatedJobStatusButtonStyle,
                                            onPressed: () {
                                              print(
                                                  "ClickedJobStatus${appliedJob.status}");
                                              Navigator.pop(context);
                                              if (appliedJob.status ==
                                                  JobConstants
                                                      .INVITED_FOR_JOB) {
                                                _showBottomSheetApplyOnJob(
                                                    AppConstants.baseContext,
                                                    appliedJob);
                                              } else {
                                                showDisclaimerDialog(
                                                    mContext,
                                                    getDisclaimernMessages(
                                                        appliedJob.status),
                                                    appliedJob,
                                                    0);
                                              }
                                            },
                                            child: Text(buttonText,
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          )),
                                    )
                                  : Container(),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 20, right: 10),

                                    // width: double.infinity,
                                    child: ElevatedButton(
                                      style: Styles
                                          .appElevatedJobStatusButtonStyle,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDisclaimerDialog(
                                            mContext,
                                            responseLoginUser.user.spMessages
                                                .sp_job_cancel_discl.message
                                                .toString(),
                                            appliedJob,
                                            JobConstants.CANCELED_STATUS);
                                      },
                                      child: Text('str_cancel'.tr,
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  String getStatusMessage(int? status, Applied _applied) {
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

  void HandleClickListner(int? status, Applied appliedJob) async {
    if (status == JobConstants.HIRED_STATUS) {
      String chatMessageCurrent;
      String chatMessageOther;
      chatMessageCurrent = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.ACCEPTED_JOB_CURRENT_USER_MESSAGE),
          [
            appliedJob.jobTitle,
            appliedJob.consumerName,
            appliedJob.consumerName,
          ]);

      chatMessageOther = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.ACCEPTED_JOB_OTHER_USER_MESSAGE),
          [appliedJob.jobTitle, responseLoginUser.user.firstName]);

      print("PreAccept");
      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: appliedJob.jobId.toString(),
              status: JobConstants.SP_ACCEPTED.toString(),
              userId: appliedJob.userId.toString()),
          apiKey.toString(),
          responseLoginUser.user.firebaseUid.toString(),
          appliedJob.firebaseUid.toString(),
          chatMessageCurrent,
          FireBaseConstants.applyJobAccepted,
          responseLoginUser.user.firstName.toString(),
          chatMessageOther,
          context);
      print("PostAccepccept");
      if (_appController.generalResponse != null) {
        if (_appController.generalResponse!.status == "success") {
          print(
              "JoAccepted${JobConstants.list_sp_applied_jobs[viewJobIndex].jobTitle}");
          showToast("Job accepted successfully ",
              context: context, backgroundColor: Colors.green);
          JobConstants.list_sp_applied_jobs[viewJobIndex].status =
              JobConstants.SP_ACCEPTED;
          setState(() {});
        } else {
          showToast(_appController.generalResponse!.message,
              context: context, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to start this job",
            context: context, backgroundColor: Colors.red);
      }
    }
    // if (status == JobConstants.INVITED_FOR_JOB) {
    //   _showBottomSheetApplyOnJob(context, appliedJob);
    // }
    if (status == JobConstants.PAYMENTDONE) {
      print("HandlePaymentDone");
      String chatMessageCurrent;
      String chatMessageOther;
      chatMessageCurrent = sprintf(
          GetChatMessageJob()
              .getChatMessage(FireBaseConstants.startedJobCurrentUserMessage),
          [appliedJob.jobTitle, appliedJob.consumerName]);

      chatMessageOther = sprintf(
          GetChatMessageJob()
              .getChatMessage(FireBaseConstants.startedJobOtherUserMessage),
          [responseLoginUser.user.firstName, appliedJob.jobTitle]);

      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: appliedJob.jobId.toString(),
              status: JobConstants.STARTED_STATUS.toString(),
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
        //Navigator.pop(context);
        if (_appController.generalResponse!.status == "success") {
          print(
              "JoAccepted${JobConstants.list_sp_applied_jobs[viewJobIndex].jobTitle}");
          showToast("Job started successfully ",
              context: context, backgroundColor: Colors.green);
          JobConstants.list_sp_started_jobs
              .add(JobConstants.list_sp_applied_jobs[viewJobIndex]);
          JobConstants.list_sp_applied_jobs[viewJobIndex].status =
              JobConstants.STARTED_STATUS;
          JobConstants.list_sp_applied_jobs
              .remove(JobConstants.list_sp_applied_jobs[viewJobIndex]);
          setState(() {});
        } else {
          showToast(_appController.generalResponse!.message,
              context: context, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to start this Job",
            context: context, backgroundColor: Colors.red);
      }
    }
  }

  void HandleCancelClickListner(int? status, Applied appliedJob) async {
    print("MakeCancelCalle");

    String chatMessageCurrent;
    String chatMessageOther;
    chatMessageCurrent = sprintf(
        GetChatMessageJob()
            .getChatMessage(FireBaseConstants.cancelSpCurrentMessage),
        [appliedJob.jobTitle, appliedJob.consumerName]);

    chatMessageOther = sprintf(
        GetChatMessageJob()
            .getChatMessage(FireBaseConstants.cancelSpOtherMessage),
        [responseLoginUser.user.firstName, appliedJob.jobTitle]);

    await _appController.changeJobStatus(
        QueryChangeJobStatus(
            jobId: appliedJob.jobId.toString(),
            status: JobConstants.CANCELED_STATUS.toString(),
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
      //Navigator.pop(context);
      if (_appController.generalResponse!.status == "success") {
        print(
            "JoAccepted${JobConstants.list_sp_applied_jobs[viewJobIndex].jobTitle}");
        showToast("Job Cancelled successfully ",
            context: context, backgroundColor: Colors.green);

        JobConstants.list_sp_closed_jobs
            .add(JobConstants.list_sp_applied_jobs[viewJobIndex]);
        JobConstants.list_sp_applied_jobs[viewJobIndex].status =
            JobConstants.CANCELED_STATUS;
        JobConstants.list_sp_applied_jobs
            .remove(JobConstants.list_sp_applied_jobs[viewJobIndex]);
        setState(() {});
      } else {
        showToast(_appController.generalResponse!.message,
            context: context, backgroundColor: Colors.red);
      }
    } else {
      showToast("Unable to Cancel this Job",
          context: context, backgroundColor: Colors.red);
    }
  }

//handle withdraw
  void HandleWithDrawClickListner(int? status, Applied appliedJob) async {
    print("WithDrawRequest");

    String chatMessageCurrent;
    String chatMessageOther;
    chatMessageCurrent = sprintf(
        GetChatMessageJob()
            .getChatMessage(FireBaseConstants.withDrawUserCurrentMessage),
        [appliedJob.jobTitle, appliedJob.consumerName]);

    chatMessageOther = sprintf(
        GetChatMessageJob()
            .getChatMessage(FireBaseConstants.withDrawUserOtherMessage),
        [responseLoginUser.user.firstName, appliedJob.jobTitle]);

    await _appController.changeJobStatus(
        QueryChangeJobStatus(
            jobId: appliedJob.jobId.toString(),
            status: JobConstants.APPLICANT_WITHDRAW_REQUEST.toString(),
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
      //Navigator.pop(context);
      if (_appController.generalResponse!.status == "success") {
        print(
            "JoAccepted${JobConstants.list_sp_applied_jobs[viewJobIndex].jobTitle}");
        showToast("Job Cancelled successfully ",
            context: context, backgroundColor: Colors.green);

        JobConstants.list_sp_closed_jobs
            .add(JobConstants.list_sp_applied_jobs[viewJobIndex]);
        JobConstants.list_sp_applied_jobs[viewJobIndex].status =
            JobConstants.APPLICANT_WITHDRAW_REQUEST;
        JobConstants.list_sp_applied_jobs
            .remove(JobConstants.list_sp_applied_jobs[viewJobIndex]);
        setState(() {});
      } else {
        showToast(_appController.generalResponse!.message,
            context: context, backgroundColor: Colors.red);
      }
    } else {
      showToast("Unable to start this Job",
          context: context, backgroundColor: Colors.red);
    }
  }

  _showBottomSheetApplyOnJob(BuildContext context, Applied appliedJob) {
    print("OpenSheet");
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
        builder: (BuildContext sheetcontext) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('customer_budget'.tr, style: Styles.headingText),
                          Text(
                              responseLoginUser.user.currencySymbol! +
                                  appliedJob.customerBudget.toString(),
                              style: Styles.headingTextColor)
                        ],
                      ),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 230, 230, 230),
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 0.30),
                          ),
                          child: DropdownButton<String>(
                            onChanged: (value) {},
                            value: dropdownValue,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            items: spinnerItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        color: const Color.fromARGB(255, 230, 230, 230),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'plzz enter budget';
                            }
                            return null;
                          },
                          controller: budgetAmount,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (String value) async {
                            double enter_amount = double.parse(value);
                            double fee_amount = enter_amount *
                                double.parse(
                                    responseLoginUser.user.spfee.toString());
                            odlayfee = fee_amount.ceil().toString();
                            receivableAmount =
                                (enter_amount - fee_amount).floor().toString();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor:
                                  const Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              hintText: 'str_apply_amoutn'.tr +
                                  '${responseLoginUser.user.currencySymbol}',
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.7),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 5),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text('odlay_fee'.tr, style: Styles.headingText),
                      //       Text(
                      //           "${responseLoginUser.user.currencySymbol}${odlayfee}",
                      //           style: Styles.headingTextColor)
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sprintf(
                                responseLoginUser.user.spMessages.sp_payment_info.message,[odlayfeePecentage+" %"]),
                                style: Styles.sp_note_style),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('receibal_amount_whill_applying'.tr,
                                style: Styles.headingText),
                            Text(
                                "${responseLoginUser.user.currencySymbol}${receivableAmount}",
                                style: Styles.headingTextColor)
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        color: const Color.fromARGB(255, 230, 230, 230),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'plzz enter Time';
                            }
                            return null;
                          },
                          controller: timeToComplete,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor:
                                  const Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              hintText: 'time_to_complete'.tr,
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.7),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: const Color.fromARGB(255, 230, 230, 230),
                        child: TextFormField(
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'plzz enter Service descripton';
                            }
                            return null;
                          },
                          controller: serviceDescription,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor:
                                  const Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              hintText: 'service_desc'.tr,
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.7),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 40,
                        width: double.infinity,
                        child: Obx(() => AppElevatedButton(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: () async {
//remove above code
                                if (budgetAmount.text.isEmpty) {
                                  showToast(
                                      "min budget amount is${responseLoginUser.user.min_amount}",
                                      context: context,
                                      backgroundColor: Colors.red);
                                } else if (int.parse(
                                        budgetAmount.text.toString()) <
                                    int.parse(responseLoginUser.user.min_amount
                                        .toString())) {
                                  showToast(
                                      "min budget amount is${responseLoginUser.user.min_amount}",
                                      context: context,
                                      backgroundColor: Colors.red);
                                } else if (int.parse(
                                        budgetAmount.text.toString()) >
                                    int.parse(responseLoginUser.user.max_amount
                                        .toString())) {
                                  showToast(
                                      "max budget amount is${responseLoginUser.user.max_amount}",
                                      context: context,
                                      backgroundColor: Colors.red);
                                } else {
                                  String chatMessageOther = sprintf(
                                      GetChatMessageJob().getChatMessage(
                                          FireBaseConstants
                                              .applyUserOtherMessage),
                                      [
                                        responseLoginUser.user.firstName,
                                        appliedJob.jobTitle,
                                        budgetAmount.text.toString() +
                                            responseLoginUser
                                                .user.currencySymbol
                                                .toString(),
                                        timeToComplete.text.toString(),
                                      ]);
                                  String chatMessageCurrent = sprintf(
                                      GetChatMessageJob().getChatMessage(
                                          FireBaseConstants
                                              .applyUserCurrentMessage),
                                      [
                                        appliedJob.jobTitle,
                                        budgetAmount.text.toString() +
                                            responseLoginUser
                                                .user.currencySymbol
                                                .toString(),
                                        timeToComplete.text.toString(),
                                      ]);
                                  print("PreApplyJob");
                                  await _appController.applyJob(
                                      QueryApplyJob(
                                          apiKey: apiKey.toString(),
                                          budgetAmount:
                                              budgetAmount.text.toString(),
                                          budgetOption: dropdownValue,
                                          duration:
                                              timeToComplete.text.toString(),
                                          jobid: appliedJob.jobId,
                                          message: serviceDescription.text
                                              .toString(),
                                          userId: responseLoginUser
                                              .user.serviceProviders.userId
                                              .toString()),
                                      apiKey.toString(),
                                      responseLoginUser.user.firebaseUid
                                          .toString(),
                                      appliedJob.firebaseUid.toString(),
                                      chatMessageCurrent,
                                      responseLoginUser.user.firstName
                                          .toString(),
                                      FireBaseConstants.typeApplyJob,
                                      chatMessageOther,
                                      context);

                                  print("PostApplyJob");
                                  Navigator.pop(context);
                                  if (_appController.generalResponse != null) {
                                    {
                                      if (_appController
                                              .generalResponse!.status ==
                                          "success") {
                                        updateApplyStatus(
                                            budgetAmount.text.toString(),
                                            odlayfee,
                                            receivableAmount);
                                      } else {
                                        // showToast(
                                        //     _appController
                                        //         .generalResponse!.message,
                                        //     context: context,
                                        //     backgroundColor: Colors.red);
                                      }
                                    }
                                  } else {
                                    showToast(
                                        "Unable to Apply on job please try again later",
                                        context: context,
                                        backgroundColor: Colors.red);
                                  }
                                }
                              },
                              child: Text(
                                  _appController.responseApplyJobLoading.value
                                      ? 'str_applying'.tr
                                      : 'btn_apply'.tr),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  String getMessageButton(int? status) {
    String btnText = 'accept'.tr;
    if (status == JobConstants.SP_ACCEPTED) {
      btnText = responseLoginUser.user.spMessages.spPaymentAlert.message;
    }
    if (status == JobConstants.HIRED_STATUS) {}
    if (status == JobConstants.INVITED_FOR_JOB) {
      btnText = 'btn_apply'.tr;
    }
    if (status == JobConstants.STARTED_STATUS) {}
    if (status == JobConstants.DISPUTED_STATUS) {}
    if (status == JobConstants.DELIVERED_STATUS) {}
    if (status == JobConstants.NOT_VIEWED_STATUS ||
        status == JobConstants.USER_APPLIED_AFTER_INVITATION ||
        status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {}
    if (status == JobConstants.PAYMENTDONE) {
      btnText = 'btn_start'.tr;
    }
    return btnText;
  }

  bool showValueJob(int? status) {
    bool btnText = false;
    if (status == JobConstants.SP_ACCEPTED) {
      btnText = false;
    }
    if (status == JobConstants.HIRED_STATUS) {
      btnText = true;
    }
    if (status == JobConstants.INVITED_FOR_JOB) {
      btnText = true;
    }
    if (status == JobConstants.STARTED_STATUS) {}
    if (status == JobConstants.DISPUTED_STATUS) {}
    if (status == JobConstants.DELIVERED_STATUS) {}
    if (status == JobConstants.NOT_VIEWED_STATUS ||
        status == JobConstants.USER_APPLIED_AFTER_INVITATION ||
        status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {}
    if (status == JobConstants.PAYMENTDONE) {
      btnText = true;
    }
    return btnText;
  }

  void showDisclaimerDialog(BuildContext context1, String text, Applied applied,
      int currentJobStatus) {
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
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Html(data: text, style: {
                            'li': Style(
                                color: Colors.black,
                                fontSize: FontSize(10.0),
                                ),
                            'h4': Style(color: Color.fromARGB(255, 53, 52, 52),
                                fontSize: FontSize(13.0))
                          }),
                        ),
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
                                print("AcceptButtonClickedApplied");
                                if (currentJobStatus ==
                                    JobConstants.CANCELED_STATUS) {
                                  print("CancelledClicked${applied.status}");
                                  if (applied.status ==
                                          JobConstants.USER_APPLIED_TO_OPEN_JOB ||
                                      applied.status ==
                                          JobConstants.INVITED_FOR_JOB) {
                                    HandleWithDrawClickListner(
                                        applied.status, applied);
                                  } else {
                                    HandleCancelClickListner(
                                        applied.status, applied);
                                  }
                                } else {
                                  HandleClickListner(applied.status, applied);
                                }
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
    if (status == JobConstants.HIRED_STATUS) {
      discaimerMessage = responseLoginUser.user.spMessages.spJobAccept.message;
    }
    if (status == JobConstants.PAYMENTDONE) {
      discaimerMessage =
          responseLoginUser.user.spMessages.spJobFinishDiscl.message;
    }

    return discaimerMessage;
  }

  int getClickedJobIndex(Applied applied) {
    print("JobTitleClicked${applied.jobTitle}");
    int updateIndex = -1;
    int applicantIndex =
        JobConstants.list_sp_applied_jobs.indexWhere((job) => job == job);
    updateIndex = applicantIndex;
    return updateIndex;
  }

  void updateApplyStatus(String bidAmount, String odlayfee, String receiable) {
    JobConstants.list_sp_applied_jobs[viewJobIndex].status =
        JobConstants.USER_APPLIED_TO_OPEN_JOB;
    JobConstants.list_sp_applied_jobs[viewJobIndex].bidAmount = bidAmount;
    JobConstants.list_sp_applied_jobs[viewJobIndex].odlayFee = odlayfee;
    JobConstants.list_sp_applied_jobs[viewJobIndex].spReceivableAmount =
        receiable;
    setState(() {});
  }

  editProposalBottomSheet(BuildContext context, Applied appliedJob) {
    print("OpenSheet");
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
        builder: (BuildContext sheetcontext) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'str_title_sheet_edit_proposal'.tr,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 10),
                        color: const Color.fromARGB(255, 230, 230, 230),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'plzz enter budget';
                            }
                            return null;
                          },
                          controller: editbudgetAmount,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (String value) async {
                            double enter_amount = double.parse(value);
                            double fee_amount = enter_amount *
                                double.parse(
                                    responseLoginUser.user.spfee.toString());
                            odlayfeeEditProposal = fee_amount.ceil().toString();
                            receivableAmountEditProposal =
                                (enter_amount - fee_amount).floor().toString();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor:
                                  const Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              hintText: 'str_apply_amoutn'.tr +
                                  '${responseLoginUser.user.currencySymbol}',
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    width: 0.7),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('odlay_fee'.tr, style: Styles.headingText),
                            Text(
                                "${responseLoginUser.user.currencySymbol}${odlayfeeEditProposal}",
                                style: Styles.headingTextColor)
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('your_receivable_amount'.tr,
                                style: Styles.headingText),
                            Text(
                                "${responseLoginUser.user.currencySymbol}${receivableAmountEditProposal}",
                                style: Styles.headingTextColor)
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, top: 10),
                        height: 40,
                        width: double.infinity,
                        child: Obx(() => AppElevatedButton(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: () async {
                                if (editbudgetAmount.text.isEmpty) {
                                  showToast(
                                      "min budget amount is${responseLoginUser.user.min_amount}",
                                      context: context,
                                      backgroundColor: Colors.red);
                                } else if (int.parse(
                                        editbudgetAmount.text.toString()) <
                                    int.parse(responseLoginUser.user.min_amount
                                        .toString())) {
                                  showToast(
                                      "min budget amount is${responseLoginUser.user.min_amount}",
                                      context: context,
                                      backgroundColor: Colors.red);
                                } else if (int.parse(
                                        editbudgetAmount.text.toString()) >
                                    int.parse(responseLoginUser.user.max_amount
                                        .toString())) {
                                  showToast(
                                      "max budget amount is${responseLoginUser.user.max_amount}",
                                      context: context,
                                      backgroundColor: Colors.red);
                                } else {
                                  String chatMessageOther = sprintf(
                                      GetChatMessageJob().getChatMessage(
                                          FireBaseConstants
                                              .SP_EDIT_PROPOSAL_OTHER_USER_MESSAGE),
                                      [
                                        responseLoginUser.user.firstName,
                                        appliedJob.jobTitle,
                                      ]);
                                  String chatMessageCurrent = sprintf(
                                      GetChatMessageJob().getChatMessage(
                                          FireBaseConstants
                                              .SP_EDIT_PROPOSAL_CURRENT_USER_MESSAGE),
                                      [
                                        appliedJob.jobTitle,
                                      ]);
                                  await _appController.editProposal(
                                      QuerEditProposal(
                                          jobId: appliedJob.jobId.toString(),
                                          applicantId:
                                              appliedJob.userId.toString(),
                                          budgetAmount:
                                              editbudgetAmount.text.toString()),
                                      apiKey.toString(),
                                      responseLoginUser.user.firebaseUid
                                          .toString(),
                                      appliedJob.firebaseUid.toString(),
                                      chatMessageCurrent,
                                      responseLoginUser.user.firstName
                                          .toString(),
                                      FireBaseConstants.typeApplyJob,
                                      chatMessageOther,
                                      context);
                                  if (_appController.generalResponse != null) {
                                    if (_appController
                                            .generalResponse!.status ==
                                        "success") {
                                      Navigator.pop(context);
                                      updateBidAmountStatus(
                                          editbudgetAmount.text.toString(),
                                          odlayfeeEditProposal,
                                          receivableAmountEditProposal);
                                    }
                                  } else {}
                                }
                              },
                              child: Text(_appController
                                      .responseEditProposalLoading.value
                                  ? 'updating'.tr
                                  : 'update'.tr),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void updateBidAmountStatus(
      String updatedAmount, String odlay_fee, String receivable) {
    JobConstants.list_sp_applied_jobs[viewJobIndex].bidAmount = updatedAmount;
    JobConstants.list_sp_applied_jobs[viewJobIndex].odlayFee = odlay_fee;
    JobConstants.list_sp_applied_jobs[viewJobIndex].spReceivableAmount =
        receivable;
    setState(() {});
  }
}
