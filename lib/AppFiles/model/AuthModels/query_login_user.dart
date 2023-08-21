// To parse this JSON data, do
//
//     final queryLoginUser = queryLoginUserFromJson(jsonString);

import 'dart:convert';

QueryLoginUser queryLoginUserFromJson(String str) =>
    QueryLoginUser.fromJson(json.decode(str));

String queryLoginUserToJson(QueryLoginUser data) => json.encode(data.toJson());

class QueryLoginUser {
  QueryLoginUser({
    required this.password,
    required this.phone,
  });

  String password;
  String phone;

  factory QueryLoginUser.fromJson(Map<String, dynamic> json) => QueryLoginUser(
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "phone": phone,
      };
}
