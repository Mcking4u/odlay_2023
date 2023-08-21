// To parse this JSON data, do
//
//     final responseDirectJobCreation = responseDirectJobCreationFromJson(jsonString);

import 'dart:convert';

ResponseDirectJobCreation responseDirectJobCreationFromJson(String str) =>
    ResponseDirectJobCreation.fromJson(json.decode(str));

String responseDirectJobCreationToJson(ResponseDirectJobCreation data) =>
    json.encode(data.toJson());

class ResponseDirectJobCreation {
  ResponseDirectJobCreation({
    required this.status,
    required this.jobId,
  });

  String status;
  int jobId;

  factory ResponseDirectJobCreation.fromJson(Map<String, dynamic> json) =>
      ResponseDirectJobCreation(
        status: json["status"],
        jobId: json["job_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "job_id": jobId,
      };
}
