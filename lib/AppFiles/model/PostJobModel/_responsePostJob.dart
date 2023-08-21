// To parse this JSON data, do
//
//     final responsePostJob = responsePostJobFromJson(jsonString);

import 'dart:convert';

ResponsePostJob responsePostJobFromJson(String str) =>
    ResponsePostJob.fromJson(json.decode(str));

String responsePostJobToJson(ResponsePostJob data) =>
    json.encode(data.toJson());

class ResponsePostJob {
  ResponsePostJob({
    required this.status,
    required this.message,
    required this.jobId,
  });

  String status;
  String message;
  int jobId;

  factory ResponsePostJob.fromJson(Map<String, dynamic> json) =>
      ResponsePostJob(
        status: json["status"],
        message: json["message"],
        jobId: json["job_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "job_id": jobId,
      };
}
