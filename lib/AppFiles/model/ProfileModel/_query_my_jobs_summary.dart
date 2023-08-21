// To parse this JSON data, do
//
//     final queryMyJobsSummary = queryMyJobsSummaryFromJson(jsonString);

import 'dart:convert';

QueryMyJobsSummary queryMyJobsSummaryFromJson(String str) =>
    QueryMyJobsSummary.fromJson(json.decode(str));

String queryMyJobsSummaryToJson(QueryMyJobsSummary data) =>
    json.encode(data.toJson());

class QueryMyJobsSummary {
  QueryMyJobsSummary({
    required this.consumerId,
    required this.spId,
  });

  String consumerId;
  String spId;

  factory QueryMyJobsSummary.fromJson(Map<String, dynamic> json) =>
      QueryMyJobsSummary(
        consumerId: json["consumer_id"],
        spId: json["sp_id"],
      );

  Map<String, dynamic> toJson() => {
        "consumer_id": consumerId,
        "sp_id": spId,
      };
}
