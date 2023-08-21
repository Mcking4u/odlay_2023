// To parse this JSON data, do
//
//     final queryDirectJobCreation = queryDirectJobCreationFromJson(jsonString);

import 'dart:convert';

QueryDirectJobCreation queryDirectJobCreationFromJson(String str) =>
    QueryDirectJobCreation.fromJson(json.decode(str));

String queryDirectJobCreationToJson(QueryDirectJobCreation data) =>
    json.encode(data.toJson());

class QueryDirectJobCreation {
  QueryDirectJobCreation(
      {required this.address,
      required this.apiKey,
      required this.budget,
      required this.consumerId,
      required this.detail,
      this.gigId,
      this.gigQty,
      required this.cityId,
      required this.latitude,
      required this.longitude,
      this.serviceId,
      required this.status,
      required this.title,
      this.deadline,
      this.job_privacy,
      required this.skillId
      });

  String? address;
  String? apiKey;
  String? budget;
  String? consumerId;
  String? detail;
  String? gigId;
  int? gigQty;
  int? cityId;
  double? latitude;
  double? longitude;
  String? serviceId;
  int? status;
  String? title;
  String? deadline;
  int? job_privacy;
  String? skillId;

  factory QueryDirectJobCreation.fromJson(Map<String, dynamic> json) =>
      QueryDirectJobCreation(
          address: json["address"],
          apiKey: json["api_key"],
          budget: json["budget"],
          consumerId: json["consumer_id"],
          detail: json["detail"],
          gigId: json["gig_id"],
          gigQty: json["gig_qty"],
          cityId: json["city_id"],
          latitude: json["latitude"].toDouble(),
          longitude: json["longitude"].toDouble(),
          serviceId: json["service_id"],
          status: json["status"],
          title: json["title"],
          deadline: json["deadline"],
          job_privacy: json["job_privacy"],
          skillId: json["skill_id"],);

  Map<String, dynamic> toJson() => {
        "address": address,
        "api_key": apiKey,
        "budget": budget,
        "consumer_id": consumerId,
        "detail": detail,
        "gig_id": gigId,
        "gig_qty": gigQty,
        "city_id": cityId,
        "latitude": latitude,
        "longitude": longitude,
        "service_id": serviceId,
        "status": status,
        "title": title,
        "deadline": deadline,
        "job_privacy": job_privacy,
        "skill_id":skillId
      };
}
