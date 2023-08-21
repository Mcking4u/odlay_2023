// To parse this JSON data, do
//
//     final responseVerifyPhone = responseVerifyPhoneFromJson(jsonString);

import 'dart:convert';

ResponseVerifyPhone responseVerifyPhoneFromJson(String str) =>
    ResponseVerifyPhone.fromJson(json.decode(str));

String responseVerifyPhoneToJson(ResponseVerifyPhone data) =>
    json.encode(data.toJson());

class ResponseVerifyPhone {
  ResponseVerifyPhone({
    required this.status,
    required this.message,
    required this.verificationId,
    required this.userStatus,
    required this.apiRegion,
  });

  String? status;
  String? message;
  int? verificationId;
  int? userStatus;
  ApiRegion? apiRegion;

  factory ResponseVerifyPhone.fromJson(Map<String, dynamic> json) =>
      ResponseVerifyPhone(
        status: json["status"],
        message: json["message"],
        verificationId: json["verification_id"],
        userStatus: json["user_status"],
        apiRegion: ApiRegion.fromJson(json["api_region"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "verification_id": verificationId,
        "user_status": userStatus,
        "api_region": apiRegion!.toJson(),
      };
}

class ApiRegion {
  ApiRegion({
    required this.id,
    required this.country,
    required this.dialcode,
    required this.continent,
    required this.regionCode,
  });

  int? id;
  String? country;
  String? dialcode;
  String? continent;
  int? regionCode;

  factory ApiRegion.fromJson(Map<String, dynamic> json) => ApiRegion(
        id: json["id"],
        country: json["country"],
        dialcode: json["dialcode"],
        continent: json["continent"],
        regionCode: json["region_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "dialcode": dialcode,
        "continent": continent,
        "region_code": regionCode,
      };
}
