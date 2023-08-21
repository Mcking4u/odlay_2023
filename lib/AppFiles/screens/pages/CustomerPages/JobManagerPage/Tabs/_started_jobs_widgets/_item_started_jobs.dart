import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/customerJobDetail/_customer_job_detail.dart';
import 'package:sprintf/sprintf.dart';
import 'package:get/get.dart';

class ItemCustomerStartedJobs extends StatelessWidget {
  ResponseCustomersShowJobs job;
  late JobApplicant? _jobApplicant;
  ResponseLoginUser responseLoginUser;
  ItemCustomerStartedJobs(this.job, this.responseLoginUser);
  @override
  Widget build(BuildContext context) {
    print("CurrentJob${job.title}");
    _jobApplicant = getJobApplicant(job.status, job.jobApplicants);

    return _jobApplicant != null
        ? Container(
            margin: const EdgeInsets.all(5),
            child: Card(
              child: Container(
                margin: const EdgeInsets.only(top: 5, left: 5),
                width: double.infinity,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CustomerJobDetail(
                                        job.id.toString(), false)));
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          size: 18,
                                          color: Colors.orange[900],
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                        text: job.title.toString(),
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Icon(Icons.arrow_drop_down,
                                size: 30, color: Colors.orange[900]),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  'started_job'.tr,
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontSize: 10, color: Colors.grey)),
                                ),
                              )),
                          Expanded(
                              flex: 3,
                              child: Text(
                                GenericAppFunctions.getFormattedDate(
                                    job.createdAt.toString()),
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.black)),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 20,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'bid_amount'.tr,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child:  Text(
                                      responseLoginUser.user.currencySymbol! +
                                          _jobApplicant!.bidAmount.toString(),
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'payable_amout'.tr,
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:Text(
                                    _jobApplicant?.totalCharged != null
                                        ? responseLoginUser
                                        .user.currencySymbol
                                        .toString() +
                                        _jobApplicant!.totalCharged
                                            .toString()
                                        : "",
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  'status'.tr,
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontSize: 10, color: Colors.grey)),
                                ),
                              )),
                          Expanded(
                              flex: 3,
                              child: Text(
                                manageStatus(job.status, job, _jobApplicant),
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.black)),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  String manageStatus(
      int? status, ResponseCustomersShowJobs job, JobApplicant? _appplicant) {
    print("CurrentStartedJobStatus$status");
    String statusMessage = "";
    if (status == JobConstants.STARTED_STATUS) {
      statusMessage = sprintf(
          responseLoginUser.user.custMessages.custJobStarted.message,
          [_appplicant!.firstName]);
    }
    if (status == JobConstants.DISPUTED_STATUS) {
      statusMessage = responseLoginUser.user.custMessages.custComplaint.message;
    }
    if (status == JobConstants.SP_ACCEPTED) {
      statusMessage = sprintf(
          responseLoginUser.user.custMessages.custPaymentAlert.message,
          [_appplicant!.firstName.toString()]);
    }
    if (status == JobConstants.HIRED_STATUS) {
      statusMessage = "Awating Service Providers confirmation";
    }
    if (status == JobConstants.DELIVERED_STATUS) {
      statusMessage = sprintf(
          responseLoginUser.user.custMessages.custJobCompletedAlert.message,
          [_appplicant!.firstName]);
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

  JobApplicant? getJobApplicant(
      int? status, List<JobApplicant>? jobApplicants) {
    JobApplicant? hiredApplicant = null;
    print("TypeJob${status}");
    print("ApplicantList${jobApplicants!.length}");
    int applicantIndex = jobApplicants
        .indexWhere((jobApplicant) => jobApplicant.sp_job_status == status);
    print("FoundIndex${applicantIndex}");
    if (applicantIndex != -1) {
      hiredApplicant = jobApplicants[applicantIndex];
    }
    print("ApplicantName${hiredApplicant?.firstName}");
    return hiredApplicant;
  }
}
