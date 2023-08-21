// To parse this JSON data, do
//
//     final responseJobDetail = responseJobDetailFromJson(jsonString);

import 'dart:convert';

ResponseJobDetail responseJobDetailFromJson(String str) =>
    ResponseJobDetail.fromJson(json.decode(str));

String responseJobDetailToJson(ResponseJobDetail data) =>
    json.encode(data.toJson());

class ResponseJobDetail {
  ResponseJobDetail({
    required this.jobdetail,
    required this.status,
  });

  Jobdetail jobdetail;
  String status;

  factory ResponseJobDetail.fromJson(Map<String, dynamic> json) =>
      ResponseJobDetail(
        jobdetail: Jobdetail.fromJson(json["jobdetail"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "jobdetail": jobdetail.toJson(),
        "status": status,
      };
}

class Jobdetail {
  Jobdetail({
    required this.firebaseUid,
    required this.deviceToken,
    required this.consumerTitle,
    required this.consumerName,
    required this.id,
    required this.consumerId,
    required this.title,
    this.contactPerson,
    this.contactPhone,
    required this.detail,
    required this.deadline,
    required this.gender,
    required this.distanceType,
    required this.status,
    required this.budget,
    required this.createdAt,
    required this.address,
    required this.cityId,
    required this.latitude,
    required this.longitude,
    required this.userLogo,
    required this.skillId,
    required this.jobImages,
  });

  String? firebaseUid;
  String? deviceToken;
  String? consumerTitle;
  String? consumerName;
  int? id;
  int? consumerId;
  String? title;
  dynamic contactPerson;
  dynamic contactPhone;
  String? detail;
  String? deadline;
  int? gender;
  int? distanceType;
  int? status;
  String? budget;
  DateTime? createdAt;
  String? address;
  int? cityId;
  String? latitude;
  String? longitude;
  String? userLogo;
  List<int>? skillId;
  String? jobImages;

  factory Jobdetail.fromJson(Map<String, dynamic> json) => Jobdetail(
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        consumerTitle: json["consumer_title"],
        consumerName: json["consumer_name"],
        id: json["id"],
        consumerId: json["consumer_id"],
        title: json["title"],
        contactPerson: json["contact_person"],
        contactPhone: json["contact_phone"],
        detail: json["detail"],
        deadline: json["deadline"],
        gender: json["gender"],
        distanceType: json["distance_type"],
        status: json["status"],
        budget: json["budget"],
        createdAt: DateTime.parse(json["created_at"]),
        address: json["address"],
        cityId: json["city_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        userLogo: json["user_logo"],
        skillId: List<int>.from(json["skill_id"].map((x) => x)),
        jobImages: json["job_images"],
      );

  Map<String, dynamic> toJson() => {
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        "consumer_title": consumerTitle,
        "consumer_name": consumerName,
        "id": id,
        "consumer_id": consumerId,
        "title": title,
        "contact_person": contactPerson,
        "contact_phone": contactPhone,
        "detail": detail,
        "deadline": deadline,
        "gender": gender,
        "distance_type": distanceType,
        "status": status,
        "budget": budget,
        "created_at": createdAt,
        "address": address,
        "city_id": cityId,
        "latitude": latitude,
        "longitude": longitude,
        "user_logo": userLogo,
        "skill_id": List<dynamic>.from(skillId!.map((x) => x)),
        "job_images": jobImages,
      };
}
