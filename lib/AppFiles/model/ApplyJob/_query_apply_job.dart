// To parse this JSON data, do
//
//     final queryApplyJob = queryApplyJobFromJson(jsonString);

import 'dart:convert';

QueryApplyJob queryApplyJobFromJson(String str) =>
    QueryApplyJob.fromJson(json.decode(str));

String queryApplyJobToJson(QueryApplyJob data) => json.encode(data.toJson());

class QueryApplyJob {
  QueryApplyJob({
    required this.apiKey,
    required this.budgetAmount,
    required this.budgetOption,
    required this.duration,
    required this.jobid,
    required this.message,
    required this.userId,
  });

  String apiKey;
  String? budgetAmount;
  String? budgetOption;
  String? duration;
  int? jobid;
  String? message;
  String? userId;

  factory QueryApplyJob.fromJson(Map<String, dynamic> json) => QueryApplyJob(
        apiKey: json["api_key"],
        budgetAmount: json["budget_amount"],
        budgetOption: json["budget_option"],
        duration: json["duration"],
        jobid: json["jobid"],
        message: json["message"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "budget_amount": budgetAmount,
        "budget_option": budgetOption,
        "duration": duration,
        "jobid": jobid,
        "message": message,
        "user_id": userId,
      };
}
