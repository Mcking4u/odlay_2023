// To parse this JSON data, do
//
//     final queryEditProfile = queryEditProfileFromJson(jsonString);

import 'dart:convert';

QueryEditProfile queryEditProfileFromJson(String str) =>
    QueryEditProfile.fromJson(json.decode(str));

String queryEditProfileToJson(QueryEditProfile data) =>
    json.encode(data.toJson());

class QueryEditProfile {
  QueryEditProfile(
      {required this.id,
      required this.firstName,
      required this.cityId,
      required this.email,
      required this.phone,
      required this.fullAddress,
      required this.isServiceProvider,
      required this.latitude,
      required this.longitude,
      this.title});

  int? id;
  String firstName;
  int cityId;
  String email;
  String phone;
  String fullAddress;
  bool isServiceProvider;
  double latitude;
  double longitude;
  String? title;

  factory QueryEditProfile.fromJson(Map<String, dynamic> json) =>
      QueryEditProfile(
          id: json["id"],
          firstName: json["first_name"],
          cityId: json["city_id"],
          email: json["email"],
          phone: json["phone"],
          fullAddress: json["full_address"],
          isServiceProvider: json["is_service_provider"],
          latitude: json["latitude"],
          longitude: json["longitude"],
          title: json["title"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "city_id": cityId,
        "email": email,
        "phone": phone,
        "full_address": fullAddress,
        "is_service_provider": isServiceProvider,
        "latitude": latitude,
        "longitude": longitude,
        "title": title
      };
}
