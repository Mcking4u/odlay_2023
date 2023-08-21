// To parse this JSON data, do
//
//     final quickUpdateResponse = quickUpdateResponseFromJson(jsonString);

import 'dart:convert';

QuickUpdateResponse quickUpdateResponseFromJson(String str) =>
    QuickUpdateResponse.fromJson(json.decode(str));

String quickUpdateResponseToJson(QuickUpdateResponse data) =>
    json.encode(data.toJson());

class QuickUpdateResponse {
  QuickUpdateResponse({required this.status, required this.message});

  String? status;
  String? message;

  factory QuickUpdateResponse.fromJson(Map<String, dynamic> json) =>
      QuickUpdateResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
