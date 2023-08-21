// To parse this JSON data, do
//
//     final queryTopRatedGigsModle = queryTopRatedGigsModleFromJson(jsonString);

import 'dart:convert';

QueryTopRatedGigsModle queryTopRatedGigsModleFromJson(String str) =>
    QueryTopRatedGigsModle.fromJson(json.decode(str));

String queryTopRatedGigsModleToJson(QueryTopRatedGigsModle data) =>
    json.encode(data.toJson());

class QueryTopRatedGigsModle {
  QueryTopRatedGigsModle({
    required this.cityId,
  });

  int cityId;

  factory QueryTopRatedGigsModle.fromJson(Map<String, dynamic> json) =>
      QueryTopRatedGigsModle(
        cityId: json["city_id"],
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
      };
}
