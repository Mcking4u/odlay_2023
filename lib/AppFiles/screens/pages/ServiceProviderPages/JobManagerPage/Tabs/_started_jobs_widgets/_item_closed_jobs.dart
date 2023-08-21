import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/customerJobDetail/_customer_job_detail.dart';
import 'package:sprintf/sprintf.dart';
import 'package:get/get.dart';

class ItemServiceProviderClosedJobs extends StatelessWidget {
  Applied appliedJob;
  ResponseLoginUser responseLoginUser;
  ItemServiceProviderClosedJobs(this.appliedJob, this.responseLoginUser);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Card(
        child: Container(
          margin: EdgeInsets.only(top: 5, left: 5),
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // print("OpenJobDetailSp");
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => CustomerJobDetail(
                        //         appliedJob.jobId.toString(), true)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        width: double.infinity,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              // WidgetSpan(
                              //   child: Padding(
                              //     padding: EdgeInsets.only(right: 5),
                              //     child: Icon(
                              //       Icons.remove_red_eye,
                              //       size: 18,
                              //       color: Colors.orange[900],
                              //     ),
                              //   ),
                              // ),
                              TextSpan(
                                  text: appliedJob.jobTitle.toString(),
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
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'started_job'.tr,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Text(
                            appliedJob.startedAt != null
                                ? GenericAppFunctions.getFormattedDate(
                                    appliedJob.startedAt.toString())
                                : "",
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black)),
                          ),
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
                                          fontSize: 10, color: Colors.grey)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                responseLoginUser.user.currencySymbol! +
                                    appliedJob.bidAmount.toString(),
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
                              'receivable_amount'.tr,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              responseLoginUser.user.currencySymbol! +
                                  appliedJob.spReceivableAmount.toString(),
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
                          getStatusMessage(appliedJob.status, appliedJob),
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
    );
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
    if (status == JobConstants.NOT_VIEWED_STATUS ||
        status == JobConstants.USER_APPLIED_AFTER_INVITATION ||
        status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {
      statusMsg = sprintf(
          responseLoginUser.user.spMessages.spJobApplied.message,
          [_applied.consumerName.toString()]);
    }
    if (status == JobConstants.PAYMENTDONE) {
      if (appliedJob.paymentMethod == JobConstants.CARD_PAYMENT) {
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
}
