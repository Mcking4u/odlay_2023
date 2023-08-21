// To parse this JSON data, do
//
//     final queryJobDetail = queryJobDetailFromJson(jsonString);

import 'dart:convert';

QueryJobDetail queryJobDetailFromJson(String str) =>
    QueryJobDetail.fromJson(json.decode(str));

String queryJobDetailToJson(QueryJobDetail data) => json.encode(data.toJson());

class QueryJobDetail {
  QueryJobDetail({
    required this.jobId,
  });

  String jobId;

  factory QueryJobDetail.fromJson(Map<String, dynamic> json) => QueryJobDetail(
        jobId: json["job_id"],
      );

  Map<String, dynamic> toJson() => {
        "job_id": jobId,
      };
}
