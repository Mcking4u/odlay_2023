// To parse this JSON data, do
//
//     final queryVerifyPhone = queryVerifyPhoneFromJson(jsonString);

import 'dart:convert';

QueryVerifyPhone queryVerifyPhoneFromJson(String str) =>
    QueryVerifyPhone.fromJson(json.decode(str));

String queryVerifyPhoneToJson(QueryVerifyPhone data) =>
    json.encode(data.toJson());

class QueryVerifyPhone {
  QueryVerifyPhone({
    required this.phone,
    required this.verificationId,
    required this.message,
    required this.appVersion,
    required this.countryCode,
  });

  String? phone;
  String? verificationId;
  String? message;
  int? appVersion;
  String? countryCode;

  factory QueryVerifyPhone.fromJson(Map<String, dynamic> json) =>
      QueryVerifyPhone(
        phone: json["phone"],
        verificationId: json["verification_id"],
        message: json["message"],
        appVersion: json["app_version"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "verification_id": verificationId,
        "message": message,
        "app_version": appVersion,
        "country_code": countryCode,
      };
}
