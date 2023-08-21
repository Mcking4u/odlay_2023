// To parse this JSON data, do
//
//     final queryInviteOnJob = queryInviteOnJobFromJson(jsonString);

import 'dart:convert';

QueryInviteOnJob queryInviteOnJobFromJson(String str) =>
    QueryInviteOnJob.fromJson(json.decode(str));

String queryInviteOnJobToJson(QueryInviteOnJob data) =>
    json.encode(data.toJson());

class QueryInviteOnJob {
  QueryInviteOnJob({
    required this.jobId,
    required this.jobStatus,
    required this.userId,
  });

  String jobId;
  String jobStatus;
  String userId;

  factory QueryInviteOnJob.fromJson(Map<String, dynamic> json) =>
      QueryInviteOnJob(
        jobId: json["job_id"],
        jobStatus: json["job_status"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "job_id": jobId,
        "job_status": jobStatus,
        "user_id": userId,
      };
}
