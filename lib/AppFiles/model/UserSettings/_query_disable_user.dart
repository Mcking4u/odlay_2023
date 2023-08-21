// To parse this JSON data, do
//
//     final querDiableUser = querDiableUserFromJson(jsonString);

import 'dart:convert';

QuerDiableUser? querDiableUserFromJson(String str) =>
    QuerDiableUser.fromJson(json.decode(str));

String querDiableUserToJson(QuerDiableUser? data) =>
    json.encode(data!.toJson());

class QuerDiableUser {
  QuerDiableUser({
    this.userId,
    this.requestType,
  });

  String? userId;
  int? requestType;

  factory QuerDiableUser.fromJson(Map<String, dynamic> json) => QuerDiableUser(
        userId: json["user_id"],
        requestType: json["request_type"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "request_type": requestType,
      };
}
