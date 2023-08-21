// To parse this JSON data, do
//
//     final serviceproviderJobsShowResponse = serviceproviderJobsShowResponseFromJson(jsonString);

import 'dart:convert';

ServiceproviderJobsShowResponse serviceproviderJobsShowResponseFromJson(
        String str) =>
    ServiceproviderJobsShowResponse.fromJson(json.decode(str));

String serviceproviderJobsShowResponseToJson(
        ServiceproviderJobsShowResponse data) =>
    json.encode(data.toJson());

class ServiceproviderJobsShowResponse {
  ServiceproviderJobsShowResponse({
    required this.applied,
    required this.status,
  });

  List<Applied> applied;
  String status;

  factory ServiceproviderJobsShowResponse.fromJson(Map<String, dynamic> json) =>
      ServiceproviderJobsShowResponse(
        applied:
            List<Applied>.from(json["applied"].map((x) => Applied.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "applied": List<dynamic>.from(applied.map((x) => x.toJson())),
        "status": status,
      };
}

class Applied {
  Applied({
    required this.jobTitle,
    required this.jobDesc,
    required this.createdAt,
    required this.updatedAt,
    required this.deadline,
    required this.customerBudget,
    this.jobImages,
    required this.status,
    required this.consumerId,
    this.budgetAmount,
    required this.odlayFee,
    required this.totalCharged,
    required this.bidAmount,
    required this.spReceivableAmount,
    required this.spOdlayFee,
    required this.budgetOption,
    required this.duration,
    required this.userId,
    required this.jobId,
    this.startedAt,
    required this.defaultView,
    required this.firebaseUid,
    required this.deviceToken,
    required this.address,
    required this.cityId,
    required this.longitude,
    required this.latitude,
    this.paymentMethod,
    required this.consumerName,
    required this.logo,
    required this.jobskills,
    required this.skillId,
  });

  String? jobTitle;
  String? jobDesc;
  String? createdAt;
  String? updatedAt;
  String? deadline;
  String? customerBudget;
  String? jobImages;
  int? status;
  int? consumerId;
  String? budgetAmount;
  String? odlayFee;
  String? totalCharged;
  String? bidAmount;
  String? spReceivableAmount;
  String? spOdlayFee;
  String? budgetOption;
  int? duration;
  int? userId;
  int? jobId;
  dynamic startedAt;
  String? defaultView;
  String? firebaseUid;
  String? deviceToken;
  String? address;
  int? cityId;
  String? longitude;
  String? latitude;
  dynamic paymentMethod;
  String? consumerName;
  String? logo;
  List<Jobskill> jobskills;
  List<int> skillId;

  factory Applied.fromJson(Map<String, dynamic> json) => Applied(
        jobTitle: json["job_title"],
        jobDesc: json["job_desc"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deadline: json["deadline"],
        customerBudget: json["customer_budget"],
        jobImages: json["job_images"],
        status: json["status"],
        consumerId: json["consumer_id"],
        budgetAmount: json["budget_amount"],
        odlayFee: json["odlay_fee"],
        totalCharged: json["total_charged"],
        bidAmount: json["bid_amount"],
        spReceivableAmount: json["sp_receivable_amount"],
        spOdlayFee: json["sp_odlay_fee"],
        budgetOption: json["budget_option"],
        duration: json["duration"],
        userId: json["user_id"],
        jobId: json["job_id"],
        startedAt: json["started_at"],
        defaultView: json["default_view"],
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        address: json["address"],
        cityId: json["city_id"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        paymentMethod: json["payment_method"],
        consumerName: json["consumer_name"],
        logo: json["logo"],
        jobskills: List<Jobskill>.from(
            json["jobskills"].map((x) => Jobskill.fromJson(x))),
        skillId: List<int>.from(json["skill_id"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "job_title": jobTitle,
        "job_desc": jobDesc,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deadline": deadline,
        "customer_budget": customerBudget,
        "job_images": jobImages,
        "status": status,
        "consumer_id": consumerId,
        "budget_amount": budgetAmount,
        "odlay_fee": odlayFee,
        "total_charged": totalCharged,
        "bid_amount": bidAmount,
        "sp_receivable_amount": spReceivableAmount,
        "sp_odlay_fee": spOdlayFee,
        "budget_option": budgetOption,
        "duration": duration,
        "user_id": userId,
        "job_id": jobId,
        "started_at": startedAt,
        "default_view": defaultView,
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        "address": address,
        "city_id": cityId,
        "longitude": longitude,
        "latitude": latitude,
        "payment_method": paymentMethod,
        "consumer_name": consumerName,
        "logo": logo,
        "jobskills": List<dynamic>.from(jobskills.map((x) => x.toJson())),
        "skill_id": List<dynamic>.from(skillId.map((x) => x)),
      };
}

class Jobskill {
  Jobskill({
    required this.skillId,
    required this.skillName,
  });

  int? skillId;
  String? skillName;

  factory Jobskill.fromJson(Map<String, dynamic> json) => Jobskill(
        skillId: json["skill_id"],
        skillName: json["skill_name"],
      );

  Map<String, dynamic> toJson() => {
        "skill_id": skillId,
        "skill_name": skillName,
      };
}
