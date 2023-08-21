// To parse this JSON data, do
//
//     final queryCustomersShowJobs = queryCustomersShowJobsFromJson(jsonString);

import 'dart:convert';

QueryCustomersShowJobs queryCustomersShowJobsFromJson(String str) =>
    QueryCustomersShowJobs.fromJson(json.decode(str));

String queryCustomersShowJobsToJson(QueryCustomersShowJobs data) =>
    json.encode(data.toJson());

class QueryCustomersShowJobs {
  QueryCustomersShowJobs({
    required this.apiKey,
    required this.userId,
    required this.language,
    required this.callFrom,
  });

  String apiKey;
  String userId;
  int? language;
  String callFrom;

  factory QueryCustomersShowJobs.fromJson(Map<String, dynamic> json) =>
      QueryCustomersShowJobs(
        apiKey: json["api_key"],
        userId: json["user_id"],
        language: json["language"],
        callFrom: json["callFrom"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "user_id": userId,
        "language": language,
        "callFrom": callFrom,
      };
}
