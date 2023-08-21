// To parse this JSON data, do
//
//     final walletResponse = walletResponseFromJson(jsonString);

import 'dart:convert';

WalletResponse walletResponseFromJson(String str) =>
    WalletResponse.fromJson(json.decode(str));

String walletResponseToJson(WalletResponse data) => json.encode(data.toJson());

class WalletResponse {
  WalletResponse({
    required this.walletAmount,
    this.odlayFee,
    required this.pastPayments,
    required this.paymentInfo,
  });

  WalletAmount? walletAmount;
  dynamic odlayFee;
  PastPayments? pastPayments;
  List<PaymentInfo> paymentInfo;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        walletAmount: WalletAmount.fromJson(json["Wallet_Amount"]),
        odlayFee: json["Odlay_Fee"],
        pastPayments: PastPayments.fromJson(json["past_payments"]),
        paymentInfo: List<PaymentInfo>.from(
            json["PaymentInfo"].map((x) => PaymentInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Wallet_Amount": walletAmount!.toJson(),
        "Odlay_Fee": odlayFee,
        "past_payments": pastPayments!.toJson(),
        "PaymentInfo": List<dynamic>.from(paymentInfo.map((x) => x.toJson())),
      };
}

class PastPayments {
  PastPayments({
    required this.jobsCount,
    required this.totalSpendings,
    required this.cashPayments,
    required this.onlinePayments,
  });

  int? jobsCount;
  int? totalSpendings;
  int? cashPayments;
  int? onlinePayments;

  factory PastPayments.fromJson(Map<String, dynamic> json) => PastPayments(
        jobsCount: json["jobs_count"],
        totalSpendings: json["total_spendings"],
        cashPayments: json["cash_payments"],
        onlinePayments: json["online_payments"],
      );

  Map<String, dynamic> toJson() => {
        "jobs_count": jobsCount,
        "total_spendings": totalSpendings,
        "cash_payments": cashPayments,
        "online_payments": onlinePayments,
      };
}

class PaymentInfo {
  PaymentInfo({
    required this.title,
    required this.amountPaid,
    required this.createdAt,
    required this.paymentMethod,
    required this.bidAmount,
    required this.custOdlayFee,
  });

  String? title;
  int? amountPaid;
  String? createdAt;
  int? paymentMethod;
  int? bidAmount;
  int? custOdlayFee;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        title: json["title"],
        amountPaid: json["amount_paid"],
        createdAt: json["created_at"],
        paymentMethod: json["payment_method"],
        bidAmount: json["bid_amount"] == null ? null : json["bid_amount"],
        custOdlayFee: json["cust_odlay_fee"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "amount_paid": amountPaid,
        "created_at": createdAt,
        "payment_method": paymentMethod,
        "bid_amount": bidAmount == null ? null : bidAmount,
        "cust_odlay_fee": custOdlayFee,
      };
}

class WalletAmount {
  WalletAmount({
    required this.walletAmount,
    required this.jobsInprogress,
    required this.unreleasedPayment,
  });

  int? walletAmount;
  int? jobsInprogress;
  int? unreleasedPayment;

  factory WalletAmount.fromJson(Map<String, dynamic> json) => WalletAmount(
        walletAmount: json["wallet_amount"],
        jobsInprogress: json["jobs_inprogress"],
        unreleasedPayment: json["unreleased_payment"],
      );

  Map<String, dynamic> toJson() => {
        "wallet_amount": walletAmount,
        "jobs_inprogress": jobsInprogress,
        "unreleased_payment": unreleasedPayment,
      };
}
