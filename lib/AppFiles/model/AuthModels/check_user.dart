// To parse this JSON data, do
//
//     final checkUserModel = checkUserModelFromJson(jsonString);

import 'dart:convert';

CheckUserModel checkUserModelFromJson(String str) =>
    CheckUserModel.fromJson(json.decode(str));

String checkUserModelToJson(CheckUserModel data) => json.encode(data.toJson());

class CheckUserModel {
  CheckUserModel({
    required this.status,
    required this.message,
    required this.code,
    this.userStatus,
  });

  String status;
  String message;
  int code;
  dynamic userStatus;

  factory CheckUserModel.fromJson(Map<String, dynamic> json) => CheckUserModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        userStatus: json["user_status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "user_status": userStatus,
      };
}
