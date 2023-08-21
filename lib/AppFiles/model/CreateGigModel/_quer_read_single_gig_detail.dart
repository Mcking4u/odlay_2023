// To parse this JSON data, do
//
//     final queryReadSingleGigDetail = queryReadSingleGigDetailFromJson(jsonString);

import 'dart:convert';

QueryReadSingleGigDetail queryReadSingleGigDetailFromJson(String str) =>
    QueryReadSingleGigDetail.fromJson(json.decode(str));

String queryReadSingleGigDetailToJson(QueryReadSingleGigDetail data) =>
    json.encode(data.toJson());

class QueryReadSingleGigDetail {
  QueryReadSingleGigDetail({
    required this.gigId,
    required this.language,
  });

  String? gigId;
  String? language;
  factory QueryReadSingleGigDetail.fromJson(Map<String, dynamic> json) =>
      QueryReadSingleGigDetail(
        gigId: json["gig_id"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "gig_id": gigId,
        "language": language,
      };
}
