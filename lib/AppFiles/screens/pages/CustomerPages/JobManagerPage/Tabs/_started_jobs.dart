import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/CameraPromt.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/GetChatMessagesJob.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_change_job_status.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/PaymentModels/_query_get_stripe_key.dart';
import 'package:odlay_services/AppFiles/model/PaymentModels/_query_process_payment.dart';
import 'package:odlay_services/AppFiles/model/Review/_query_post_review.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_chat_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_review_bottom_sheet_body.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/Tabs/_started_jobs_widgets/_item_started_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:sprintf/sprintf.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class StartedJobs extends StatefulWidget {
  BuildContext mainContext;
  StartedJobs(this.mainContext);
  late ResponseCustomersShowJobs reviewJob;
  @override
  State<StartedJobs> createState() => _StartedJobsState();
}

class _StartedJobsState extends State<StartedJobs> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  AppController _appController = Get.put(AppController());
  int? appRegion;
  late int selectMethod;
  late String? apiKey;
  int viewJobIndex = -1;
  double userRating = 1;
  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];
  TextEditingController jobDescription = TextEditingController();
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    print("AppRegion$appRegion");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 1), () async {
          print("RefreshViewCalled");
          await _appController.getCustomerJobs(
              QueryCustomersShowJobs(
                  apiKey: apiKey.toString(),
                  userId:
                      responseLoginUser.user.serviceProviders.userId.toString(),
                  language: responseLoginUser.user.language,
                  callFrom: "refresh"),
              apiKey.toString(),
              false);
          setState(() {});
        });
      },
      child: Container(
          child: ListView.builder(
              itemCount: JobConstants.list_cus_started_jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      var jobId = JobConstants.list_cus_started_jobs[index].id;
                      print("OpenJobSheetProgress$jobId");
                      viewJobIndex = index;
                      manageBottomSheets(
                          JobConstants.list_cus_started_jobs[index].status,
                          JobConstants.list_cus_started_jobs[index],
                          context);
                    },
                    child: ItemCustomerStartedJobs(
                        JobConstants.list_cus_started_jobs[index],
                        responseLoginUser));
              })),
    );
  }

  showBottomSheetJobDetailPayment(
      BuildContext context, ResponseCustomersShowJobs job) {
    print("OpenSheetJobStatus${job.status}");
    JobApplicant jobApplicant = getJobApplicant(job.status, job.jobApplicants);
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
          return Stack(
            children: [
              SingleChildScrollView(
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
                          job.title.toString(),
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    AppConstants.PROFILEIMAGESURLS +
                                        responseLoginUser.user.logo.toString(),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      responseLoginUser.user.firstName
                                          .toString(),
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
                                              "",
                                              style: Styles.simpleTextData,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              job.createdAt != null
                                                  ? GenericAppFunctions
                                                      .getFormattedDate(job
                                                          .createdAt
                                                          .toString())
                                                  : "",
                                              style: Styles.simpleTextData,
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
                                              'bid_amount'.tr,
                                              style: Styles.simpleText,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              'payable_amout'.tr,
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
                                            child:Text(
                                              jobApplicant.bidAmount != null
                                                  ? responseLoginUser
                                                  .user.currencySymbol
                                                  .toString() +
                                                  jobApplicant.bidAmount
                                                      .toString()
                                                  : "",
                                              style: Styles
                                                  .textStyleJobSheetbudgetColoredCustomer,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              jobApplicant.totalCharged != null
                                                  ? responseLoginUser
                                                  .user.currencySymbol
                                                  .toString() +
                                                  jobApplicant.totalCharged
                                                      .toString()
                                                  : "",
                                              style:
                                              Styles.textStyleStatusColor,
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
                      margin: const EdgeInsets.only(top: 5, left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(sprintf(
                            responseLoginUser.user.custMessages.cust_payment_info.message,
                            [(double.parse(responseLoginUser.user.custfee.toString())*100).toString()+" %"])+"",
                            style: Styles.sp_note_style),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('rewarded_to'.tr,
                              style: Styles.textStyleJobTitle)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("Go to profile");
                                    Datum serviceProvider = Datum(
                                        id: jobApplicant.id,
                                        firebaseUid:
                                            jobApplicant.firebaseUid.toString(),
                                        deviceToken: "",
                                        serviceId: jobApplicant.userId,
                                        address: jobApplicant.address,
                                        cityId: 3,
                                        streetNo: "",
                                        latitude: jobApplicant.latitude,
                                        longitude: jobApplicant.longitude,
                                        defaultView:
                                            jobApplicant.logo.toString(),
                                        title: "",
                                        companyId: 1,
                                        email: "",
                                        firstName:
                                            jobApplicant.firstName.toString(),
                                        lastName: "",
                                        logo: jobApplicant.logo,
                                        phone: jobApplicant.phone,
                                        roleId: 1,
                                        status: 1,
                                        idCardStatus: jobApplicant.idCardStatus,
                                        addressProofStatus:
                                            jobApplicant.addressProofStatus,
                                        profilePicStatus:
                                            jobApplicant.profilePicStatus,
                                        portfolioImages: "",
                                        allowMobileCall: 1,
                                        rating: "3",
                                        distance: 1000,
                                        reviewsCount: 3,
                                        spcount: 1);

                                    Navigator.of(widget.mainContext).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileLandingVisitPage(
                                                    serviceProvider)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    child: Image.network(
                                      AppConstants.PROFILEIMAGESURLS +
                                          jobApplicant.logo.toString(),
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(AppConstants.baseContext).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatDetailPage(
                                                    jobApplicant.firstName
                                                        .toString(),
                                                    jobApplicant.firebaseUid
                                                        .toString(),
                                                    jobApplicant.logo
                                                        .toString(),
                                                    jobApplicant.phone
                                                        .toString())));
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
                                margin: const EdgeInsets.only(left: 5),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          jobApplicant.firstName.toString(),
                                          style: Styles.textProfileStyle1),
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
                                          jobApplicant.skills != null &&
                                                  jobApplicant
                                                      .skills!.isNotEmpty
                                              ? GenericAppFunctions
                                                      .getSkillNameFromApplicantSkillList(
                                                          jobApplicant.skills)
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
                                          jobApplicant.address.toString(),
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
                      margin: const EdgeInsets.only(top: 5, left: 20),
                      child: Text(manageStatus(job.status, job, jobApplicant),
                          style: Styles.textStyleStatusColor),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 20, left: 15, right: 20),

                                // width: double.infinity,
                                child: ElevatedButton(
                                  style: Styles.appElevatedJobStatusButtonStyle,
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    showDisclaimerDialog(
                                        context,
                                        responseLoginUser.user.custMessages
                                            .cust_job_cancel_discl.message,
                                        job,
                                        jobApplicant,
                                        JobConstants.CANCELED_STATUS);
                                  },
                                  child: Text(
                                    'str_cancel_this_job'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 20, left: 15, right: 20),
                                width: double.infinity,
                                // width: double.infinity,
                                child: ElevatedButton(
                                  style: Styles.appElevatedJobStatusButtonStyle,
                                  onPressed: () async {
                                    print("PaymentCliked$appRegion");
                                    if (appRegion ==
                                        SharePrefrencesValues
                                            .REGION_UNIVERSAL) {
                                      Navigator.pop(context);
                                      showPaymentSelectionSheet(
                                          context, job, jobApplicant);
                                    } else {
                                      Navigator.pop(context);
                                      selectMethod = JobConstants.CARD_PAYMENT;
                                      await _appController.getStripeKey(
                                          QueryGetStripeKey(
                                              currency: responseLoginUser
                                                  .user.currencyTitle
                                                  .toString(),
                                              items: [
                                                Item(
                                                    amount: jobApplicant
                                                        .totalCharged
                                                        .toString(),
                                                    jobId: job.id.toString())
                                              ]),
                                          apiKey.toString());
                                      if (_appController.responseGetStripeKey !=
                                          null) {
                                        getCheckout(context, job, jobApplicant);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'str_btn_payment'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  String manageStatus(
      int? status, ResponseCustomersShowJobs job, JobApplicant _applicant) {
    String statusMessage = "";
    if (status == JobConstants.STARTED_STATUS) {
      statusMessage = sprintf(
          responseLoginUser.user.custMessages.custJobStarted.message,
          [_applicant.firstName]);
    }
    if (status == JobConstants.DISPUTED_STATUS) {
      statusMessage = responseLoginUser.user.custMessages.custComplaint.message;
    }
    if (status == JobConstants.SP_ACCEPTED) {
      statusMessage = sprintf(
          responseLoginUser.user.custMessages.custPaymentAlert.message,
          [_applicant.firstName.toString()]);
    }
    if (status == JobConstants.HIRED_STATUS) {
      statusMessage = "Awating Service Providers confirmation";
    }
    if (status == JobConstants.DELIVERED_STATUS) {
      statusMessage = sprintf(
          responseLoginUser.user.custMessages.custJobCompletedAlert.message,
          [_applicant.firstName.toString()]);
    }
    if (status == JobConstants.PAYMENTDONE) {
      print("PaymentMethodStatusSheet${job.paymentMethod}");
      if (job.paymentMethod == JobConstants.CASH_PAYMENT) {
        statusMessage =
            responseLoginUser.user.custMessages.custPaymentDoneCash.message;
      } else if (job.paymentMethod == JobConstants.CARD_PAYMENT) {
        statusMessage =
            responseLoginUser.user.custMessages.custPaymentDoneOnline.message;
      }
    }
    return statusMessage;
  }

  showPaymentSelectionSheet(BuildContext Selectioncontext,
      ResponseCustomersShowJobs job, JobApplicant jobApplicant) {
    selectMethod = JobConstants.CASH_PAYMENT;
    _appController.getStripeKey(
        QueryGetStripeKey(currency: "pkr", items: [
          Item(
              amount: jobApplicant.totalCharged.toString(),
              jobId: job.id.toString())
        ]),
        apiKey.toString());
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
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Available Payment Methods",
                                style: Styles.textStyleJobTitle,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectMethod = JobConstants.CASH_PAYMENT;
                              setState(() {});
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: selectMethod == JobConstants.CASH_PAYMENT
                                    ? BorderSide(color: Colors.red, width: 1)
                                    : BorderSide(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.only(top: 20),
                              elevation: 2,
                              child: Row(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          height: 50,
                                          width: 50,
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: AssetImage(
                                              'assets/payment_by_cash.png',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Cash",
                                            style: Styles.headingText,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print("CardMethodClicked");
                              selectMethod = JobConstants.CARD_PAYMENT;
                              setState(() {});
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: selectMethod == JobConstants.CARD_PAYMENT
                                    ? BorderSide(color: Colors.red, width: 1)
                                    : BorderSide(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 2,
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          height: 50,
                                          width: 50,
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: AssetImage(
                                              'assets/payment_by_card.png',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Visa/Master/Other Cards",
                                            style: Styles.headingText,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        height: 50,
                                        width: 50,
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                            'assets/ic_easy_paisa.png',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Easy Paisa",
                                          style: Styles.headingText,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "coming soon",
                                      style: Styles.headingTextColor,
                                    ))
                              ],
                            ),
                          ),
                          Card(
                            elevation: 2,
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        height: 50,
                                        width: 50,
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                            'assets/ic_jazzcash.png',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Jazz Cash",
                                          style: Styles.headingText,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "coming soon",
                                      style: Styles.headingTextColor,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          SizedBox(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Selected Payment Methods",
                                style: Styles.textStyleJobTitle,
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.only(top: 20),
                            elevation: 2,
                            child: Row(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        height: 50,
                                        width: 50,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                            selectMethod ==
                                                    JobConstants.CARD_PAYMENT
                                                ? 'assets/payment_by_card.png'
                                                : "assets/payment_by_cash.png",
                                          ),
                                        ),
                                      ),
                                      Text(
                                        selectMethod ==
                                                JobConstants.CARD_PAYMENT
                                            ? "Visa/Master/Other Cards"
                                            : "Cash",
                                        style: Styles.headingText,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ])),
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 20),
                        child: Obx(() => ElevatedButton(
                              style: _appController.isGettingStripeKey == true
                                  ? Styles
                                      .appElevatedJobStatusButtonStyleDisable
                                  : Styles.appElevatedJobStatusButtonStyle,
                              onPressed: () async {
                                if (selectMethod == JobConstants.CARD_PAYMENT) {
                                  if (_appController.responseGetStripeKey !=
                                      null) {
                                    Navigator.pop(context);
                                    getCheckout(
                                        Selectioncontext, job, jobApplicant);
                                  }
                                } else {
                                  print("Gando");

                                  String chatMessageCurrent;
                                  String chatMessageOther;

                                  chatMessageCurrent = sprintf(
                                      GetChatMessageJob().getChatMessage(
                                          FireBaseConstants
                                              .payment_CONFIRMED_CU_JOB_CURRENT_USER_MESSAGE),
                                      [
                                        "cash",
                                        job.title,
                                        jobApplicant.firstName
                                      ]);
                                  chatMessageOther = sprintf(
                                      GetChatMessageJob().getChatMessage(
                                          FireBaseConstants
                                              .paymentConfirmedCuJobOtherUserMessage1),
                                      [
                                        responseLoginUser.user.firstName,
                                        
                                        job.title
                                      ]);

                                  await _appController.processPayment(
                                      QueryProcessPayment(
                                          transactionId: _appController
                                              .responseGetStripeKey.transId,
                                          consumerId: responseLoginUser
                                              .user.consumer.userId,
                                          jobId: job.id.toString(),
                                          serviceId: jobApplicant.id
                                              .toString(),
                                          amountPaid: jobApplicant.totalCharged
                                              .toString(),
                                          amountPaidOrginal: 2000,
                                          status: selectMethod,
                                          paymentMethod: selectMethod),
                                      apiKey.toString());
//process payment if payment done success fully
                                  if (_appController.generalResponse != null) {
                                    if (_appController
                                            .generalResponse!.status ==
                                        "success") {
                                      print("Gando1");
                                      await _appController.changeJobStatus(
                                          QueryChangeJobStatus(
                                              jobId: job.id.toString(),
                                              status: JobConstants.PAYMENTDONE
                                                  .toString(),
                                              userId: jobApplicant.userId
                                                  .toString()),
                                          apiKey.toString(),
                                          responseLoginUser.user.firebaseUid
                                              .toString(),
                                          jobApplicant.firebaseUid.toString(),
                                          chatMessageCurrent,
                                          FireBaseConstants.applyJobPayment,
                                          responseLoginUser.user.firstName
                                              .toString(),
                                          chatMessageOther,
                                          context);
                                      print("PaymentStatusChange");
                                      if (_appController.generalResponse !=
                                          null) {
                                        if (_appController
                                                .generalResponse!.status ==
                                            "success") {
                                          Navigator.pop(context);
                                          updateCashAmount();
                                        } else {
                                          Navigator.pop(context);
                                          showToast(
                                              _appController
                                                  .generalResponse!.message,
                                              context: context,
                                              backgroundColor: Colors.red);
                                        }
                                      } else {
                                        Navigator.pop(context);
                                        showToast("Job Status is not changed",
                                            context: context,
                                            backgroundColor: Colors.red);
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      showToast(
                                          _appController
                                              .generalResponse!.message,
                                          context: context,
                                          backgroundColor: Colors.red);
                                    }
                                  } else {
                                    Navigator.pop(context);
                                    showToast("Unable to process payment",
                                        context: context,
                                        backgroundColor: Colors.red);
                                  }
                                }
                              },
                              child: const Text('Proceed'),
                            )))
                  ],
                ),
              ),
            );
          });
        });
  }

  void manageBottomSheets(
      int? status, ResponseCustomersShowJobs job, BuildContext context) {
    print("BottomSheetStatus$status");
    if (status == JobConstants.SP_ACCEPTED) {
      showBottomSheetJobDetailPayment(context, job);
    }
    if (status == JobConstants.HIRED_STATUS) {
      showBottomSheetJobDetail(context, job, false);
    }
    if (status == JobConstants.INVITED_FOR_JOB) {
      showBottomSheetJobDetail(context, job, false);
    }
    if (status == JobConstants.STARTED_STATUS) {
      showBottomSheetJobDetail(context, job, true);
    }
    if (status == JobConstants.DISPUTED_STATUS) {
      showBottomSheetJobDetail(context, job, false);
    }
    if (status == JobConstants.DELIVERED_STATUS) {
      print("JobDelivered");
      showBottomSheetJobDetail(context, job, false);
    }
    if (status == JobConstants.NOT_VIEWED_STATUS ||
        status == JobConstants.USER_APPLIED_AFTER_INVITATION ||
        status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {}
    if (status == JobConstants.PAYMENTDONE) {
      showBottomSheetJobDetail(context, job, true);
    }
  }

  Future<void> getCheckout(BuildContext context, ResponseCustomersShowJobs job,
      JobApplicant jobApplicant) async {
    try {
      await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  _appController.responseGetStripeKey.sintent,
              merchantDisplayName: "Odlay Services"));
    } catch (e) {
      print("InitlizationException$e");
      showToast(e.toString(), context: context, backgroundColor: Colors.green);
    }
    // setState(() {});
    displayPaymentSheet(context, job, jobApplicant);
  }

  Future<void> displayPaymentSheet(BuildContext context,
      ResponseCustomersShowJobs job, JobApplicant jobApp) async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet();
      String chatMessageCurrent;
      String chatMessageOther;

      chatMessageCurrent = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.payment_CONFIRMED_CU_JOB_CURRENT_USER_MESSAGE),
          ["card", job.title, jobApp.firstName]);
      chatMessageOther = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.paymentConfirmedCuJobOtherUserMessage),
          [responseLoginUser.user.firstName, job.title]);
      await _appController.processPayment(
          QueryProcessPayment(
              transactionId: _appController.responseGetStripeKey.transId,
              consumerId: responseLoginUser.user.consumer.userId,
              jobId: job.id.toString(),
              serviceId: jobApp.id.toString(),
              amountPaid: jobApp.totalCharged.toString(),
              amountPaidOrginal: 2000,
              status: selectMethod,
              paymentMethod: selectMethod),
          apiKey.toString());

