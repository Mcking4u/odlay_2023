import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GetChatMessagesJob.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_query_apply_job.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CustomerModels/jobs_model.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ServiceProviderDrawer/_service_provider_landing_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:sprintf/sprintf.dart';
import 'package:get/get.dart';

import '../../../../../Utility/AppConstants.dart';

class BodyApplyBottomSheet extends StatefulWidget {
  Datum jobsModel;
  late ResponseLoginUser responseLoginUser;
  BodyApplyBottomSheet(this.jobsModel, this.responseLoginUser);
  @override
  State<BodyApplyBottomSheet> createState() =>
      _BodyApplyBottomSheetState(jobsModel, responseLoginUser);
}

class _BodyApplyBottomSheetState extends State<BodyApplyBottomSheet> {
  Datum jobsModel;
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  _BodyApplyBottomSheetState(this.jobsModel, this.responseLoginUser);
  AppController _appController = Get.put(AppController());
  TextEditingController budgetAmount = TextEditingController();
  TextEditingController timeToComplete = TextEditingController();
  TextEditingController serviceDescription = TextEditingController();
  String dropdownValue = 'Fixed';
  List<String> spinnerItems = ['Fixed', 'Hourly', 'Monthly'];
  String odlayfee = "";
  String odlayfeePecentage = "";
  String receivableAmount = "";
  @override
  void initState() {
    // TODO: implement initState
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);

    odlayfeePecentage=(double.parse(responseLoginUser.user.spfee!.toString())*100).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('customer_budget'.tr, style: Styles.headingText),
                Text(
                    responseLoginUser.user.currencySymbol.toString() +
                        jobsModel.budget.toString(),
                    style: Styles.textStyleJobSheetbudgetColoredCustomer)
              ],
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 10),
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
                  style: const TextStyle(color: Colors.black, fontSize: 15),
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
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (String value) async {
                                double enter_amount = double.parse(value);
                                double fee_amount = enter_amount *
                                    double.parse(responseLoginUser.user.spfee
                                        .toString());
                                odlayfee = fee_amount.ceil().toString();
                                receivableAmount = (enter_amount - fee_amount)
                                    .floor()
                                    .toString();
                                setState(() {});
                              },
                              controller: budgetAmount,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                filled: false,
                                isDense: true,
                                hintText: 'str_apply_amoutn'.tr +
                                    '${responseLoginUser.user.currencySymbol}',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            // Container(
            //   margin: const EdgeInsets.only(top: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('odlay_fee'.tr, style: Styles.headingText),
            //       Text(
            //           responseLoginUser.user.currencySymbol.toString() +
            //               odlayfee,
            //           style: Styles.textStyleJobSheetbudgetColoredCustomer)
            //     ],
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sprintf(responseLoginUser.user.spMessages.sp_payment_info.message,[odlayfeePecentage+" %"]),
                      style: Styles.sp_note_style),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('receibal_amount_whill_applying'.tr, style: Styles.headingText),
                  Text(
                      responseLoginUser.user.currencySymbol.toString() +
                          receivableAmount,
                      style: Styles.textStyleJobSheetbudgetColoredCustomer)
                ],
              ),
            ),
            Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: timeToComplete,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: false,
                                hintText: 'time_to_complete'.tr,
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: serviceDescription,
                            maxLines: 5,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.0),
                              filled: false,
                              hintText: 'service_desc'.tr,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 40,
              width: double.infinity,
              child: Obx(() => AppElevatedButton(
                    borderRadius: BorderRadius.circular(20),
                    onPressed: () async {
                      if (budgetAmount.text.isEmpty) {
                        print("Budget is empty");

                        showToast("please enter job budget",
                            context: context, backgroundColor: Colors.red);
                      } else if (int.parse(budgetAmount.text.toString()) <
                          int.parse(
                              responseLoginUser.user.min_amount.toString())) {
                        showToast(
                            "min budget amount is${responseLoginUser.user.min_amount}",
                            context: context,
                            backgroundColor: Colors.red);
                      } else if (int.parse(budgetAmount.text.toString()) >
                          int.parse(
                              responseLoginUser.user.max_amount.toString())) {
                        showToast(
                            "max budget amount is${responseLoginUser.user.max_amount}",
                            context: context,
                            backgroundColor: Colors.red);
                      } else {
                        String chatMessageOther = sprintf(
                            GetChatMessageJob().getChatMessage(
                                FireBaseConstants.applyUserOtherMessage),
                            [
                              responseLoginUser.user.firstName,
                              jobsModel.title.toString(),
                              budgetAmount.text.toString() +
                                  responseLoginUser.user.currencySymbol
                                      .toString(),
                              timeToComplete.text.toString(),
                            ]);
                        String chatMessageCurrent = sprintf(
                            GetChatMessageJob().getChatMessage(
                                FireBaseConstants.applyUserCurrentMessage),
                            [
                              jobsModel.title.toString(),
                              budgetAmount.text.toString() +
                                  responseLoginUser.user.currencySymbol
                                      .toString(),
                              timeToComplete.text.toString(),
                            ]);
                        print("RetreivedMessage${chatMessageCurrent}");
                        await _appController.applyJob(
                            QueryApplyJob(
                                apiKey: apiKey.toString(),
                                budgetAmount: budgetAmount.text.toString(),
                                budgetOption: dropdownValue,
                                duration: timeToComplete.text.toString(),
                                jobid: jobsModel.id,
                                message: serviceDescription.text.toString(),
                                userId: responseLoginUser
                                    .user.serviceProviders.userId
                                    .toString()),
                            apiKey.toString(),
                            responseLoginUser.user.firebaseUid.toString(),
                            jobsModel.firebaseUid.toString(),
                            chatMessageCurrent,
                            responseLoginUser.user.firstName.toString(),
                            FireBaseConstants.typeApplyJob,
                            chatMessageOther,
                            context);
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                                        AppConstants.baseContext,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ServiceProviderLandingPage(2)),
                                        (Route<dynamic> route) => false,
                                      );
                      }
                    },
                    child: Text(
                      _appController.responseApplyJobLoading.value
                          ? 'applying'.tr
                          : 'btn_apply'.tr,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
