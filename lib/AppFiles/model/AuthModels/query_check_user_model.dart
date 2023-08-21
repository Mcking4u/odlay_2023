// To parse this JSON data, do
//
//     final queryCheckUserModel = queryCheckUserModelFromJson(jsonString);

import 'dart:convert';

QueryCheckUserModel queryCheckUserModelFromJson(String str) =>
    QueryCheckUserModel.fromJson(json.decode(str));

String queryCheckUserModelToJson(QueryCheckUserModel data) =>
    json.encode(data.toJson());

class QueryCheckUserModel {
  QueryCheckUserModel({required this.phone, required this.country_code});

  String phone;
  String country_code;

  factory QueryCheckUserModel.fromJson(Map<String, dynamic> json) =>
      QueryCheckUserModel(
        phone: json["phone"],
        country_code: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "country_code": country_code,
      };
}
