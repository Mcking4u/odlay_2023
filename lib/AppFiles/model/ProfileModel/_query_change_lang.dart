// To parse this JSON data, do
//
//     final querChangeLanguage = querChangeLanguageFromJson(jsonString);

import 'dart:convert';

QuerChangeLanguage querChangeLanguageFromJson(String str) =>
    QuerChangeLanguage.fromJson(json.decode(str));

String querChangeLanguageToJson(QuerChangeLanguage data) =>
    json.encode(data.toJson());

class QuerChangeLanguage {
  QuerChangeLanguage({
    required this.id,
    required this.language,
  });

  String? id;
  String? language;

  factory QuerChangeLanguage.fromJson(Map<String, dynamic> json) =>
      QuerChangeLanguage(
        id: json["id"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "language": language,
      };
}
