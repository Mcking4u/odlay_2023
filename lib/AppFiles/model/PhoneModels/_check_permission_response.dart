// To parse this JSON data, do
//
//     final responseCheckPermission = responseCheckPermissionFromJson(jsonString);

import 'dart:convert';

ResponseCheckPermission responseCheckPermissionFromJson(String str) =>
    ResponseCheckPermission.fromJson(json.decode(str));

String responseCheckPermissionToJson(ResponseCheckPermission data) =>
    json.encode(data.toJson());

class ResponseCheckPermission {
  ResponseCheckPermission({
    required this.status,
    this.allowMobileCall,
  });

  String? status;
  int? allowMobileCall;

  factory ResponseCheckPermission.fromJson(Map<String, dynamic> json) =>
      ResponseCheckPermission(
        status: json["status"],
        allowMobileCall: json["allow_mobile_call"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "allow_mobile_call": allowMobileCall,
      };
}