//now change status

      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: job.id.toString(),
              status: JobConstants.PAYMENTDONE.toString(),
              userId: jobApp.userId.toString()),
          apiKey.toString(),
          responseLoginUser.user.firebaseUid.toString(),
          jobApp.firebaseUid.toString(),
          chatMessageCurrent,
          FireBaseConstants.applyJobPayment,
          responseLoginUser.user.firstName.toString(),
          chatMessageOther,
          context);
      if (_appController.generalResponse != null) {
        if (_appController.generalResponse!.status == "success") {
          print(
              "object${JobConstants.list_cus_started_jobs[viewJobIndex].title}");
          // Navigator.pop(context);

          updateCardPayment();
        } else {
          Navigator.pop(context);
          showToast(_appController.generalResponse!.message,
              context: context, backgroundColor: Colors.red);
        }
      } else {
        Navigator.pop(context);
        showToast("Job Status is not changed",
            context: context, backgroundColor: Colors.red);
      }
    } catch (e) {
      print("StripeDisplayException$e");
      showToast(e.toString(), context: context, backgroundColor: Colors.blue);
    }
  }

  JobApplicant getJobApplicant(int? status, List<JobApplicant>? jobApplicants) {
    JobApplicant hiredApplicant;
    print("TypeJob${status}");
    print("ApplicantList${jobApplicants!.length}");
    int applicantIndex = jobApplicants
        .indexWhere((jobApplicant) => jobApplicant.sp_job_status == status);
    print("FoundIndex${applicantIndex}");
    hiredApplicant = jobApplicants[applicantIndex];
    print("ApplicantName${hiredApplicant.firstName}");
    return hiredApplicant;
  }

  String getUserSkills(List<int> skillIds) {
    String skillName = "";
    print("SkillIds$skillIds");
    for (var sId in skillIds) {
      print("SkilId$sId");
      var Skill =
          skillCitiesProfessions.skills.where((skill) => skill.skillId == sId);
      print("SKillName${Skill.first}");
      skillName = skillName + "," + Skill.first.toString();
    }
    return skillName;
  }

  showBottomSheetJobDetail(
      BuildContext context, ResponseCustomersShowJobs job, bool showButton) {
    print("Tatta");
    print("OpenSheetJobStatus${job.status}");
    print("JobStatus${job.title}");
    JobApplicant jobApplicant = getJobApplicant(job.status, job.jobApplicants);
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
        builder: (
          BuildContext context,
        ) {
          return Stack(
            children: [
              SingleChildScrollView(
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
                            job.title.toString(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    child: Image.network(
                                      AppConstants.PROFILEIMAGESURLS +
                                          jobApplicant.logo.toString(),
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        responseLoginUser.user.firstName
                                            .toString(),
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
                                                    .getFormattedDate(job
                                                        .updatedAt
                                                        .toString()),
                                                style: Styles.simpleTextData,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                GenericAppFunctions
                                                    .getFormattedDate(job
                                                        .createdAt
                                                        .toString()),
                                                style: Styles.simpleTextData,
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
                                                'bid_amount'.tr,
                                                style: Styles.simpleText,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                'payable_amout'.tr,
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
                                                responseLoginUser
                                                    .user.currencySymbol! +
                                                    jobApplicant.bidAmount
                                                        .toString(),
                                                style: Styles
                                                    .textStyleJobSheetbudgetColoredCustomer,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                "${responseLoginUser.user.currencySymbol!}${jobApplicant.totalCharged}",
                                                style: Styles
                                                    .textStyleJobSheetbudgetColoredCustomer,
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
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('sp_bid_amount_message'.tr,
                              style: Styles.sp_note_style),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('rewarded_to'.tr,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        color: Color.fromRGBO(255, 118, 87, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)))),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print("Go to profile");
                                      Datum serviceProvider = Datum(
                                          id: jobApplicant.id,
                                          firebaseUid: jobApplicant.firebaseUid
                                              .toString(),
                                          deviceToken: "",
                                          serviceId: jobApplicant.userId,
                                          address: jobApplicant.address,
                                          cityId: 3,
                                          streetNo: "",
                                          latitude: jobApplicant.latitude,
                                          longitude: jobApplicant.longitude,
                                          defaultView:
                                              jobApplicant.logo.toString(),
                                          title: "",
                                          companyId: 1,
                                          email: "",
                                          firstName: jobApplicant.firstName,
                                          lastName: "",
                                          logo: jobApplicant.logo,
                                          phone: jobApplicant.phone,
                                          roleId: 1,
                                          status: 1,
                                          idCardStatus:
                                              jobApplicant.idCardStatus,
                                          addressProofStatus:
                                              jobApplicant.addressProofStatus,
                                          profilePicStatus:
                                              jobApplicant.profilePicStatus,
                                          portfolioImages: "",
                                          allowMobileCall: 1,
                                          rating: "3",
                                          distance: 1000,
                                          reviewsCount: 3,
                                          spcount: 1);

                                      Navigator.of(widget.mainContext).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileLandingVisitPage(
                                                      serviceProvider)));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: Image.network(
                                        AppConstants.PROFILEIMAGESURLS +
                                            jobApplicant.logo.toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(AppConstants.baseContext)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatDetailPage(
                                                      jobApplicant.firstName
                                                          .toString(),
                                                      jobApplicant.firebaseUid
                                                          .toString(),
                                                      jobApplicant.logo
                                                          .toString(),
                                                      jobApplicant.phone
                                                          .toString())));
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(AppConstants.baseContext)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatDetailPage(
                                                        jobApplicant.firstName
                                                            .toString(),
                                                        jobApplicant.firebaseUid
                                                            .toString(),
                                                        jobApplicant.logo
                                                            .toString(),
                                                        jobApplicant.phone
                                                            .toString())));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Image.asset(
                                          "assets/ic_chat.gif",
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          jobApplicant.firstName.toString(),
                                          style: Styles.textProfileStyle1),
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
                                          jobApplicant.skills != null &&
                                                  jobApplicant
                                                      .skills!.isNotEmpty
                                              ? GenericAppFunctions
                                                      .getSkillNameFromApplicantSkillList(
                                                          jobApplicant.skills)
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
                                          jobApplicant.address.toString(),
                                          style: Styles.textProfileStyle1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 5,
                          left: 10,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              manageStatus(job.status, job, jobApplicant),
                              style: Styles.textStyleStatusColor),
                        ),
                      ),
                      showButton
                          ? Center(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 20, top: 10, left: 10, right: 20),
                                  width: double.infinity,

                                  // width: double.infinity,
                                  child: ElevatedButton(
                                    style:
                                        Styles.appElevatedJobStatusButtonStyle,
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      showDisclaimerDialog(
                                          context,
                                          responseLoginUser.user.custMessages
                                              .cust_job_dispute_discl.message,
                                          job,
                                          jobApplicant,
                                          JobConstants.DISPUTED_STATUS);
                                    },
                                    child: Text('Dispute',
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))),
                                  )),
                            )
                          : Container(
                              child: job.status == JobConstants.DELIVERED_STATUS
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 20),

                                                // width: double.infinity,
                                                child: ElevatedButton(
                                                  style: Styles
                                                      .appElevatedJobStatusButtonStyle,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    showDisclaimerDialog(
                                                        context,
                                                        responseLoginUser
                                                            .user
                                                            .custMessages
                                                            .custJobCompleteDiscl
                                                            .message,
                                                        job,
                                                        jobApplicant,
                                                        JobConstants
                                                            .COMPLETED_STATUS);
                                                  },
                                                  child:  Text(
                                                      'mark_complete'.tr),
                                                )),
                                          ),
                                          Expanded(
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 20,
                                                    left: 10,
                                                    right: 0),

                                                // width: double.infinity,
                                                child: ElevatedButton(
                                                  style: Styles
                                                      .appElevatedJobStatusButtonStyle,
                                                  onPressed: () async {
                                                    showDisclaimerDialog(
                                                        context,
                                                        responseLoginUser
                                                            .user
                                                            .custMessages
                                                            .cust_job_not_finished_discl
                                                            .message,
                                                        job,
                                                        jobApplicant,
                                                        JobConstants
                                                            .STARTED_STATUS);
                                                    // print(
                                                    //     "DisputeShouldbeCalled");
                                                    // String chatMessageCurrent;
                                                    // String chatMessageOther;

                                                    // chatMessageCurrent = sprintf(
                                                    //     GetChatMessageJob()
                                                    //         .getChatMessage(
                                                    //             FireBaseConstants
                                                    //                 .CU_JOB_NOT_DELIVERED_CURRENT_USER_MESSAGE),
                                                    //     [
                                                    //       job.title,
                                                    //       jobApplicant
                                                    //           .firstName,
                                                    //     ]);
                                                    // chatMessageOther = sprintf(
                                                    //     GetChatMessageJob()
                                                    //         .getChatMessage(
                                                    //             FireBaseConstants
                                                    //                 .CU_JOB_NOT_DELIVERED_OTHER_USER_MESSAGE),
                                                    //     [
                                                    //       responseLoginUser
                                                    //           .user.firstName,
                                                    //       job.title
                                                    //     ]);
                                                    // await _appController.changeJobStatus(
                                                    //     QueryChangeJobStatus(
                                                    //         jobId: job.id
                                                    //             .toString(),
                                                    //         status: JobConstants
                                                    //             .STARTED_STATUS
                                                    //             .toString(),
                                                    //         userId: jobApplicant
                                                    //             .userId
                                                    //             .toString()),
                                                    //     apiKey.toString(),
                                                    //     responseLoginUser
                                                    //         .user.firebaseUid
                                                    //         .toString(),
                                                    //     jobApplicant.firebaseUid
                                                    //         .toString(),
                                                    //     chatMessageCurrent,
                                                    //     FireBaseConstants
                                                    //         .applyJobApprove,
                                                    //     responseLoginUser
                                                    //         .user.firstName
                                                    //         .toString(),
                                                    //     chatMessageOther,
                                                    //     context);
                                                    // if (_appController
                                                    //         .generalResponse !=
                                                    //     null) {
                                                    //   if (_appController
                                                    //           .generalResponse!
                                                    //           .status ==
                                                    //       "success") {
                                                    //     Navigator.pop(context);
                                                    //     int applicantIndex = JobConstants
                                                    //         .list_cus_started_jobs[
                                                    //             viewJobIndex]
                                                    //         .jobApplicants!
                                                    //         .indexWhere((jobApplicant) =>
                                                    //             jobApplicant
                                                    //                 .sp_job_status ==
                                                    //             JobConstants
                                                    //                 .DELIVERED_STATUS);

                                                    //     JobConstants
                                                    //             .list_cus_started_jobs[
                                                    //                 viewJobIndex]
                                                    //             .jobApplicants![
                                                    //                 applicantIndex]
                                                    //             .sp_job_status =
                                                    //         JobConstants
                                                    //             .STARTED_STATUS;
                                                    //     JobConstants
                                                    //             .list_cus_started_jobs[
                                                    //                 viewJobIndex]
                                                    //             .status =
                                                    //         JobConstants
                                                    //             .STARTED_STATUS;
                                                    //     setState(() {});

                                                    //   } else {
                                                    //     showToast(
                                                    //         _appController
                                                    //             .generalResponse!
                                                    //             .message,
                                                    //         context: context,
                                                    //         backgroundColor:
                                                    //             Colors.red);
                                                    //   }
                                                    // } else {
                                                    //   showToast(
                                                    //       "Unable to complete job",
                                                    //       context: context,
                                                    //       backgroundColor:
                                                    //           Colors.red);
                                                    // }
                                                  },
                                                  child:  Text(
                                                      'mark_not_complete'.tr),
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            )
                    ],
                  ),
                ),
              ),
              Positioned(
                  right: 20,
                  top: 10,
                  child: Container(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("OpneRecpt");
                            showreceiptDialog(context, "this is disclaimer",
                                job, jobApplicant);
                          },
                          child: Image.asset(
                            "assets/ic_recpt.png",
                            fit: BoxFit.contain,
                            width: 30,
                            height: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Uri url =
                                Uri(scheme: "tel", path: jobApplicant.phone);
                            await launchUrl(url);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Image.asset(
                              "assets/ic_call.png",
                              fit: BoxFit.contain,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          );
        });
  }

  void handleClickListners(
      int? status,
      ResponseCustomersShowJobs job,
      BuildContext context,
      JobApplicant jobApplicant,
      int desclaimerAction) async {
    print("BottomSheetStatus${jobApplicant.sp_job_status}");
    String chatMessageCurrent;
    String chatMessageOther;
    if (desclaimerAction == JobConstants.CANCELED_STATUS) {
      print("MarkJobCancel");

      chatMessageCurrent = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.cancelled_JOB_CURRENT_USER_MESSAGE),
          [jobApplicant.firstName, job.title]);
      chatMessageOther = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.cancelled_JOB_OTHER_USER_MESSAGE),
          [responseLoginUser.user.firstName, job.title]);
