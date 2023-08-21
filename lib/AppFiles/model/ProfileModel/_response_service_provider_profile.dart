// To parse this JSON data, do
//
//     final responseServiceProviderProfile = responseServiceProviderProfileFromJson(jsonString);

import 'dart:convert';

ResponseServiceProviderProfile responseServiceProviderProfileFromJson(
        String str) =>
    ResponseServiceProviderProfile.fromJson(json.decode(str));

String responseServiceProviderProfileToJson(
        ResponseServiceProviderProfile data) =>
    json.encode(data.toJson());

class ResponseServiceProviderProfile {
  ResponseServiceProviderProfile({
    required this.serviceId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    this.postalCode,
    required this.streetNo,
    required this.id,
    required this.defaultView,
    required this.companyId,
    this.dob,
    required this.email,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.logo,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.profilePicStatus,
    required this.phone,
    required this.roleId,
    required this.firebaseUid,
    required this.deviceToken,
    required this.status,
    this.objective,
    this.profession,
    required this.portfolioImages,
    required this.allowMobileCall,
    required this.distance,
    required this.skills,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
    required this.gigs,
  });

  int? serviceId;
  String? address;
  String? latitude;
  String? longitude;
  int? cityId;
  String? postalCode;
  String? streetNo;
  int? id;
  String? defaultView;
  int? companyId;
  String? dob;
  String? email;
  String? title;
  String? firstName;
  String? lastName;
  String? logo;
  int? idCardStatus;
  int? addressProofStatus;
  int? profilePicStatus;
  String? phone;
  int? roleId;
  String? firebaseUid;
  String? deviceToken;
  int? status;
  dynamic objective;
  dynamic profession;
  String? portfolioImages;
  int? allowMobileCall;
  double? distance;
  List<Skill>? skills;
  String? rating;
  int? reviewsCount;
  List<Review>? reviews;
  List<Gig>? gigs;

  factory ResponseServiceProviderProfile.fromJson(Map<String, dynamic> json) =>
      ResponseServiceProviderProfile(
        serviceId: json["service_id"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        streetNo: json["street_no"],
        id: json["id"],
        defaultView: json["default_view"],
        companyId: json["company_id"],
        dob: json["dob"],
        email: json["email"],
        title: json["title"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        logo: json["logo"],
        idCardStatus: json["id_card_status"],
        addressProofStatus: json["address_proof_status"],
        profilePicStatus: json["profile_pic_status"],
        phone: json["phone"],
        roleId: json["role_id"],
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        status: json["status"],
        objective: json["objective"],
        profession: json["profession"],
        portfolioImages: json["portfolio_images"],
        allowMobileCall: json["allow_mobile_call"],
        distance: json["distance"].toDouble(),
        skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        rating: json["rating"],
        reviewsCount: json["reviews_count"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        gigs: List<Gig>.from(json["gigs"].map((x) => Gig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "city_id": cityId,
        "postal_code": postalCode,
        "street_no": streetNo,
        "id": id,
        "default_view": defaultView,
        "company_id": companyId,
        "dob": dob,
        "email": email,
        "title": title,
        "first_name": firstName,
        "last_name": lastName,
        "logo": logo,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "profile_pic_status": profilePicStatus,
        "phone": phone,
        "role_id": roleId,
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        "status": status,
        "objective": objective,
        "profession": profession,
        "portfolio_images": portfolioImages,
        "allow_mobile_call": allowMobileCall,
        "distance": distance,
        "skills": List<dynamic>.from(skills!.map((x) => x.toJson())),
        "rating": rating,
        "reviews_count": reviewsCount,
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "gigs": List<dynamic>.from(gigs!.map((x) => x.toJson())),
      };
}

class Gig {
  Gig({
    required this.gigId,
    required this.gigTitle,
    required this.gigDetail,
    required this.gigPrice,
    required this.gigImages,
    required this.cityId,
    required this.status,
    required this.firstName,
    required this.gigSkills,
  });

  int? gigId;
  String? gigTitle;
  String? gigDetail;
  String? gigPrice;
  String? gigImages;
  int? cityId;
  int? status;
  String? firstName;
  List<GigSkill>? gigSkills;

  factory Gig.fromJson(Map<String, dynamic> json) => Gig(
        gigId: json["gig_id"],
        gigTitle: json["gig_title"],
        gigDetail: json["gig_detail"],
        gigPrice: json["gig_price"],
        gigImages: json["gig_images"] == null ? null : json["gig_images"],
        cityId: json["city_id"],
        status: json["status"],
        firstName: json["first_name"],
        gigSkills: List<GigSkill>.from(
            json["gig_skills"].map((x) => GigSkill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "gig_id": gigId,
        "gig_title": gigTitle,
        "gig_detail": gigDetail,
        "gig_price": gigPrice,
        "gig_images": gigImages == null ? null : gigImages,
        "city_id": cityId,
        "status": status,
        "first_name": firstName,
        "gig_skills": List<dynamic>.from(gigSkills!.map((x) => x.toJson())),
      };
}

class GigSkill {
  GigSkill({
    required this.skillId,
    required this.title,
  });

  int? skillId;
  String? title;

  factory GigSkill.fromJson(Map<String, dynamic> json) => GigSkill(
        skillId: json["skill_id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "skill_id": skillId,
        "title": title,
      };
}

class Review {
  Review({
    required this.skillId,
    required this.skillName,
    required this.rating,
    required this.detailedReviews,
  });

  int? skillId;
  String? skillName;
  String? rating;
  List<DetailedReview>? detailedReviews;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        skillId: json["skill_id"],
        skillName: json["skill_name"],
        rating: json["rating"],
        detailedReviews: List<DetailedReview>.from(
            json["detailed_reviews"].map((x) => DetailedReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "skill_id": skillId,
        "skill_name": skillName,
        "rating": rating,
        "detailed_reviews":
            List<dynamic>.from(detailedReviews!.map((x) => x.toJson())),
      };
}

class DetailedReview {
  DetailedReview({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.rating,
    required this.feedback,
    required this.reviewImages,
    required this.logo,
    required this.createdAt,
  });

  String? firstName;
  LastName? lastName;
  String? title;
  int? rating;
  String? feedback;
  String? reviewImages;
  String? logo;
  String? createdAt;

  factory DetailedReview.fromJson(Map<String, dynamic> json) => DetailedReview(
        firstName: json["first_name"],
        lastName: lastNameValues.map![json["last_name"]],
        title: json["title"],
        rating: json["rating"],
        feedback: json["feedback"],
        reviewImages:
            json["review_images"] == null ? null : json["review_images"],
        logo: json["logo"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastNameValues.reverse![lastName],
        "title": title,
        "rating": rating,
        "feedback": feedback,
        "review_images": reviewImages == null ? null : reviewImages,
        "logo": logo,
        "created_at": createdAt,
      };
}

enum LastName { EMPTY, LAST_NAME }

final lastNameValues =
    EnumValues({"*": LastName.EMPTY, "": LastName.LAST_NAME});

class Skill {
  Skill({
    required this.professionId,
    required this.skillId,
    required this.skillName,
  });

  int? professionId;
  int? skillId;
  String? skillName;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        professionId: json["profession_id"],
        skillId: json["skill_id"],
        skillName: json["skill_name"],
      );

  Map<String, dynamic> toJson() => {
        "profession_id": professionId,
        "skill_id": skillId,
        "skill_name": skillName,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
