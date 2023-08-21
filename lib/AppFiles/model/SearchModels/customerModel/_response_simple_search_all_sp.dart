// To parse this JSON data, do
//
//     final responseSearchAllServiceProviders = responseSearchAllServiceProvidersFromJson(jsonString);

import 'dart:convert';

import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';

ResponseSearchAllServiceProviders responseSearchAllServiceProvidersFromJson(
        String str) =>
    ResponseSearchAllServiceProviders.fromJson(json.decode(str));

String responseSearchAllServiceProvidersToJson(
        ResponseSearchAllServiceProviders data) =>
    json.encode(data.toJson());

class ResponseSearchAllServiceProviders {
  ResponseSearchAllServiceProviders({
    required this.serviceproviders,
    required this.gigs,
  });

  SearchServiceproviders serviceproviders;
  SearchedGigs gigs;

  factory ResponseSearchAllServiceProviders.fromJson(
          Map<String, dynamic> json) =>
      ResponseSearchAllServiceProviders(
        serviceproviders:
            SearchServiceproviders.fromJson(json["serviceproviders"]),
        gigs: SearchedGigs.fromJson(json["gigs"]),
      );

  Map<String, dynamic> toJson() => {
        "serviceproviders": serviceproviders.toJson(),
        "gigs": gigs.toJson(),
      };
}

