import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/WalletModel/_wallet_response.dart';
import 'package:odlay_services/AppFiles/model/WalletModelSp/_wallets_response_sp.dart';
import 'package:get/get.dart';

class ItemWalletCardSp extends StatelessWidget {
  PaymentInfoSp paymentInfo;
  ResponseLoginUser responseLoginUser;
  ItemWalletCardSp(this.paymentInfo, this.responseLoginUser);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(paymentInfo.title.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('str_my_cus_patment_date'.tr,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  paymentInfo.createdAt != null
                                      ? GenericAppFunctions.getFormattedDate(
                                          paymentInfo.createdAt.toString())
                                      : "",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('str_my_cus_bid_amount'.tr,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                  responseLoginUser.user.currencySymbol
                                          .toString() +
                                      paymentInfo.bidAmount.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('str_my_cus_odlay_fee'.tr,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  responseLoginUser.user.currencySymbol
                                          .toString() +
                                      paymentInfo.odlayFee.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('str_my_sp_amount_receivable'.tr,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  responseLoginUser.user.currencySymbol
                                          .toString() +
                                      paymentInfo.spReceivableAmount.toString(),
                                  style: const TextStyle(
                                      color: Color.fromRGBO(255, 118, 87, 1),
                                      fontSize: 14,
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
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child:
                          paymentInfo.paymentMethod == JobConstants.CASH_PAYMENT
                              ? Column(
                                  children: [
                                    Image.asset(
                                      "assets/payment_by_cash.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    const Text("By Cash",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )
                              : Column(
                                  children: [
                                    Image.asset(
                                      "assets/payment_by_card.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    const Text("By Card",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 2),
                      child: Text(
                          paymentInfo.isPaid == "1"
                              ? "Payment Done"
                              : "Payment Due",
                          style: TextStyle(
                              color: paymentInfo.isPaid == "1"
                                  ? Colors.green
                                  : Color.fromARGB(255, 184, 85, 9),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
