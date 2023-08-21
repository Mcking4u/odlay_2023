// To parse this JSON data, do
//
//     final responseReadSingleGigDetail = responseReadSingleGigDetailFromJson(jsonString);

import 'dart:convert';

ResponseReadSingleGigDetail responseReadSingleGigDetailFromJson(String str) =>
    ResponseReadSingleGigDetail.fromJson(json.decode(str));

String responseReadSingleGigDetailToJson(ResponseReadSingleGigDetail data) =>
    json.encode(data.toJson());

class ResponseReadSingleGigDetail {
  ResponseReadSingleGigDetail({
    required this.userId,
    required this.firebaseUid,
    required this.deviceToken,
    required this.title,
    required this.companyId,
    required this.dob,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.logo,
    required this.phone,
    required this.roleId,
    required this.status,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.profilePicStatus,
    required this.gigId,
    required this.gigTitle,
    required this.gigDetail,
    required this.gigPrice,
    required this.gigImages,
    required this.cityId,
    required this.gigStatus,
    required this.rating,
    required this.skills,
  });

  int? userId;
  String? firebaseUid;
  String? deviceToken;
  String? title;
  int? companyId;
  dynamic dob;
  String? email;
  String? firstName;
  dynamic lastName;
  String? logo;
  String? phone;
  int? roleId;
  int? status;
  int? idCardStatus;
  int? addressProofStatus;
  int? profilePicStatus;
  int? gigId;
  String? gigTitle;
  String? gigDetail;
  int? gigPrice;
  String? gigImages;
  int? cityId;
  int? gigStatus;
  String? rating;
  List<SingleGigSkill>? skills;

  factory ResponseReadSingleGigDetail.fromJson(Map<String, dynamic> json) =>
      ResponseReadSingleGigDetail(
        userId: json["user_id"],
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        title: json["title"],
        companyId: json["company_id"],
        dob: json["dob"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        logo: json["logo"],
        phone: json["phone"],
        roleId: json["role_id"],
        status: json["status"],
        idCardStatus: json["id_card_status"],
        addressProofStatus: json["address_proof_status"],
        profilePicStatus: json["profile_pic_status"],
        gigId: json["gig_id"],
        gigTitle: json["gig_title"],
        gigDetail: json["gig_detail"],
        gigPrice: json["gig_price"],
        gigImages: json["gig_images"],
        cityId: json["city_id"],
        gigStatus: json["gig_status"],
        rating: json["rating"],
        skills: List<SingleGigSkill>.from(
            json["skills"].map((x) => SingleGigSkill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        "title": title,
        "company_id": companyId,
        "dob": dob,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "logo": logo,
        "phone": phone,
        "role_id": roleId,
        "status": status,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "profile_pic_status": profilePicStatus,
        "gig_id": gigId,
        "gig_title": gigTitle,
        "gig_detail": gigDetail,
        "gig_price": gigPrice,
        "gig_images": gigImages,
        "city_id": cityId,
        "gig_status": gigStatus,
        "rating": rating,
        "skills": List<dynamic>.from(skills!.map((x) => x.toJson())),
      };
}

class SingleGigSkill {
  SingleGigSkill(
      {required this.skillId, required this.skillName, required this.gid});

  int? skillId;
  String? skillName;
  String? gid;

  factory SingleGigSkill.fromJson(Map<String, dynamic> json) => SingleGigSkill(
        skillId: json["skill_id"],
        skillName: json["skill_name"],
        gid: json["gid"],
      );

  Map<String, dynamic> toJson() => {
        "skill_id": skillId,
        "skill_name": skillName,
        "gid": gid,
      };
}
