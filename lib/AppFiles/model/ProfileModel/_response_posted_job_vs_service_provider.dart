// To parse this JSON data, do
//
//     final responsePostedJobVsProvider = responsePostedJobVsProviderFromJson(jsonString);

import 'dart:convert';

ResponsePostedJobVsProvider? responsePostedJobVsProviderFromJson(String str) =>
    ResponsePostedJobVsProvider.fromJson(json.decode(str));

String responsePostedJobVsProviderToJson(ResponsePostedJobVsProvider? data) =>
    json.encode(data!.toJson());

class ResponsePostedJobVsProvider {
  ResponsePostedJobVsProvider({
    this.status,
    this.message,
    this.isHired,
  });

  String? status;
  String? message;
  int? isHired;

  factory ResponsePostedJobVsProvider.fromJson(Map<String, dynamic> json) =>
      ResponsePostedJobVsProvider(
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
