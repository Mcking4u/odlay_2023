// To parse this JSON data, do
//
//     final responseEditGig = responseEditGigFromJson(jsonString);

import 'dart:convert';

ResponseEditGig responseEditGigFromJson(String str) =>
    ResponseEditGig.fromJson(json.decode(str));

String responseEditGigToJson(ResponseEditGig data) =>
    json.encode(data.toJson());

class ResponseEditGig {
  ResponseEditGig({
    required this.status,
    required this.message,
    required this.gigId,
  });

  String? status;
  String? message;
  int? gigId;

  factory ResponseEditGig.fromJson(Map<String, dynamic> json) =>
      ResponseEditGig(
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
