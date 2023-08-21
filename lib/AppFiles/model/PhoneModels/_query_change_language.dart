// To parse this JSON data, do
//
//     final queryChangeLanguage = queryChangeLanguageFromJson(jsonString);

import 'dart:convert';

QueryChangeLanguage queryChangeLanguageFromJson(String str) =>
    QueryChangeLanguage.fromJson(json.decode(str));

String queryChangeLanguageToJson(QueryChangeLanguage data) =>
    json.encode(data.toJson());

class QueryChangeLanguage {
  QueryChangeLanguage({
    required this.id,
    required this.language,
  });

  String id;
  String language;

  factory QueryChangeLanguage.fromJson(Map<String, dynamic> json) =>
      QueryChangeLanguage(
        id: json["id"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "language": language,
      };
}
