// To parse this JSON data, do
//
//     final queryEditGig = queryEditGigFromJson(jsonString);

import 'dart:convert';

QueryEditGig queryEditGigFromJson(String str) =>
    QueryEditGig.fromJson(json.decode(str));

String queryEditGigToJson(QueryEditGig data) => json.encode(data.toJson());

class QueryEditGig {
  QueryEditGig(
      {required this.apiKey,
      required this.gigId,
      required this.editType,
      required this.status,
      this.title,
      this.price,
      this.skill_id,
      this.skill_title,
      this.city_id,
      this.detail});

  String? apiKey;
  String? gigId;
  String? editType;
  int? status;
  String? title;
  int? price;
  String? skill_id;
  String? skill_title;
  String? city_id;
  String? detail;

  factory QueryEditGig.fromJson(Map<String, dynamic> json) => QueryEditGig(
        apiKey: json["api_key"],
        gigId: json["gig_id"],
        editType: json["edit_type"],
        status: json["status"],
        title: json["title"],
        price: json["price"],
        skill_id: json["skill_id"],
        skill_title: json["skill_title"],
        city_id: json["city_id"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "gig_id": gigId,
        "edit_type": editType,
        "status": status,
        "title": title,
        "price": price,
        "skill_id": skill_id,
        "skill_title": skill_title,
        "city_id": city_id,
        "detail": detail,
      };
}
