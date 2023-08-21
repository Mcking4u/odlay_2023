// To parse this JSON data, do
//
//     final reposneGeneral = reposneGeneralFromJson(jsonString);

import 'dart:convert';

ReposneGeneral reposneGeneralFromJson(String str) =>
    ReposneGeneral.fromJson(json.decode(str));

String reposneGeneralToJson(ReposneGeneral data) => json.encode(data.toJson());

class ReposneGeneral {
  ReposneGeneral({
    required this.status,
    required this.message,
  });

  String? status;
  String? message;

  factory ReposneGeneral.fromJson(Map<String, dynamic> json) => ReposneGeneral(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
