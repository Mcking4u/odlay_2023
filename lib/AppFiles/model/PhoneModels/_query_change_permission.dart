// To parse this JSON data, do
//
//     final queryChangePermission = queryChangePermissionFromJson(jsonString);

import 'dart:convert';

QueryChangePermission queryChangePermissionFromJson(String str) =>
    QueryChangePermission.fromJson(json.decode(str));

String queryChangePermissionToJson(QueryChangePermission data) =>
    json.encode(data.toJson());

class QueryChangePermission {
  QueryChangePermission({
    required this.id,
    required this.allowMobileCall,
  });

  String id;
  String allowMobileCall;

  factory QueryChangePermission.fromJson(Map<String, dynamic> json) =>
      QueryChangePermission(
        id: json["id"],
        allowMobileCall: json["allow_mobile_call"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "allow_mobile_call": allowMobileCall,
      };
}
