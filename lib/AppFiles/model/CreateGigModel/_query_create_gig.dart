// To parse this JSON data, do
//
//     final queryCreateGig = queryCreateGigFromJson(jsonString);

import 'dart:convert';

QueryCreateGig queryCreateGigFromJson(String str) =>
    QueryCreateGig.fromJson(json.decode(str));

String queryCreateGigToJson(QueryCreateGig data) => json.encode(data.toJson());

class QueryCreateGig {
  QueryCreateGig({
    required this.apiKey,
    required this.cityId,
    required this.detail,
    required this.language,
    required this.price,
    required this.serviceId,
    required this.skillId,
    required this.skillTitle,
    required this.title,
  });

  String? apiKey;
  String? cityId;
  String? detail;
  String? language;
  String? price;
  String? serviceId;
  String? skillId;
  List<String>? skillTitle;
  String? title;

  factory QueryCreateGig.fromJson(Map<String, dynamic> json) => QueryCreateGig(
        apiKey: json["api_key"],
        cityId: json["city_id"],
        detail: json["detail"],
        language: json["language"],
        price: json["price"],
        serviceId: json["service_id"],
        skillId: json["skill_id"],
        skillTitle: List<String>.from(json["skill_title"].map((x) => x)),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "city_id": cityId,
        "detail": detail,
        "language": language,
        "price": price,
        "service_id": serviceId,
        "skill_id": skillId,
        "skill_title": List<dynamic>.from(skillTitle!.map((x) => x)),
        "title": title,
      };
}
