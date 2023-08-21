// To parse this JSON data, do
//
//     final responseMyJobsSummary = responseMyJobsSummaryFromJson(jsonString);

import 'dart:convert';

ResponseMyJobsSummary responseMyJobsSummaryFromJson(String str) =>
    ResponseMyJobsSummary.fromJson(json.decode(str));

String responseMyJobsSummaryToJson(ResponseMyJobsSummary data) =>
    json.encode(data.toJson());

class ResponseMyJobsSummary {
  ResponseMyJobsSummary({
    required this.jobsSummary,
    required this.status,
  });

  List<JobsSummary> jobsSummary;
  String status;

  factory ResponseMyJobsSummary.fromJson(Map<String, dynamic> json) =>
      ResponseMyJobsSummary(
        jobsSummary: List<JobsSummary>.from(
            json["jobs_summary"].map((x) => JobsSummary.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "jobs_summary": List<dynamic>.from(jobsSummary.map((x) => x.toJson())),
        "status": status,
      };
}

class JobsSummary {
  JobsSummary({
    required this.id,
    required this.consumerId,
    required this.title,
    required this.jobgid,
    required this.budget,
    required this.contactPerson,
    required this.contactPhone,
    required this.detail,
    this.deadline,
    required this.urgent,
    required this.gender,
    required this.distanceType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.logo,
    this.paymentMethod,
    required this.notificationSent,
    this.jobImages,
    required this.inviteStatus,
    required this.skillId,
  });

  int? id;
  int? consumerId;
  String? title;
  String? jobgid;
  String? budget;
  String? contactPerson;
  String? contactPhone;
  String? detail;
  String? deadline;
  int? urgent;
  int? gender;
  int? distanceType;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? logo;
  dynamic paymentMethod;
  int notificationSent;
  dynamic jobImages;
  int inviteStatus;
  List<int> skillId;

  factory JobsSummary.fromJson(Map<String, dynamic> json) => JobsSummary(
        id: json["id"],
        consumerId: json["consumer_id"],
        title: json["title"],
        jobgid: json["jobgid"],
        budget: json["budget"],
        contactPerson: json["contact_person"],
        contactPhone: json["contact_phone"],
        detail: json["detail"],
        deadline: json["deadline"],
        urgent: json["urgent"],
        gender: json["gender"],
        distanceType: json["distance_type"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        logo: json["logo"],
        paymentMethod: json["payment_method"],
        notificationSent: json["notification_sent"],
        jobImages: json["job_images"],
        inviteStatus: json["invite_status"],
        skillId: List<int>.from(json["skill_id"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "consumer_id": consumerId,
        "title": title,
        "jobgid": jobgid,
        "budget": budget,
        "contact_person": contactPerson,
        "contact_phone": contactPhone,
        "detail": detail,
        "deadline": deadline,
        "urgent": urgent,
        "gender": gender,
        "distance_type": distanceType,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "logo": logo,
        "payment_method": paymentMethod,
        "notification_sent": notificationSent,
        "job_images": jobImages,
        "invite_status": inviteStatus,
        "skill_id": List<dynamic>.from(skillId.map((x) => x)),
      };
}
