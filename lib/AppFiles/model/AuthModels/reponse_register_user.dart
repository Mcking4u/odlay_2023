// To parse this JSON data, do
//
//     final responseRegisterUser = responseRegisterUserFromJson(jsonString);

import 'dart:convert';

ResponseRegisterUser responseRegisterUserFromJson(String str) =>
    ResponseRegisterUser.fromJson(json.decode(str));

String responseRegisterUserToJson(ResponseRegisterUser data) =>
    json.encode(data.toJson());

class ResponseRegisterUser {
  ResponseRegisterUser({
    required this.status,
    required this.message,
    required this.code,
  });

  String status;
  String message;
  int code;

  factory ResponseRegisterUser.fromJson(Map<String, dynamic> json) =>
      ResponseRegisterUser(
        status: json["status"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
      };
}
