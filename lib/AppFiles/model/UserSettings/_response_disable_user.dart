// To parse this JSON data, do
//
//     final responseDiableUser = responseDiableUserFromJson(jsonString);

import 'dart:convert';

ResponseDiableUser? responseDiableUserFromJson(String str) =>
    ResponseDiableUser.fromJson(json.decode(str));

String responseDiableUserToJson(ResponseDiableUser? data) =>
    json.encode(data!.toJson());

class ResponseDiableUser {
  ResponseDiableUser({
    this.status,
    this.message,
    this.userUpdated,
    this.userStatus,
  });

  String? status;
  String? message;
  int? userUpdated;
  int? userStatus;

  factory ResponseDiableUser.fromJson(Map<String, dynamic> json) =>
      ResponseDiableUser(
        status: json["status"],
        message: json["message"],
        userUpdated: json["user_updated"],
        userStatus: json["user status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user_updated": userUpdated,
        "user status": userStatus,
      };
}
