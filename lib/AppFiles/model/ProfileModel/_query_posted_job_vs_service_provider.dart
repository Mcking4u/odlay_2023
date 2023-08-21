// To parse this JSON data, do
//
//     final queryPostedJobVsProvider = queryPostedJobVsProviderFromJson(jsonString);

import 'dart:convert';

QueryPostedJobVsProvider? queryPostedJobVsProviderFromJson(String str) =>
    QueryPostedJobVsProvider.fromJson(json.decode(str));

String queryPostedJobVsProviderToJson(QueryPostedJobVsProvider? data) =>
    json.encode(data!.toJson());

class QueryPostedJobVsProvider {
  QueryPostedJobVsProvider({
    this.consumerId,
    this.serviceId,
  });

  String? consumerId;
  String? serviceId;

  factory QueryPostedJobVsProvider.fromJson(Map<String, dynamic> json) =>
      QueryPostedJobVsProvider(
        consumerId: json["consumer_id"],
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "consumer_id": consumerId,
        "service_id": serviceId,
      };
}
