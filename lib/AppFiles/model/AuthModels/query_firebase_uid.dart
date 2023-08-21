// To parse this JSON data, do
//
//     final queryFirebaseUid = queryFirebaseUidFromJson(jsonString);

import 'dart:convert';

QueryFirebaseUid queryFirebaseUidFromJson(String str) =>
    QueryFirebaseUid.fromJson(json.decode(str));

String queryFirebaseUidToJson(QueryFirebaseUid data) =>
    json.encode(data.toJson());

class QueryFirebaseUid {
  QueryFirebaseUid({
    required this.deviceToken,
    required this.firebaseUid,
    required this.userId,
  });

  String deviceToken;
  String firebaseUid;
  String userId;

  factory QueryFirebaseUid.fromJson(Map<String, dynamic> json) =>
      QueryFirebaseUid(
        deviceToken: json["device_token"],
        firebaseUid: json["firebase_uid"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "device_token": deviceToken,
        "firebase_uid": firebaseUid,
        "user_id": userId,
      };
}
