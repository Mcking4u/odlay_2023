// To parse this JSON data, do
//
//     final queryProcessPayment = queryProcessPaymentFromJson(jsonString);

import 'dart:convert';

QueryProcessPayment queryProcessPaymentFromJson(String str) =>
    QueryProcessPayment.fromJson(json.decode(str));

String queryProcessPaymentToJson(QueryProcessPayment data) =>
    json.encode(data.toJson());

class QueryProcessPayment {
  QueryProcessPayment({
    required this.transactionId,
    required this.consumerId,
    required this.jobId,
    required this.serviceId,
    required this.amountPaid,
    required this.amountPaidOrginal,
    required this.status,
    required this.paymentMethod,
  });

  String transactionId;
  int consumerId;
  String jobId;
  String serviceId;
  String amountPaid;
  int amountPaidOrginal;
  int status;
  int paymentMethod;

  factory QueryProcessPayment.fromJson(Map<String, dynamic> json) =>
      QueryProcessPayment(
        transactionId: json["transaction_id"],
        consumerId: json["consumer_id"],
        jobId: json["job_id"],
        serviceId: json["service_id"],
        amountPaid: json["amount_paid"],
        amountPaidOrginal: json["amount_paid_orginal"],
        status: json["status"],
        paymentMethod: json["payment_method"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "consumer_id": consumerId,
        "job_id": jobId,
        "service_id": serviceId,
        "amount_paid": amountPaid,
        "amount_paid_orginal": amountPaidOrginal,
        "status": status,
        "payment_method": paymentMethod,
      };
}
