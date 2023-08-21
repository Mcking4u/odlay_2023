import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/CameraPromt.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_change_job_status.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/PaymentModels/_query_process_payment.dart';
import 'package:odlay_services/AppFiles/model/Review/_query_post_review.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_chat_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_review_bottom_sheet_body.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/Tabs/_started_jobs_widgets/_closed_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/Tabs/_started_jobs_widgets/_item_started_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

class ClosedJobs extends StatefulWidget {
  BuildContext mainContext;
  ClosedJobs(this.mainContext);
  late ResponseCustomersShowJobs reviewJob;
  @override
  State<ClosedJobs> createState() => _ClosedJobsState();
}

class _ClosedJobsState extends State<ClosedJobs> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  AppController _appController = Get.put(AppController());
  TextEditingController jobDescription = TextEditingController();
  late String? apiKey;
  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];
  int? appRegion;
  double userRating = 1;
  RxInt showImage = 0.obs;
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
        });
      },
      child: Container(
        child: ListView.builder(
            itemCount: JobConstants.list_cus_closed_jobs.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    // var jobId = JobConstants.list_cus_started_jobs[index].id;
                    // print("OpenJobSheetProgress$jobId");
                    showBottomSheetJobDetailPayment(
                      context,
                      JobConstants.list_cus_closed_jobs[index],
                    );
                  },
                  child: ItemCustomerClosedJobs(
                      JobConstants.list_cus_closed_jobs[index],
                      responseLoginUser));
            }),
      ),
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
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Stack(
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
                        margin: const EdgeInsets.only(top: 5, left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              sprintf(
                                  responseLoginUser.user.custMessages.cust_payment_info.message,
                                  [(double.parse(responseLoginUser.user.custfee.toString())*100).toString()+" %"])+""
                              ,
                              style: Styles.sp_note_style),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('payment_method_str'.tr,
                                style: Styles.noteTextColor),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child:
                                  job.paymentMethod == JobConstants.CARD_PAYMENT
                                      ? Image.asset(
                                          "assets/payment_by_card.png",
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
                            child: Text('rewarded_to'.tr,
                                style: Styles.textStyleJobTitle)),
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
                                          phone: jobApplicant.firstName,
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
                                          child: Text('skill_sp'.tr,
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
                        margin:
                            const EdgeInsets.only(top: 5, left: 20, bottom: 60),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(manageStatus(job.status, job),
                              style: Styles.textStyleStatusColor),
                        ),
                      ),
                     job.status==JobConstants.COMPLETED_STATUS? 
                     Container(
                      child: AppElevatedButton(
                        borderRadius: BorderRadius.circular(20),
                        onPressed: (){
                              Navigator.pop(context);
                              showPostReviewBottomSheet(
                                  AppConstants.baseContext, job);
                      }, child:   Text('Leave FeedBack')),
                     ):Container() 
                    ],
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
                              print("Opne Receipt");
                              showreceiptDialog(context, "", job, jobApplicant);
                              
                            },
                            child: Image.asset(
                              "assets/ic_recpt.png",
                              fit: BoxFit.contain,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
  }

  String manageStatus(int? status, ResponseCustomersShowJobs job) {
    print("ClosedJobStatus$status");
    String statusMessage = "";
    if (status == JobConstants.STARTED_STATUS) {
      statusMessage =
          responseLoginUser.user.custMessages.custJobStarted.message;
    }
    if (status == JobConstants.DISPUTED_STATUS) {
      statusMessage = responseLoginUser.user.custMessages.custComplaint.message;
    }
    if (status == JobConstants.SP_ACCEPTED) {
      statusMessage =
          responseLoginUser.user.custMessages.custPaymentAlert.message;
    }
    if (status == JobConstants.COMPLETED_STATUS) {
      statusMessage = responseLoginUser
          .user.userMessages.job_completed_with_success.message
          .toString();
    }
    if (status == JobConstants.COMPLETED_Job_REVIEWE_DONE) {
      statusMessage = responseLoginUser
          .user.userMessages.job_completed_with_success.message
          .toString();
    }
    if (status == JobConstants.CANCELED_STATUS) {
      statusMessage =
          responseLoginUser.user.userMessages.job_cancelled.message.toString();
    }
    if (status == JobConstants.HIRED_STATUS) {
      //statusMessage = "Awating Service Providers confirmation";
    }
    if (status == JobConstants.DELIVERED_STATUS) {
      statusMessage =
          responseLoginUser.user.custMessages.custJobCompletedAlert.message;
    }
    if (status == JobConstants.PAYMENTDONE) {
      print("PaymentMethod${job.paymentMethod}");
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

  JobApplicant getJobApplicant(int? status, List<JobApplicant>? jobApplicants) {
    JobApplicant hiredApplicant;
    print("ApplicantList${jobApplicants!.length}");
    int applicantIndex = jobApplicants
        .indexWhere((jobApplicant) => jobApplicant.sp_job_status == status);
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
                      image:
                      responseCustomersShowJobs
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
                                        'str_payment_method'.tr,
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
  
}
