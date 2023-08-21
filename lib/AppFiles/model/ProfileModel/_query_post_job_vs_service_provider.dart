// To parse this JSON data, do
//
//     final queryPostJobVsServiceProvider = queryPostJobVsServiceProviderFromJson(jsonString);

import 'dart:convert';

QueryPostJobVsServiceProvider queryPostJobVsServiceProviderFromJson(
        String str) =>
    QueryPostJobVsServiceProvider.fromJson(json.decode(str));

String queryPostJobVsServiceProviderToJson(
        QueryPostJobVsServiceProvider data) =>
    json.encode(data.toJson());

class QueryPostJobVsServiceProvider {
  QueryPostJobVsServiceProvider({
    required this.consumerId,
    required this.serviceId,
  });

  String consumerId;
  String serviceId;

  factory QueryPostJobVsServiceProvider.fromJson(Map<String, dynamic> json) =>
      QueryPostJobVsServiceProvider(
        consumerId: json["consumer_id"],
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "consumer_id": consumerId,
        "service_id": serviceId,
      };
}
