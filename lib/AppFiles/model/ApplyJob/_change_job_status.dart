// To parse this JSON data, do
//
//     final queryChangeJobStatus = queryChangeJobStatusFromJson(jsonString);

import 'dart:convert';

QueryChangeJobStatus queryChangeJobStatusFromJson(String str) =>
    QueryChangeJobStatus.fromJson(json.decode(str));

String queryChangeJobStatusToJson(QueryChangeJobStatus data) =>
    json.encode(data.toJson());

class QueryChangeJobStatus {
  QueryChangeJobStatus(
      {required this.jobId,
      required this.status,
      required this.userId,
      this.cancelledBy});

  String? jobId;
  String? status;
  String? userId;
  String? cancelledBy;

  factory QueryChangeJobStatus.fromJson(Map<String, dynamic> json) =>
      QueryChangeJobStatus(
          jobId: json["job_id"],
          status: json["status"],
          userId: json["user_id"],
          cancelledBy: json["cancelled_by"]);

  Map<String, dynamic> toJson() => {
        "job_id": jobId,
        "status": status,
        "user_id": userId,
        "cancelled_by": cancelledBy
      };
}
