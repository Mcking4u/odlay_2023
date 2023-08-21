// To parse this JSON data, do
//
//     final responseCreateGig = responseCreateGigFromJson(jsonString);

import 'dart:convert';

ResponseCreateGig responseCreateGigFromJson(String str) =>
    ResponseCreateGig.fromJson(json.decode(str));

String responseCreateGigToJson(ResponseCreateGig data) =>
    json.encode(data.toJson());

class ResponseCreateGig {
  ResponseCreateGig({
    required this.status,
    required this.message,
    required this.gigId,
  });

  String status;
  String message;
  int gigId;

  factory ResponseCreateGig.fromJson(Map<String, dynamic> json) =>
      ResponseCreateGig(
        status: json["status"],
        message: json["message"],
        gigId: json["gig_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "gig_id": gigId,
      };
}
