// To parse this JSON data, do
//
//     final responseFeaturedGigs = responseFeaturedGigsFromJson(jsonString);

import 'dart:convert';

ResponseFeaturedGigs responseFeaturedGigsFromJson(String str) =>
    ResponseFeaturedGigs.fromJson(json.decode(str));

String responseFeaturedGigsToJson(ResponseFeaturedGigs data) =>
    json.encode(data.toJson());

class ResponseFeaturedGigs {
  ResponseFeaturedGigs({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int? currentPage;
  List<Datum> data;
  String firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory ResponseFeaturedGigs.fromJson(Map<String, dynamic> json) =>
      ResponseFeaturedGigs(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    required this.userId,
    required this.firebaseUid,
    required this.deviceToken,
    required this.title,
    required this.companyId,
    this.dob,
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
  String? lastName;
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
  List<Skill>? skills;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        title: json["title"] == null ? null : json["title"],
        companyId: json["company_id"],
        dob: json["dob"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        logo: json["logo"],
        phone: json["phone"],
        roleId: json["role_id"],
        status: json["status"],
        idCardStatus: json["id_card_status"],
        addressProofStatus: json["address_proof_status"],
        profilePicStatus: json["profile_pic_status"] == null
            ? null
            : json["profile_pic_status"],
        gigId: json["gig_id"],
        gigTitle: json["gig_title"],
        gigDetail: json["gig_detail"],
        gigPrice: json["gig_price"],
        gigImages: json["gig_images"] == null ? null : json["gig_images"],
        cityId: json["city_id"],
        gigStatus: json["gig_status"],
        rating: json["rating"] == null ? null : json["rating"],
        skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        "title": title == null ? null : title,
        "company_id": companyId,
        "dob": dob,
        "email": email,
        "first_name": firstName,
        "last_name": lastName == null ? null : lastName,
        "logo": logo,
        "phone": phone,
        "role_id": roleId,
        "status": status,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "profile_pic_status":
            profilePicStatus == null ? null : profilePicStatus,
        "gig_id": gigId,
        "gig_title": gigTitle,
        "gig_detail": gigDetail,
        "gig_price": gigPrice,
        "gig_images": gigImages == null ? null : gigImages,
        "city_id": cityId,
        "gig_status": gigStatus,
        "rating": rating == null ? null : rating,
        "skills": List<dynamic>.from(skills!.map((x) => x.toJson())),
      };
}

class Skill {
  Skill({
    required this.skillId,
    required this.skillName,
    required this.gid,
  });

  int skillId;
  String skillName;
  String gid;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
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
