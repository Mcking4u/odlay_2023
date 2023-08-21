// To parse this JSON data, do
//
//     final serviceproviderJobsShowQuery = serviceproviderJobsShowQueryFromJson(jsonString);

import 'dart:convert';

ServiceproviderJobsShowQuery serviceproviderJobsShowQueryFromJson(String str) =>
    ServiceproviderJobsShowQuery.fromJson(json.decode(str));

String serviceproviderJobsShowQueryToJson(ServiceproviderJobsShowQuery data) =>
    json.encode(data.toJson());

class ServiceproviderJobsShowQuery {
  ServiceproviderJobsShowQuery({
    required this.apiKey,
    required this.userId,
    required this.language,
    required this.callFrom,
  });

  String apiKey;
  String userId;
  int? language;
  String callFrom;

  factory ServiceproviderJobsShowQuery.fromJson(Map<String, dynamic> json) =>
      ServiceproviderJobsShowQuery(
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
