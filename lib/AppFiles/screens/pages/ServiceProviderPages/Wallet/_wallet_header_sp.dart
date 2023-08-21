import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/WalletModelSp/_wallets_response_sp.dart';
import 'package:get/get.dart';

class WalletHeaderSp extends StatefulWidget {
  WalletResponseSp walletResponseSp;
  ResponseLoginUser responseLoginUser;
  WalletHeaderSp(this.walletResponseSp, this.responseLoginUser);
  @override
  State<WalletHeaderSp> createState() => _WalletHeaderStateSp();
}

class _WalletHeaderStateSp extends State<WalletHeaderSp> {
  late SkillCitiesProfessions skillCitiesProfessions;
  @override
  void initState() {
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              height: 210,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 102, 102, 1),
                        Color.fromRGBO(255, 133, 76, 1)
                      ]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
              child: SafeArea(
                child: Column(
                  children: [
                    Text('str_my_wallet'.tr,
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(71, 9, 9, 9),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('str_sp_with_drawn_earnings'.tr,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      widget.walletResponseSp.walletAmount !=
                                              null
                                          ? widget.responseLoginUser.user
                                                  .currencySymbol
                                                  .toString() +
                                              widget.walletResponseSp
                                                  .walletAmount!.amountPaid
                                                  .toString()
                                          : "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(71, 9, 9, 9),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('str_sp_odlay_fee_on_cash'.tr,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      widget.walletResponseSp.odlayFee!
                                                  .odlayFee !=
                                              null
                                          ? widget.responseLoginUser.user
                                                  .currencySymbol
                                                  .toString() +
                                              widget.walletResponseSp.odlayFee!
                                                  .odlayFee
                                                  .toString()
                                          : widget.responseLoginUser.user
                                                  .currencySymbol
                                                  .toString() +
                                              "0",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('str_my_cus_completed_jobs'.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Flexible(
                            child: Text('str_my_sp_total_earnigns'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Flexible(
                            child: Text('str_my_cus_cash_payment'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Flexible(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('str_my_cus_online_payment'.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              // ignore: sort_child_properties_last
              child: Container(
                height: 80,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: double.infinity,
                      width: 80,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Text(
                                widget.walletResponseSp.pastPayments!
                                            .jobsCount !=
                                        null
                                    ? widget.walletResponseSp.pastPayments!
                                        .jobsCount
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: 80,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                    widget.responseLoginUser.user.currencySymbol
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Text(
                                widget.walletResponseSp.pastPayments!
                                            .totalEarnings !=
                                        null
                                    ? widget.walletResponseSp.pastPayments!
                                        .totalEarnings
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: 80,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                    widget.responseLoginUser.user.currencySymbol
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Text(
                                widget.walletResponseSp.pastPayments!
                                            .cashPayments !=
                                        null
                                    ? widget.walletResponseSp.pastPayments!
                                        .cashPayments
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: 80,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                    widget.responseLoginUser.user.currencySymbol
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Text(
                                widget.walletResponseSp.pastPayments!
                                            .onlinePayments !=
                                        null
                                    ? widget.walletResponseSp.pastPayments!
                                        .onlinePayments
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              right: 0,
              left: 0,
              bottom: -40,
            ),
          ],
        ),
      ),
    );
  }
}