//make you api call
      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: job.id.toString(),
              status: JobConstants.CANCELED_STATUS.toString(),
              userId: jobApplicant.userId.toString()),
          apiKey.toString(),
          responseLoginUser.user.firebaseUid.toString(),
          jobApplicant.firebaseUid.toString(),
          chatMessageCurrent,
          FireBaseConstants.applyJobApprove,
          responseLoginUser.user.firstName.toString(),
          chatMessageOther,
          context);

      if (_appController.generalResponse != null) {
        if (_appController.generalResponse!.status == "success") {
          int applicantIndex = JobConstants
              .list_cus_started_jobs[viewJobIndex].jobApplicants!
              .indexWhere((jobApplicant) =>
                  jobApplicant.sp_job_status == JobConstants.SP_ACCEPTED);

          JobConstants.list_cus_closed_jobs
              .add(JobConstants.list_cus_started_jobs[viewJobIndex]);
          JobConstants.list_cus_started_jobs[viewJobIndex].status =
              JobConstants.CANCELED_STATUS;
          JobConstants
              .list_cus_started_jobs[viewJobIndex]
              .jobApplicants![applicantIndex]
              .sp_job_status = JobConstants.CANCELED_STATUS;
          JobConstants.list_cus_started_jobs
              .remove(JobConstants.list_cus_started_jobs[viewJobIndex]);
          setState(() {});
        } else {
          Navigator.pop(context);
          showToast(_appController.generalResponse!.message,
              context: context, backgroundColor: Colors.red);
        }
      } else {
        Navigator.pop(context);
        showToast("Unable to create dispute",
            context: context, backgroundColor: Colors.red);
      }
    }
    if (desclaimerAction == JobConstants.STARTED_STATUS) {
      print("MarkJobNotCompleted");
      chatMessageCurrent = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.CU_JOB_NOT_DELIVERED_CURRENT_USER_MESSAGE),
          [
            job.title,
            jobApplicant.firstName,
          ]);
      chatMessageOther = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.CU_JOB_NOT_DELIVERED_OTHER_USER_MESSAGE),
          [responseLoginUser.user.firstName, job.title]);
      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: job.id.toString(),
              status: JobConstants.STARTED_STATUS.toString(),
              userId: jobApplicant.userId.toString()),
          apiKey.toString(),
          responseLoginUser.user.firebaseUid.toString(),
          jobApplicant.firebaseUid.toString(),
          chatMessageCurrent,
          FireBaseConstants.applyJobApprove,
          responseLoginUser.user.firstName.toString(),
          chatMessageOther,
          context);
      if (_appController.generalResponse != null) {
        if (_appController.generalResponse!.status == "success") {
          Navigator.pop(context);
          int applicantIndex = JobConstants
              .list_cus_started_jobs[viewJobIndex].jobApplicants!
              .indexWhere((jobApplicant) =>
                  jobApplicant.sp_job_status == JobConstants.DELIVERED_STATUS);

          JobConstants
              .list_cus_started_jobs[viewJobIndex]
              .jobApplicants![applicantIndex]
              .sp_job_status = JobConstants.STARTED_STATUS;
          JobConstants.list_cus_started_jobs[viewJobIndex].status =
              JobConstants.STARTED_STATUS;
          setState(() {});
        } else {
          showToast(_appController.generalResponse!.message,
              context: context, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to complete job",
            context: context, backgroundColor: Colors.red);
      }
    }
    if (desclaimerAction == JobConstants.DISPUTED_STATUS) {
      print("MarkJobDispute");
      print("DisputeShouldbeCalled");

      chatMessageCurrent = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.DISPUTE_CU_JOB_CURRENT_USER_MESSAGE),
          [jobApplicant.firstName, job.title]);
      chatMessageOther = sprintf(
          GetChatMessageJob().getChatMessage(
              FireBaseConstants.DISPUTE_CU_JOB_OTHER_USER_MESSAGE),
          [responseLoginUser.user.firstName, job.title]);
