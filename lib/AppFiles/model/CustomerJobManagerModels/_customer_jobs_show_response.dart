// To parse this JSON data, do
//
//     final responseCustomersShowJobs = responseCustomersShowJobsFromJson(jsonString);

import 'dart:convert';

List<ResponseCustomersShowJobs> responseCustomersShowJobsFromJson(String str) =>
    List<ResponseCustomersShowJobs>.from(
        json.decode(str).map((x) => ResponseCustomersShowJobs.fromJson(x)));

String responseCustomersShowJobsToJson(List<ResponseCustomersShowJobs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseCustomersShowJobs {
  ResponseCustomersShowJobs({
    required this.firebaseUid,
    required this.deviceToken,
    required this.createrTitle,
    required this.createrFirstName,
    required this.createrLastName,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.profilePicStatus,
    required this.language,
    required this.id,
    required this.consumerId,
    required this.title,
    required this.jobgid,
    required this.contactPerson,
    required this.contactPhone,
    required this.detail,
    required this.deadline,
    required this.urgent,
    required this.gender,
    required this.distanceType,
    required this.status,
    required this.budget,
    required this.createdAt,
    required this.updatedAt,
    required this.jobImages,
    required this.paymentMethod,
    required this.paymentDate,
    required this.transactionId,
    required this.taxAmount,
    required this.address,
    required this.cityId,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.skillId,
    required this.jobApplicants,
  });

  FirebaseUid? firebaseUid;
  String? deviceToken;
  String? createrTitle;
  String? createrFirstName;
  String? createrLastName;
  int? idCardStatus;
  int? addressProofStatus;
  int? profilePicStatus;
  int? language;
  int? id;
  int? consumerId;
  String? title;
  String? jobgid;
  String? contactPerson;
  String? contactPhone;
  String? detail;
  String? deadline;
  int? urgent;
  int? gender;
  int? distanceType;
  int? status;
  String? budget;
  String? createdAt;
  String? updatedAt;
  String? jobImages;
  int? paymentMethod;
  String? paymentDate;
  String? transactionId;
  dynamic taxAmount;
  String? address;
  int? cityId;
  dynamic postalCode;
  String? latitude;
  String? longitude;
  List<int>? skillId;
  List<JobApplicant>? jobApplicants;

  factory ResponseCustomersShowJobs.fromJson(Map<String, dynamic> json) =>
      ResponseCustomersShowJobs(
        firebaseUid: firebaseUidValues.map[json["firebase_uid"]],
        deviceToken: json["device_token"],
        createrTitle: json["creater_title"],
        createrFirstName: json["creater_first_name"],
        createrLastName: json["creater_last_name"],
        idCardStatus: json["id_card_status"],
        addressProofStatus: json["address_proof_status"],
        profilePicStatus: json["profile_pic_status"],
        language: json["language"],
        id: json["id"],
        consumerId: json["consumer_id"],
        title: json["title"],
        jobgid: json["jobgid"],
        contactPerson: json["contact_person"],
        contactPhone: json["contact_phone"],
        detail: json["detail"],
        deadline: json["deadline"],
        urgent: json["urgent"],
        gender: json["gender"],
        distanceType: json["distance_type"],
        status: json["status"],
        budget: json["budget"] == null ? null : json["budget"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        jobImages: json["job_images"],
        paymentMethod:
            json["payment_method"] == null ? null : json["payment_method"],
        paymentDate: json["payment_date"] == null ? null : json["payment_date"],
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        taxAmount: json["tax_amount"],
        address: json["address"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        skillId: List<int>.from(json["skill_id"].map((x) => x)),
        jobApplicants: List<JobApplicant>.from(
            json["job_applicants"].map((x) => JobApplicant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "firebase_uid": firebaseUidValues.reverse![firebaseUid],
        "device_token": deviceToken,
        "creater_title": createrTitle,
        "creater_first_name": firstNameValues.reverse![createrFirstName],
        "creater_last_name": createrLastName,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "profile_pic_status": profilePicStatus,
        "language": language,
        "id": id,
        "consumer_id": consumerId,
        "title": title,
        "jobgid": jobgid,
        "contact_person": contactPerson,
        "contact_phone": contactPhone,
        "detail": detail,
        "deadline": deadline,
        "urgent": urgent,
        "gender": gender,
        "distance_type": distanceType,
        "status": status,
        "budget": budget == null ? null : budget,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "job_images": jobImages,
        "payment_method": paymentMethod == null ? null : paymentMethod,
        "payment_date": paymentDate == null ? null : paymentDate,
        "transaction_id": transactionId == null ? null : transactionId,
        "tax_amount": taxAmount,
        "address": address,
        "city_id": cityId,
        "postal_code": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "skill_id": List<dynamic>.from(skillId!.map((x) => x)),
        "job_applicants":
            List<dynamic>.from(jobApplicants!.map((x) => x.toJson())),
      };
}

enum FirstName {
  ODLAY_SERVICES,
  NIAZ_JIHANGIR_SHAH,
  ARIF,
  BANDIAL_VHORR,
  SYED_TAUSIF_UR_REHMAN,
  NIAZ_JIHANGIR
}

final firstNameValues = EnumValues({
  "arif": FirstName.ARIF,
  "Bandial Vhorr": FirstName.BANDIAL_VHORR,
  "Niaz Jihangir": FirstName.NIAZ_JIHANGIR,
  "Niaz Jihangir shah": FirstName.NIAZ_JIHANGIR_SHAH,
  "Odlay Services": FirstName.ODLAY_SERVICES,
  "Syed Tausif Ur rehman": FirstName.SYED_TAUSIF_UR_REHMAN
});

enum FirebaseUid { M_ZG_FZ_UDH_ZK_T4_YU_OE0_Q_R8_K_SO_PM_QG1 }

final firebaseUidValues = EnumValues({
  "mZgFzUDHZkT4yuOE0qR8kSoPMQg1":
      FirebaseUid.M_ZG_FZ_UDH_ZK_T4_YU_OE0_Q_R8_K_SO_PM_QG1
});

class JobApplicant {
  JobApplicant({
    required this.budgetAmount,
    required this.odlayFee,
    required this.totalCharged,
    required this.custOdlayFee,
    required this.bidAmount,
    required this.spReceivableAmount,
    required this.spOdlayFee,
    required this.budgetOption,
    required this.duration,
    required this.userId,
    required this.id,
    required this.jobId,
    required this.userstatus,
    required this.sp_job_status,
    required this.proposalDesc,
    required this.firebaseUid,
    required this.deviceToken,
    required this.serviceId,
    required this.address,
    required this.cityId,
    required this.postalCode,
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
    required this.logo,
    required this.phone,
    required this.roleId,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.profilePicStatus,
    required this.objective,
    required this.profession,
    required this.portfolioImages,
    required this.allowMobileCall,
    required this.rating,
    required this.distance,
    required this.skills,
    required this.reviewsCount,
    required this.reviews,
    required this.gigs,
    required this.spcount,
  });

  dynamic budgetAmount;
  String? odlayFee;
  String? totalCharged;
  String? custOdlayFee;
  String? bidAmount;
  String? spReceivableAmount;
  String? spOdlayFee;
  String? budgetOption;
  int? duration;
  int? userId;
  int? id;
  int? jobId;
  int? userstatus;
  int? sp_job_status;
  String? proposalDesc;
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
  String? logo;
  String? phone;
  int? roleId;
  int? idCardStatus;
  int? addressProofStatus;
  int? profilePicStatus;
  dynamic objective;
  dynamic profession;
  String? portfolioImages;
  int? allowMobileCall;
  String? rating;
  double? distance;
  List<ApplicantSkill>? skills;
  int? reviewsCount;
  List<Review>? reviews;
  List<Gig>? gigs;
  int? spcount;

  factory JobApplicant.fromJson(Map<String, dynamic> json) => JobApplicant(
        budgetAmount: json["budget_amount"],
        odlayFee: json["odlay_fee"] == null ? null : json["odlay_fee"],
        totalCharged:
            json["total_charged"] == null ? null : json["total_charged"],
        custOdlayFee:
            json["cust_odlay_fee"] == null ? null : json["cust_odlay_fee"],
        bidAmount: json["bid_amount"] == null ? null : json["bid_amount"],
        spReceivableAmount: json["sp_receivable_amount"] == null
            ? null
            : json["sp_receivable_amount"],
        spOdlayFee: json["sp_odlay_fee"] == null ? null : json["sp_odlay_fee"],
        budgetOption:
            json["budget_option"] == null ? null : json["budget_option"],
        duration: json["duration"],
        userId: json["user_id"],
        id: json["id"],
        jobId: json["job_id"],
        userstatus: json["user_status"],
        sp_job_status: json["sp_job_status"],
        proposalDesc:
            json["proposal_desc"] == null ? null : json["proposal_desc"],
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"] == null ? null : json["device_token"],
        serviceId: json["service_id"],
        address: json["address"] == null ? null : json["address"],
        cityId: json["city_id"] == null ? null : json["city_id"],
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
        lastName: json["last_name"] == null ? null : json["last_name"],
        logo: json["logo"],
        phone: json["phone"],
        roleId: json["role_id"],
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
        skills: List<ApplicantSkill>.from(
            json["skills"].map((x) => ApplicantSkill.fromJson(x))),
        reviewsCount: json["reviews_count"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        gigs: List<Gig>.from(json["gigs"].map((x) => Gig.fromJson(x))),
        spcount: json["spcount"],
      );

  Map<String, dynamic> toJson() => {
        "budget_amount": budgetAmount,
        "odlay_fee": odlayFee == null ? null : odlayFee,
        "total_charged": totalCharged == null ? null : totalCharged,
        "cust_odlay_fee": custOdlayFee == null ? null : custOdlayFee,
        "bid_amount": bidAmount == null ? null : bidAmount,
        "sp_receivable_amount":
            spReceivableAmount == null ? null : spReceivableAmount,
        "sp_odlay_fee": spOdlayFee == null ? null : spOdlayFee,
        "budget_option": budgetOption == null
            ? null
            : budgetOptionValues.reverse![budgetOption],
        "duration": duration,
        "user_id": userId,
        "id": id,
        "job_id": jobId,
        "user_status": userstatus,
        "sp_job_status": sp_job_status,
        "proposal_desc": proposalDesc == null ? null : proposalDesc,
        "firebase_uid": firebaseUid,
        "device_token": deviceToken == null ? null : deviceToken,
        "service_id": serviceId,
        "address": address == null ? null : address,
        "city_id": cityId == null ? null : cityId,
        "postal_code": postalCode,
        "street_no": streetNo == null ? null : streetNo,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "default_view": defaultViewValues.reverse![defaultView],
        "title": title == null ? null : title,
        "company_id": companyId,
        "dob": dob,
        "email": email,
        "first_name": firstNameValues.reverse![firstName],
        "last_name": lastName == null ? null : lastName,
        "logo": logo,
        "phone": phone,
        "role_id": roleId,
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
        "skills": List<dynamic>.from(skills!.map((x) => x.toJson())),
        "reviews_count": reviewsCount,
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "gigs": List<dynamic>.from(gigs!.map((x) => x.toJson())),
        "spcount": spcount,
      };
}

enum BudgetOption { FIXED }

final budgetOptionValues = EnumValues({"Fixed": BudgetOption.FIXED});

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
  List<GigSkill>? gigSkills;

  factory Gig.fromJson(Map<String, dynamic> json) => Gig(
        gigId: json["gig_id"],
        gigTitle: json["gig_title"],
        gigDetail: json["gig_detail"] == null ? null : json["gig_detail"],
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
        "gig_detail": gigDetail == null ? null : gigDetail,
        "gig_price": gigPrice,
        "gig_images": gigImages == null ? null : gigImages,
        "city_id": cityId,
        "status": status,
        "first_name": firstNameValues.reverse![firstName],
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
        "skill_name": skillNameValues.reverse![skillName],
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
  dynamic lastName;
  String? title;
  int? rating;
  String? feedback;
  String? reviewImages;
  String? logo;
  String? createdAt;

  factory DetailedReview.fromJson(Map<String, dynamic> json) => DetailedReview(
        firstName: json["first_name"],
        lastName: json["last_name"],
        title: json["title"],
        rating: json["rating"],
        feedback: json["feedback"],
        reviewImages: json["review_images"],
        logo: json["logo"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstNameValues.reverse![firstName],
        "last_name": lastName,
        "title": titleValues.reverse![title],
        "rating": rating,
        "feedback": feedbackValues.reverse![feedback],
        "review_images": reviewImages,
        "logo": logoValues.reverse![logo],
        "created_at": createdAt,
      };
}

enum Feedback { GREAT_JOB_THANSKS_WORKING }

final feedbackValues = EnumValues(
    {"Great Job Thansks Working": Feedback.GREAT_JOB_THANSKS_WORKING});

enum Logo { DEFAULT_PIC_PNG }

final logoValues = EnumValues({"default-pic.png": Logo.DEFAULT_PIC_PNG});

enum Title { GHHHHH }

final titleValues = EnumValues({"ghhhhh": Title.GHHHHH});

enum SkillName { ELECTRIC_FITTING }

final skillNameValues =
    EnumValues({"Electric Fitting": SkillName.ELECTRIC_FITTING});

class ApplicantSkill {
  ApplicantSkill({
    required this.skillId,
    required this.skillName,
  });

  int? skillId;
  String? skillName;

  factory ApplicantSkill.fromJson(Map<String, dynamic> json) => ApplicantSkill(
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
