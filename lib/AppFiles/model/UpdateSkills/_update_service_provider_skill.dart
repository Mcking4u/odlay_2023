// To parse this JSON data, do
//
//     final queryUpdateSkill = queryUpdateSkillFromJson(jsonString);

import 'dart:convert';

QueryUpdateSkill queryUpdateSkillFromJson(String str) =>
    QueryUpdateSkill.fromJson(json.decode(str));

String queryUpdateSkillToJson(QueryUpdateSkill data) =>
    json.encode(data.toJson());

class QueryUpdateSkill {
  QueryUpdateSkill({
    required this.apiKey,
    required this.userId,
    required this.skills,
  });

  String apiKey;
  String userId;
  List<int> skills;

  factory QueryUpdateSkill.fromJson(Map<String, dynamic> json) =>
      QueryUpdateSkill(
        apiKey: json["api_key"],
        userId: json["user_id"],
        skills: List<int>.from(json["skills"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "user_id": userId,
        "skills": List<dynamic>.from(skills.map((x) => x)),
      };
}
