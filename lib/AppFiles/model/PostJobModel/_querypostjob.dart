// To parse this JSON data, do
//
//     final queryPostJob = queryPostJobFromJson(jsonString);

import 'dart:convert';

QueryPostJob queryPostJobFromJson(String str) =>
    QueryPostJob.fromJson(json.decode(str));

String queryPostJobToJson(QueryPostJob data) => json.encode(data.toJson());

class QueryPostJob {
  QueryPostJob({
    required this.address,
    required this.apiKey,
    required this.cityId,
    required this.consumerId,
    required this.contactPerson,
    required this.contactPhone,
    this.deadline,
    this.detail,
    required this.distanceType,
    required this.gender,
    required this.budget,
    required this.latitude,
    required this.longitude,
    required this.language,
    this.skillId,
    this.skillTitle,
    required this.title,
  });

  String? address;
  String? apiKey;
  String? cityId;
  String? consumerId;
  String? contactPerson;
  String? contactPhone;
  String? deadline;
  String? detail;
  String? distanceType;
  String? gender;
  String? budget;
  String? latitude;
  String? longitude;
  String? language;
  String? skillId;
  List<String>? skillTitle;
  String title;

  factory QueryPostJob.fromJson(Map<String, dynamic> json) => QueryPostJob(
        address: json["address"],
        apiKey: json["api_key"],
        cityId: json["city_id"],
        consumerId: json["consumer_id"],
        contactPerson: json["contact_person"],
        contactPhone: json["contact_phone"],
        deadline: json["deadline"],
        detail: json["detail"],
        distanceType: json["distance_type"],
        gender: json["gender"],
        budget: json["budget"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        language: json["language"],
        skillId: json["skill_id"],
        skillTitle: List<String>.from(json["skill_title"].map((x) => x)),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "api_key": apiKey,
        "city_id": cityId,
        "consumer_id": consumerId,
        "contact_person": contactPerson,
        "contact_phone": contactPhone,
        "deadline": deadline,
        "detail": detail,
        "distance_type": distanceType,
        "gender": gender,
        "budget": budget,
        "latitude": latitude,
        "longitude": longitude,
        "language": language,
        "skill_id": skillId,
        "skill_title": List<dynamic>.from(skillTitle!.map((x) => x)),
        "title": title,
      };
}
