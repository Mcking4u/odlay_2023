// To parse this JSON data, do
//
//     final queryRegisterUser = queryRegisterUserFromJson(jsonString);

import 'dart:convert';

QueryRegisterUser queryRegisterUserFromJson(String str) =>
    QueryRegisterUser.fromJson(json.decode(str));

String queryRegisterUserToJson(QueryRegisterUser data) =>
    json.encode(data.toJson());

class QueryRegisterUser {
  QueryRegisterUser({
    required this.email,
    required this.firstName,
    required this.gender,
    required this.firebaseUid,
    required this.password,
    required this.phone,
  });

  String email;
  String firstName;
  String gender;
  String firebaseUid;
  String password;
  String phone;

  factory QueryRegisterUser.fromJson(Map<String, dynamic> json) =>
      QueryRegisterUser(
        email: json["email"],
        firstName: json["first_name"],
        gender: json["gender"],
        firebaseUid: json["firebase_uid"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "gender": gender,
        "firebase_uid": firebaseUid,
        "password": password,
        "phone": phone,
      };
}