//make you api call
      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: job.id.toString(),
              status: JobConstants.DISPUTED_STATUS.toString(),
              userId: jobApplicant.userId.toString()),
          apiKey.toString(),
          responseLoginUser.user.firebaseUid.toString(),
          jobApplicant.firebaseUid.toString(),
          chatMessageCurrent,
          FireBaseConstants.applyJobApprove,
          responseLoginUser.user.firstName.toString(),
          chatMessageOther,
          context);

      if (_appController.generalResponse != null) {
        if (_appController.generalResponse!.status == "success") {
          int applicantIndex = JobConstants
              .list_cus_started_jobs[viewJobIndex].jobApplicants!
              .indexWhere((jobApplicant) =>
                  jobApplicant.sp_job_status == JobConstants.PAYMENTDONE);

          JobConstants.list_cus_started_jobs[viewJobIndex].status =
              JobConstants.DISPUTED_STATUS;
          JobConstants
              .list_cus_started_jobs[viewJobIndex]
              .jobApplicants![applicantIndex]
              .sp_job_status = JobConstants.DISPUTED_STATUS;

          setState(() {});
        } else {
          Navigator.pop(context);
          showToast(_appController.generalResponse!.message,
              context: context, backgroundColor: Colors.red);
        }
      } else {
        Navigator.pop(context);
        showToast("Unable to create dispute",
            context: context, backgroundColor: Colors.red);
      }
    }
    if (desclaimerAction == JobConstants.COMPLETED_STATUS) {
      print("MarkJobCompleted");

      chatMessageCurrent = sprintf(
          GetChatMessageJob()
              .getChatMessage(FireBaseConstants.completedJobCurrntUserMessage),
          [job.title, jobApplicant.firstName]);
      chatMessageOther = sprintf(
          GetChatMessageJob()
              .getChatMessage(FireBaseConstants.completedJobOtherUserMessage),
          [responseLoginUser.user.firstName, job.title]);
      print("Gando1");
      await _appController.changeJobStatus(
          QueryChangeJobStatus(
              jobId: job.id.toString(),
              status: JobConstants.COMPLETED_STATUS.toString(),
              userId: jobApplicant.userId.toString()),
          apiKey.toString(),
          responseLoginUser.user.firebaseUid.toString(),
          jobApplicant.firebaseUid.toString(),
          chatMessageCurrent,
          FireBaseConstants.applyJobApprove,
          responseLoginUser.user.firstName.toString(),
          chatMessageOther,
          widget.mainContext);
      if (_appController.generalResponse != null) {
        if (_appController.generalResponse!.status == "success") {
          showPostReviewBottomSheet(AppConstants.baseContext, job);
          int applicantIndex = JobConstants
              .list_cus_started_jobs[viewJobIndex].jobApplicants!
              .indexWhere((jobApplicant) =>
                  jobApplicant.sp_job_status == JobConstants.DELIVERED_STATUS);
          JobConstants.list_cus_closed_jobs
              .add(JobConstants.list_cus_started_jobs[viewJobIndex]);
          JobConstants.list_cus_started_jobs[viewJobIndex].status =
              JobConstants.COMPLETED_STATUS;
          JobConstants
              .list_cus_started_jobs[viewJobIndex]
              .jobApplicants![applicantIndex]
              .sp_job_status = JobConstants.COMPLETED_STATUS;
          JobConstants.list_cus_started_jobs
              .remove(JobConstants.list_cus_started_jobs[viewJobIndex]);
          setState(() {});
        } else {
          showToast(_appController.generalResponse!.message,
              context: widget.mainContext, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to complete this job",
            context: widget.mainContext, backgroundColor: Colors.red);
      }
    }
  }

  void showDisclaimerDialog(
      BuildContext context,
      String disclaimerMessage,
      ResponseCustomersShowJobs responseCustomersShowJobs,
      JobApplicant jobApplicant,
      int desclaimerAction) {
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
                        child: Html(data: disclaimerMessage, style: {
                          'li': Style(
                              color: Colors.black,
                              fontSize: FontSize(10.0),
                              ),
                          'h4': Style(color: Color.fromARGB(255, 53, 52, 52),
                            fontSize: FontSize(10.0),)
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
                                handleClickListners(
                                    responseCustomersShowJobs.status,
                                    responseCustomersShowJobs,
                                    context,
                                    jobApplicant,
                                    desclaimerAction);
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

  showPostReviewBottomSheet(
      BuildContext context, ResponseCustomersShowJobs job) {
    print("OpenSheetJobStatus${job.status}");
    JobApplicant jobApplicant = getJobApplicant(job.status, job.jobApplicants);
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
          return ReviewBottomSheetBody(job, jobApplicant);
        });
  }

  void showreceiptDialog(
      BuildContext context,
      String disclaimerMessgae,
      ResponseCustomersShowJobs responseCustomersShowJobs,
      JobApplicant jobApplicant) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (BuildContext dialogueContext, __, ___) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 400,
            child: Column(
              children: [
                Container(
                    height: 100,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                      image: responseCustomersShowJobs
                                                  .paymentMethod ==
                                              JobConstants.CARD_PAYMENT?
                       AssetImage("assets/payment_done.png"):AssetImage("assets/payment_pending.png"),
                      fit: BoxFit.fill,
                    ))),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/img_rcpt_bottom.png"),
                      fit: BoxFit.fill,
                    )),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "transation id",
                                          style: Styles.simpleTextRcpt,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Job title",
                                          style: Styles.simpleTextRcpt,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          responseCustomersShowJobs.title
                                              .toString(),
                                          style: Styles.simpleTextDataRcpt,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Service Provider",
                                          style: Styles.simpleTextRcpt,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          jobApplicant.firstName.toString(),
                                          style: Styles.simpleTextDataRcpt,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "payment Method",
                                        style: Styles.simpleTextRcpt,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      child: responseCustomersShowJobs
                                                  .paymentMethod ==
                                              JobConstants.CARD_PAYMENT
                                          ? Image.asset(
                                              "assets/payment_by_card.png",
                                              height: 50,
                                              width: 50,
                                            )
                                          : Image.asset(
                                              "assets/payment_by_cash.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Job Amount",
                                  style: Styles.simpleTextRcpt,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  jobApplicant.bidAmount != null
                                      ? responseLoginUser.user.currencySymbol
                                              .toString() +
                                          jobApplicant.bidAmount.toString()
                                      : "",
                                  style: Styles.simpleTextDataRcpt,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Odlay Fee",
                                  style: Styles.simpleTextRcpt,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  jobApplicant.custOdlayFee != null
                                      ? responseLoginUser.user.currencySymbol
                                              .toString() +
                                          jobApplicant.custOdlayFee.toString()
                                      : "",
                                  style: Styles.simpleTextDataRcpt,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Tax",
                                  style: Styles.simpleTextRcpt,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "",
                                  style: Styles.simpleTextDataRcpt,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Total",
                                  style: Styles
                                      .textStyleJobSheetbudgetColoredCustomerReceipt,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  jobApplicant.totalCharged != null
                                      ? responseLoginUser.user.currencySymbol
                                              .toString() +
                                          jobApplicant.totalCharged.toString()
                                      : "",
                                  style: Styles
                                      .textStyleJobSheetbudgetColoredCustomerReceipt,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
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

  void updateCashAmount() {
    int applicantIndex = JobConstants
        .list_cus_started_jobs[viewJobIndex].jobApplicants!
        .indexWhere((jobApplicant) =>
            jobApplicant.sp_job_status == JobConstants.SP_ACCEPTED);
    JobConstants.list_cus_started_jobs[viewJobIndex].status =
        JobConstants.PAYMENTDONE;
    JobConstants
        .list_cus_started_jobs[viewJobIndex]
        .jobApplicants![applicantIndex]
        .sp_job_status = JobConstants.PAYMENTDONE;
    setState(() {});
  }

  updateCardPayment() {
    int applicantIndex = JobConstants
        .list_cus_started_jobs[viewJobIndex].jobApplicants!
        .indexWhere((jobApplicant) =>
            jobApplicant.sp_job_status == JobConstants.SP_ACCEPTED);
    JobConstants.list_cus_started_jobs[viewJobIndex].status =
        JobConstants.PAYMENTDONE;
    JobConstants.list_cus_started_jobs[viewJobIndex].paymentMethod =
        JobConstants.CARD_PAYMENT;
    JobConstants
        .list_cus_started_jobs[viewJobIndex]
        .jobApplicants![applicantIndex]
        .sp_job_status = JobConstants.PAYMENTDONE;
    setState(() {});
  }
}
