// To parse this JSON data, do
//
//     final queryUpdatedProfile = queryUpdatedProfileFromJson(jsonString);

import 'dart:convert';

QueryUpdatedProfile queryUpdatedProfileFromJson(String str) =>
    QueryUpdatedProfile.fromJson(json.decode(str));

String queryUpdatedProfileToJson(QueryUpdatedProfile data) =>
    json.encode(data.toJson());

class QueryUpdatedProfile {
  QueryUpdatedProfile({
    required this.userId,
    required this.language,
  });

  String userId;
  int? language;

  factory QueryUpdatedProfile.fromJson(Map<String, dynamic> json) =>
      QueryUpdatedProfile(
        userId: json["user_id"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "language": language,
      };
}
