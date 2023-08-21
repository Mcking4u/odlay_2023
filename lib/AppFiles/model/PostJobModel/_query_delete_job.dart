// To parse this JSON data, do
//
//     final queryDeleteJob = queryDeleteJobFromJson(jsonString);

import 'dart:convert';

QueryDeleteJob queryDeleteJobFromJson(String str) =>
    QueryDeleteJob.fromJson(json.decode(str));

String queryDeleteJobToJson(QueryDeleteJob data) => json.encode(data.toJson());

class QueryDeleteJob {
  QueryDeleteJob({
    required this.apiKey,
    required this.id,
    required this.language,
  });

  String? apiKey;
  String? id;
  int? language;

  factory QueryDeleteJob.fromJson(Map<String, dynamic> json) => QueryDeleteJob(
        apiKey: json["api_key"],
        id: json["id"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "id": id,
        "language": language,
      };
}
