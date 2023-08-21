// To parse this JSON data, do
//
//     final queryIsPhoneStatus = queryIsPhoneStatusFromJson(jsonString);

import 'dart:convert';

QueryIsPhoneStatus queryIsPhoneStatusFromJson(String str) =>
    QueryIsPhoneStatus.fromJson(json.decode(str));

String queryIsPhoneStatusToJson(QueryIsPhoneStatus data) =>
    json.encode(data.toJson());

class QueryIsPhoneStatus {
  QueryIsPhoneStatus({
    required this.phone,
  });

  String phone;

  factory QueryIsPhoneStatus.fromJson(Map<String, dynamic> json) =>
      QueryIsPhoneStatus(
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
      };
}