class SearchedGigs {
  SearchedGigs({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int? currentPage;
  List<GigsDatum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  factory SearchedGigs.fromJson(Map<String, dynamic> json) => SearchedGigs(
        currentPage: json["current_page"],
        data: List<GigsDatum>.from(
            json["data"].map((x) => GigsDatum.fromJson(x))),
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
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
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

class GigsDatum {
  GigsDatum({
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

  factory GigsDatum.fromJson(Map<String, dynamic> json) => GigsDatum(
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

// class Skill {
//   Skill({
//     required this.skillId,
//     required this.skillName,
//   });

//   int skillId;
//   String skillName;

//   factory Skill.fromJson(Map<String, dynamic> json) => Skill(
//         skillId: json["skill_id"],
//         skillName: json["skill_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "skill_id": skillId,
//         "skill_name": skillName,
//       };
// }

class SearchServiceproviders {
  SearchServiceproviders({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int? currentPage;
  List<ServiceprovidersDatum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  factory SearchServiceproviders.fromJson(Map<String, dynamic> json) =>
      SearchServiceproviders(
        currentPage: json["current_page"],
        data: List<ServiceprovidersDatum>.from(
            json["data"].map((x) => ServiceprovidersDatum.fromJson(x))),
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

class ServiceprovidersDatum {
  ServiceprovidersDatum({
    required this.serviceId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    required this.postalCode,
    required this.streetNo,
    required this.id,
    required this.defaultView,
    required this.title,
    required this.companyId,
    required this.dob,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.logo,
    required this.phone,
    required this.roleId,
    required this.rating,
    required this.status,
    required this.firebaseUid,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.profilePicStatus,
    required this.deviceToken,
    this.objective,
    required this.portfolioImages,
    required this.allowMobileCall,
    this.profession,
    required this.distance,
    required this.skills,
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
  String? title;
  int? companyId;
  dynamic dob;
  String? email;
  String? firstName;
  String? lastName;
  String? logo;
  String? phone;
  int? roleId;
  int? rating;
  int? status;
  String? firebaseUid;
  int? idCardStatus;
  int? addressProofStatus;
  int? profilePicStatus;
  String? deviceToken;
  dynamic objective;
  String? portfolioImages;
  int? allowMobileCall;
  dynamic profession;
  double? distance;
  List<Skill>? skills;
  List<Review>? reviews;
  List<Gig>? gigs;

  factory ServiceprovidersDatum.fromJson(Map<String, dynamic> json) =>
      ServiceprovidersDatum(
        serviceId: json["service_id"],
        address: json["address"] == null ? null : json["address"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        streetNo: json["street_no"] == null ? null : json["street_no"],
        id: json["id"],
        defaultView: json["default_view"],
        title: json["title"] == null ? null : json["title"],
        companyId: json["company_id"],
        dob: json["dob"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        logo: json["logo"],
        phone: json["phone"],
        roleId: json["role_id"],
        rating: json["rating"] == null ? null : json["rating"],
        status: json["status"],
        firebaseUid: json["firebase_uid"],
        idCardStatus: json["id_card_status"],
        addressProofStatus: json["address_proof_status"],
        profilePicStatus: json["profile_pic_status"] == null
            ? null
            : json["profile_pic_status"],
        deviceToken: json["device_token"] == null ? null : json["device_token"],
        objective: json["objective"],
        portfolioImages:
            json["portfolio_images"] == null ? null : json["portfolio_images"],
        allowMobileCall: json["allow_mobile_call"] == null
            ? null
            : json["allow_mobile_call"],
        profession: json["profession"],
        distance: json["distance"].toDouble(),
        skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        gigs: List<Gig>.from(json["gigs"].map((x) => Gig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "address": address == null ? null : address,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "city_id": cityId,
        "postal_code": postalCode,
        "street_no": streetNo == null ? null : streetNo,
        "id": id,
        "default_view": defaultViewValues.reverse![defaultView],
        "title": title == null ? null : title,
        "company_id": companyId,
        "dob": dob,
        "email": email,
        "first_name": firstName,
        "last_name": lastName == null ? null : lastName,
        "logo": logo,
        "phone": phone,
        "role_id": roleId,
        "rating": rating == null ? null : rating,
        "status": status,
        "firebase_uid": firebaseUid,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "profile_pic_status":
            profilePicStatus == null ? null : profilePicStatus,
        "device_token": deviceToken == null ? null : deviceToken,
        "objective": objective,
        "portfolio_images": portfolioImages == null ? null : portfolioImages,
        "allow_mobile_call": allowMobileCall == null ? null : allowMobileCall,
        "profession": profession,
        "distance": distance,
        "skills": List<dynamic>.from(skills!.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "gigs": List<dynamic>.from(gigs!.map((x) => x.toJson())),
      };
}

enum DefaultView { CONSUMER }

final defaultViewValues = EnumValues({"consumer": DefaultView.CONSUMER});

// class Gig {
//   Gig({
//     required this.gigId,
//     required this.gigTitle,
//     required this.gigDetail,
//     required this.gigPrice,
//     required this.gigImages,
//     required this.cityId,
//     required this.status,
//     required this.firstName,
//     required this.gigSkills,
//   });

//   int? gigId;
//   String? gigTitle;
//   String? gigDetail;
//   int? gigPrice;
//   String? gigImages;
//   int? cityId;
//   int? status;
//   String? firstName;
//   List<GigSkill>? gigSkills;

//   factory Gig.fromJson(Map<String, dynamic> json) => Gig(
//         gigId: json["gig_id"],
//         gigTitle: json["gig_title"],
//         gigDetail: json["gig_detail"] == null ? null : json["gig_detail"],
//         gigPrice: json["gig_price"],
//         gigImages: json["gig_images"] == null ? null : json["gig_images"],
//         cityId: json["city_id"],
//         status: json["status"],
//         firstName: json["first_name"],
//         gigSkills: List<GigSkill>.from(
//             json["gig_skills"].map((x) => GigSkill.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "gig_id": gigId,
//         "gig_title": gigTitle,
//         "gig_detail": gigDetail == null ? null : gigDetail,
//         "gig_price": gigPrice,
//         "gig_images": gigImages == null ? null : gigImages,
//         "city_id": cityId,
//         "status": status,
//         "first_name": firstName,
//         "gig_skills": List<dynamic>.from(gigSkills!.map((x) => x.toJson())),
//       };
// }

class GigSkill {
  GigSkill({
    required this.skillId,
    required this.title,
  });

  int skillId;
  String title;

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

  int skillId;
  String skillName;
  String rating;
  List<DetailedReview> detailedReviews;

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
            List<dynamic>.from(detailedReviews.map((x) => x.toJson())),
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
  String? lastName;
  String title;
  int? rating;
  String? feedback;
  String? reviewImages;
  String? logo;
  String createdAt;

  factory DetailedReview.fromJson(Map<String, dynamic> json) => DetailedReview(
        firstName: json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
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
        "last_name": lastName == null ? null : lastName,
        "title": title,
        "rating": rating,
        "feedback": feedback,
        "review_images": reviewImages == null ? null : reviewImages,
        "logo": logo,
        "created_at": createdAt,
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
