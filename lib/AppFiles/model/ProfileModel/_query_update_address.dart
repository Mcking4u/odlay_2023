// To parse this JSON data, do
//
//     final queryUpdateAddress = queryUpdateAddressFromJson(jsonString);

import 'dart:convert';

QueryUpdateAddress queryUpdateAddressFromJson(String str) =>
    QueryUpdateAddress.fromJson(json.decode(str));

String queryUpdateAddressToJson(QueryUpdateAddress data) =>
    json.encode(data.toJson());

class QueryUpdateAddress {
  QueryUpdateAddress({
    required this.id,
    required this.cityId,
    required this.fullAddress,
    required this.isServiceProvider,
    required this.latitude,
    required this.longitude,
  });

  int? id;
  int? cityId;
  String? fullAddress;
  int? isServiceProvider;
  String? latitude;
  String? longitude;

  factory QueryUpdateAddress.fromJson(Map<String, dynamic> json) =>
      QueryUpdateAddress(
        id: json["id"],
        cityId: json["city_id"],
        fullAddress: json["full_address"],
        isServiceProvider: json["is_service_provider"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_id": cityId,
        "full_address": fullAddress,
        "is_service_provider": isServiceProvider,
        "latitude": latitude,
        "longitude": longitude,
      };
}
