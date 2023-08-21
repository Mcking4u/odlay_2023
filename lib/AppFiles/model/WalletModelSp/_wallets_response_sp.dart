// To parse this JSON data, do
//
//     final walletResponseSp = walletResponseSpFromJson(jsonString);

import 'dart:convert';

WalletResponseSp walletResponseSpFromJson(String str) =>
    WalletResponseSp.fromJson(json.decode(str));

String walletResponseSpToJson(WalletResponseSp data) =>
    json.encode(data.toJson());

class WalletResponseSp {
  WalletResponseSp({
    required this.walletAmount,
    required this.odlayFee,
    required this.pastPayments,
    required this.paymentInfo,
  });

  WalletAmount? walletAmount;
  OdlayFee? odlayFee;
  PastPaymentsSp? pastPayments;
  List<PaymentInfoSp>? paymentInfo;

  factory WalletResponseSp.fromJson(Map<String, dynamic> json) =>
      WalletResponseSp(
        walletAmount: WalletAmount.fromJson(json["Wallet_Amount"]),
        odlayFee: OdlayFee.fromJson(json["Odlay_Fee"]),
        pastPayments: PastPaymentsSp.fromJson(json["past_payments"]),
        paymentInfo: List<PaymentInfoSp>.from(
            json["PaymentInfo"].map((x) => PaymentInfoSp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Wallet_Amount": walletAmount!.toJson(),
        "Odlay_Fee": odlayFee!.toJson(),
        "past_payments": pastPayments!.toJson(),
        "PaymentInfo": List<dynamic>.from(paymentInfo!.map((x) => x.toJson())),
      };
}

class OdlayFee {
  OdlayFee({
    required this.odlayFee,
  });

  int? odlayFee;

  factory OdlayFee.fromJson(Map<String, dynamic> json) => OdlayFee(
        odlayFee: json["odlay_fee"],
      );

  Map<String, dynamic> toJson() => {
        "odlay_fee": odlayFee,
      };
}

class PastPaymentsSp {
  PastPaymentsSp({
    required this.jobsCount,
    required this.totalEarnings,
    required this.cashPayments,
    required this.onlinePayments,
  });

  int? jobsCount;
  int? totalEarnings;
  int? cashPayments;
  int? onlinePayments;

  factory PastPaymentsSp.fromJson(Map<String, dynamic> json) => PastPaymentsSp(
        jobsCount: json["jobs_count"],
        totalEarnings: json["total_earnings"],
        cashPayments: json["cash_payments"],
        onlinePayments: json["online_payments"],
      );

  Map<String, dynamic> toJson() => {
        "jobs_count": jobsCount,
        "total_earnings": totalEarnings,
        "cash_payments": cashPayments,
        "online_payments": onlinePayments,
      };
}

class PaymentInfoSp {
  PaymentInfoSp({
    required this.title,
    required this.amountPaid,
    required this.createdAt,
    required this.paymentMethod,
    required this.isPaid,
    required this.odlayFee,
    required this.odlayFeePaid,
    this.spReceivableAmount,
    required this.bidAmount,
  });

  String? title;
  String? amountPaid;
  String? createdAt;
  int? paymentMethod;
  String? isPaid;
  int? odlayFee;
  int? odlayFeePaid;
  int? spReceivableAmount;
  int? bidAmount;

  factory PaymentInfoSp.fromJson(Map<String, dynamic> json) => PaymentInfoSp(
        title: json["title"],
        amountPaid: json["amount_paid"],
        createdAt: json["created_at"],
        paymentMethod: json["payment_method"],
        isPaid: json["is_paid"],
        odlayFee: json["odlay_fee"],
        odlayFeePaid: json["odlay_fee_paid"],
        spReceivableAmount: json["sp_receivable_amount"],
        bidAmount: json["bid_amount"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "amount_paid": amountPaid,
        "created_at": createdAt,
        "payment_method": paymentMethod,
        "is_paid": isPaid,
        "odlay_fee": odlayFee,
        "odlay_fee_paid": odlayFeePaid,
        "sp_receivable_amount": spReceivableAmount,
        "bid_amount": bidAmount,
      };
}

class WalletAmount {
  WalletAmount({
    required this.amountPaid,
  });

  int? amountPaid;

  factory WalletAmount.fromJson(Map<String, dynamic> json) => WalletAmount(
        amountPaid: json["amount_paid"],
      );

  Map<String, dynamic> toJson() => {
        "amount_paid": amountPaid,
      };
}
