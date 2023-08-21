// To parse this JSON data, do
//
//     final topRatedServiceProviders = topRatedServiceProvidersFromJson(jsonString);

import 'dart:convert';

TopRatedServiceProviders topRatedServiceProvidersFromJson(String str) =>
    TopRatedServiceProviders.fromJson(json.decode(str));

String topRatedServiceProvidersToJson(TopRatedServiceProviders data) =>
    json.encode(data.toJson());

class TopRatedServiceProviders {
  TopRatedServiceProviders({
    required this.serviceproviders,
    required this.gigs,
  });

  Gigs serviceproviders;
  Gigs gigs;

  factory TopRatedServiceProviders.fromJson(Map<String, dynamic> json) =>
      TopRatedServiceProviders(
        serviceproviders: Gigs.fromJson(json["serviceproviders"]),
        gigs: Gigs.fromJson(json["gigs"]),
      );

  Map<String, dynamic> toJson() => {
        "serviceproviders": serviceproviders.toJson(),
        "gigs": gigs.toJson(),
      };
}

class Gigs {
  Gigs({
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
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory Gigs.fromJson(Map<String, dynamic> json) => Gigs(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl:
            json["next_page_url"] == null ? null : json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from == null ? null : from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl == null ? null : nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
        "total": total,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.firebaseUid,
    required this.deviceToken,
    required this.serviceId,
    required this.address,
    required this.cityId,
    this.postalCode,
    required this.streetNo,
    required this.latitude,
    required this.longitude,
    required this.defaultView,
    required this.title,
    required this.companyId,
    this.dob,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.appliedtojob,
    required this.logo,
    required this.phone,
    required this.roleId,
    required this.status,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.profilePicStatus,
    this.objective,
    this.profession,
    required this.portfolioImages,
    required this.allowMobileCall,
    required this.rating,
    required this.distance,
    this.skills,
    required this.reviewsCount,
    this.reviews,
    this.gigs,
    required this.spcount,
  });

  int? id;
  String? firebaseUid;
  String? deviceToken;
  int? serviceId;
  String? address;
  int? cityId;
  dynamic postalCode;
  String? streetNo;
  String? latitude;
  String? longitude;
  String? defaultView;
  String? title;
  int? companyId;
  dynamic dob;
  String? email;
  String? firstName;
  String? lastName;
  int? appliedtojob;
  String? logo;
  String? phone;
  int? roleId;
  int? status;
  int? idCardStatus;
  int? addressProofStatus;
  int? profilePicStatus;
  dynamic objective;
  dynamic profession;
  String? portfolioImages;
  int? allowMobileCall;
  String? rating;
  double? distance;
  List<Skill>? skills;
  int? reviewsCount;
  List<dynamic>? reviews;
  List<Gig>? gigs;
  int? spcount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        serviceId: json["service_id"],
        address: json["address"] == null ? null : json["address"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        streetNo: json["street_no"] == null ? null : json["street_no"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        defaultView: json["default_view"],
        title: json["title"] == null ? null : json["title"],
        companyId: json["company_id"],
        dob: json["dob"],
        email: json["email"],
        firstName: json["first_name"],
        appliedtojob: json["appliedtojob"],
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
        objective: json["objective"],
        profession: json["profession"],
        portfolioImages:
            json["portfolio_images"] == null ? null : json["portfolio_images"],
        allowMobileCall: json["allow_mobile_call"],
        rating: json["rating"] == null ? null : json["rating"],
        distance: json["distance"].toDouble(),
        skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        reviewsCount: json["reviews_count"],
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
        gigs: List<Gig>.from(json["gigs"].map((x) => Gig.fromJson(x))),
        spcount: json["spcount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        "service_id": serviceId,
        "address": address == null ? null : address,
        "city_id": cityId,
        "postal_code": postalCode,
        "street_no": streetNo == null ? null : streetNo,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "default_view": defaultViewValues.reverse![defaultView],
        "title": title == null ? null : title,
        "company_id": companyId,
        "dob": dob,
        "email": email,
        "first_name": firstName,
        "appliedtojob": appliedtojob,
        "last_name": lastName == null ? null : lastName,
        "logo": logo,
        "phone": phone,
        "role_id": roleId,
        "status": status,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "profile_pic_status":
            profilePicStatus == null ? null : profilePicStatus,
        "objective": objective,
        "profession": profession,
        "portfolio_images": portfolioImages == null ? null : portfolioImages,
        "allow_mobile_call": allowMobileCall,
        "rating": rating == null ? null : rating,
        "distance": distance,
        "skills": List<dynamic>.from(skills!.map((x) => x)),
        "reviews_count": reviewsCount,
        "reviews": List<dynamic>.from(reviews!.map((x) => x)),
        "gigs": List<dynamic>.from(gigs!.map((x) => x.toJson())),
        "spcount": spcount,
      };
}

enum DefaultView { CONSUMER }

final defaultViewValues = EnumValues({"consumer": DefaultView.CONSUMER});

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
  int? gigPrice;
  String? gigImages;
  int? cityId;
  int? status;
  String? firstName;
  List<dynamic> gigSkills;

  factory Gig.fromJson(Map<String, dynamic> json) => Gig(
        gigId: json["gig_id"],
        gigTitle: json["gig_title"],
        gigDetail: json["gig_detail"],
        gigPrice: json["gig_price"],
        gigImages: json["gig_images"] == null ? null : json["gig_images"],
        cityId: json["city_id"],
        status: json["status"],
        firstName: json["first_name"],
        gigSkills: List<dynamic>.from(json["gig_skills"].map((x) => x)),
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
        "gig_skills": List<dynamic>.from(gigSkills.map((x) => x)),
      };
}

class Skill {
  Skill({
    required this.skillId,
    required this.skillName,
  });

  int? skillId;
  String? skillName;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        skillId: json["skill_id"],
        skillName: json["skill_name"],
      );

  Map<String, dynamic> toJson() => {
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
