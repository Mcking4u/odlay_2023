// To parse this JSON data, do
//
//     final queryQuickUpdate = queryQuickUpdateFromJson(jsonString);

import 'dart:convert';

QueryQuickUpdate queryQuickUpdateFromJson(String str) =>
    QueryQuickUpdate.fromJson(json.decode(str));

String queryQuickUpdateToJson(QueryQuickUpdate data) =>
    json.encode(data.toJson());

class QueryQuickUpdate {
  QueryQuickUpdate({
    required this.cityId,
    required this.fullAddress,
    required this.isServiceProvider,
    required this.latitude,
    required this.longitude,
    required this.id,
    this.skills,
  });

  int? cityId;
  String? fullAddress;
  bool? isServiceProvider;
  double? latitude;
  double? longitude;
  int? id;
  List<int>? skills;

  factory QueryQuickUpdate.fromJson(Map<String, dynamic> json) =>
      QueryQuickUpdate(
        cityId: json["city_id"],
        fullAddress: json["full_address"],
        isServiceProvider: json["is_service_provider"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        skills: List<int>.from(json["skills"].map((x) => x)),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
        "full_address": fullAddress,
        "is_service_provider": isServiceProvider,
        "latitude": latitude,
        "longitude": longitude,
        "skills": List<dynamic>.from(skills!.map((x) => x)),
        "id": id,
      };
}
