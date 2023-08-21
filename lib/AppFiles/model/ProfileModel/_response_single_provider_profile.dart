// To parse this JSON data, do
//
//     final resposneServiceProviderProfile = resposneServiceProviderProfileFromJson(jsonString);

import 'dart:convert';

ResposneServiceProviderProfile resposneServiceProviderProfileFromJson(
        String str) =>
    ResposneServiceProviderProfile.fromJson(json.decode(str));

String resposneServiceProviderProfileToJson(
        ResposneServiceProviderProfile data) =>
    json.encode(data.toJson());

class ResposneServiceProviderProfile {
  ResposneServiceProviderProfile({
    required this.serviceId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    required this.postalCode,
    required this.streetNo,
    required this.id,
    required this.defaultView,
    required this.companyId,
    required this.dob,
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
  dynamic postalCode;
  String? streetNo;
  int? id;
  String? defaultView;
  int? companyId;
  dynamic dob;
  String? email;
  String? title;
  String? firstName;
  String? lastName;
  String? logo;
  int idCardStatus;
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
  List<MySkill>? skills;
  String? rating;
  int? reviewsCount;
  List<Review>? reviews;
  List<SpGig>? gigs;

  factory ResposneServiceProviderProfile.fromJson(Map<String, dynamic> json) =>
      ResposneServiceProviderProfile(
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
        skills:
            List<MySkill>.from(json["skills"].map((x) => MySkill.fromJson(x))),
        rating: json["rating"],
        reviewsCount: json["reviews_count"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        gigs: List<SpGig>.from(json["gigs"].map((x) => SpGig.fromJson(x))),
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
        "first_name": firstNameValues.reverse![firstName],
        "last_name": lastName,
        "logo": logoValues.reverse![logo],
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

enum FirstName { ARIF_SHAH, AARIZ_1, JAMAL_MEHBOOB }

final firstNameValues = EnumValues({
  "Aariz 1": FirstName.AARIZ_1,
  "Arif Shah": FirstName.ARIF_SHAH,
  "Jamal Mehboob": FirstName.JAMAL_MEHBOOB
});

class SpGig {
  SpGig({
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
  int? gigPrice;
  String? gigImages;
  int? cityId;
  int? status;
  String? firstName;
  List<GigSkills>? gigSkills;

  factory SpGig.fromJson(Map<String, dynamic> json) => SpGig(
        gigId: json["gig_id"],
        gigTitle: json["gig_title"],
        gigDetail: json["gig_detail"],
        gigPrice: json["gig_price"],
        gigImages: json["gig_images"] == null ? null : json["gig_images"],
        cityId: json["city_id"],
        status: json["status"],
        firstName: json["first_name"],
        gigSkills: List<GigSkills>.from(
            json["gig_skills"].map((x) => GigSkills.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "gig_id": gigId,
        "gig_title": gigTitle,
        "gig_detail": gigDetail,
        "gig_price": gigPrice,
        "gig_images": gigImages == null ? null : gigImages,
        "city_id": cityId,
        "status": status,
        "first_name": firstNameValues.reverse![firstName],
        "gig_skills": List<dynamic>.from(gigSkills!.map((x) => x.toJson())),
      };
}

class GigSkills {
  GigSkills({
    required this.skillId,
    required this.title,
    required this.gid,
  });

  int? skillId;
  String? title;
  String? gid;

  factory GigSkills.fromJson(Map<String, dynamic> json) => GigSkills(
        skillId: json["skill_id"],
        title: json["title"],
        gid: json["gid"],
      );

  Map<String, dynamic> toJson() => {
        "skill_id": skillId,
        "title": title,
        "gid": gid,
      };
}

enum Logo { THE_1642207880_JPG, THE_1605430625_JPG, DEFAULT_PIC_PNG }

final logoValues = EnumValues({
  "default-pic.png": Logo.DEFAULT_PIC_PNG,
  "1605430625.jpg": Logo.THE_1605430625_JPG,
  "1642207880.jpg": Logo.THE_1642207880_JPG
});

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
  List<DetailedReviewUser>? detailedReviews;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        skillId: json["skill_id"],
        skillName: json["skill_name"],
        rating: json["rating"],
        detailedReviews: List<DetailedReviewUser>.from(json["detailed_reviews"]
            .map((x) => DetailedReviewUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "skill_id": skillId,
        "skill_name": skillName,
        "rating": rating,
        "detailed_reviews":
            List<dynamic>.from(detailedReviews!.map((x) => x.toJson())),
      };
}

class DetailedReviewUser {
  DetailedReviewUser({
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
  String? lastName;
  String? title;
  int? rating;
  String? feedback;
  String? reviewImages;
  String? logo;
  DateTime createdAt;

  factory DetailedReviewUser.fromJson(Map<String, dynamic> json) =>
      DetailedReviewUser(
        firstName: json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        title: json["title"],
        rating: json["rating"],
        feedback: json["feedback"],
        reviewImages:
            json["review_images"] == null ? null : json["review_images"],
        logo: json["logo"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstNameValues.reverse![firstName],
        "last_name": lastName == null ? null : lastName,
        "title": title,
        "rating": rating,
        "feedback": feedback,
        "review_images": reviewImages == null ? null : reviewImages,
        "logo": logoValues.reverse![logo],
        "created_at": createdAt.toIso8601String(),
      };
}

class MySkill {
  MySkill({
    required this.professionId,
    required this.skillId,
    required this.skillName,
  });

  int? professionId;
  int? skillId;
  String? skillName;

  factory MySkill.fromJson(Map<String, dynamic> json) => MySkill(
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
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
