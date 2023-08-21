// To parse this JSON data, do
//
//     final responsePostJobVsServiceProvider = responsePostJobVsServiceProviderFromJson(jsonString);

import 'dart:convert';

ResponsePostJobVsServiceProvider responsePostJobVsServiceProviderFromJson(
        String str) =>
    ResponsePostJobVsServiceProvider.fromJson(json.decode(str));

String responsePostJobVsServiceProviderToJson(
        ResponsePostJobVsServiceProvider data) =>
    json.encode(data.toJson());

class ResponsePostJobVsServiceProvider {
  ResponsePostJobVsServiceProvider({
    required this.status,
    required this.message,
    required this.isHired,
  });

  String status;
  String message;
  int isHired;

  factory ResponsePostJobVsServiceProvider.fromJson(
          Map<String, dynamic> json) =>
      ResponsePostJobVsServiceProvider(
        status: json["status"],
        message: json["message"],
        isHired: json["is_hired"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "is_hired": isHired,
      };
}
