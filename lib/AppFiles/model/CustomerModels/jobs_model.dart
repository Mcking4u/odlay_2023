// To parse this JSON data, do
//
//     final jobsModel = jobsModelFromJson(jsonString);

import 'dart:convert';

JobsModel jobsModelFromJson(String str) => JobsModel.fromJson(json.decode(str));

String jobsModelToJson(JobsModel data) => json.encode(data.toJson());

class JobsModel {
  JobsModel({
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

  factory JobsModel.fromJson(Map<String, dynamic> json) => JobsModel(
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
    required this.firebaseUid,
    required this.deviceToken,
    // required this.createrTitle,
    required this.createrFirstName,
    required this.createrLastName,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.profilePicStatus,
    required this.id,
    required this.consumerId,
    required this.title,
    required this.jobgid,
    this.contactPerson,
    this.contactPhone,
    required this.detail,
    required this.deadline,
    required this.urgent,
    required this.gender,
    required this.distanceType,
    required this.status,
    required this.budget,
    required this.createdAt,
    this.jobLogo,
    required this.updatedAt,
    required this.jobImages,
    required this.address,
    required this.cityId,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.userLogo,
    required this.distance,
    required this.skillId,
    required this.count,
    required this.jobSequence,
  });

  String? firebaseUid;
  String? deviceToken;
  // CreaterTitle? createrTitle;
  String? createrFirstName;
  String? createrLastName;
  int? idCardStatus;
  int? addressProofStatus;
  int? profilePicStatus;
  int? id;
  int? consumerId;
  String? title;
  String jobgid;
  dynamic contactPerson;
  dynamic contactPhone;
  String? detail;
  DateTime? deadline;
  int? urgent;
  int? gender;
  int? distanceType;
  int? status;
  String? budget;
  DateTime createdAt;
  dynamic jobLogo;
  DateTime updatedAt;
  String? jobImages;
  String? address;
  int? cityId;
  dynamic postalCode;
  String? latitude;
  String? longitude;
  String? userLogo;
  double distance;
  List<int> skillId;
  int? count;
  int? jobSequence;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        // createrTitle: json["creater_title"] == null ? null : createrTitleValues.map[json["creater_title"]],
        createrFirstName: json["creater_first_name"],
        createrLastName: json["creater_last_name"] == null
            ? null
            : json["creater_last_name"],
        idCardStatus: json["id_card_status"],
        addressProofStatus: json["address_proof_status"],
        profilePicStatus: json["profile_pic_status"] == null
            ? null
            : json["profile_pic_status"],
        id: json["id"],
        consumerId: json["consumer_id"],
        title: json["title"],
        jobgid: json["jobgid"],
        contactPerson: json["contact_person"],
        contactPhone: json["contact_phone"],
        detail: json["detail"],
        deadline:
            json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        urgent: json["urgent"],
        gender: json["gender"],
        distanceType: json["distance_type"],
        status: json["status"],
        budget: json["budget"] == null ? null : json["budget"],
        createdAt: DateTime.parse(json["created_at"]),
        jobLogo: json["job_logo"],
        updatedAt: DateTime.parse(json["updated_at"]),
        jobImages: json["job_images"] == null ? null : json["job_images"],
        address: json["address"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        userLogo: json["user_logo"],
        distance: json["distance"].toDouble(),
        skillId: List<int>.from(json["skill_id"].map((x) => x)),
        count: json["count"],
        jobSequence: json["job_sequence"],
      );

  Map<String, dynamic> toJson() => {
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        // "creater_title": createrTitle == null ? null : createrTitleValues.reverse[createrTitle],
        "creater_first_name": createrFirstName,
        "creater_last_name": createrLastName == null ? null : createrLastName,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "profile_pic_status":
            profilePicStatus == null ? null : profilePicStatus,
        "id": id,
        "consumer_id": consumerId,
        "title": title,
        "jobgid": jobgid,
        "contact_person": contactPerson,
        "contact_phone": contactPhone,
        "detail": detail,
        "deadline": deadline == null ? null : deadline,
        "urgent": urgent,
        "gender": gender,
        "distance_type": distanceType,
        "status": status,
        "budget": budget == null ? null : budget,
        "created_at": createdAt.toIso8601String(),
        "job_logo": jobLogo,
        "updated_at": updatedAt.toIso8601String(),
        "job_images": jobImages == null ? null : jobImages,
        "address": address,
        "city_id": cityId,
        "postal_code": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "user_logo": userLogo,
        "distance": distance,
        "skill_id": List<dynamic>.from(skillId.map((x) => x)),
        "count": count,
        "job_sequence": jobSequence,
      };
}

// enum CreaterTitle { TAU_COMPANY, ARICRYPTA, EMPTY, TESTING_1 }

// final createrTitleValues = EnumValues({
//     "aricrypta": CreaterTitle.ARICRYPTA,
//     "": CreaterTitle.EMPTY,
//     "tau company": CreaterTitle.TAU_COMPANY,
//     "testing 1": CreaterTitle.TESTING_1
// });

// enum UserLogo { THE_1652182443_JPG, THE_1607598966_JPG, DEFAULT_PIC_PNG }

// final userLogoValues = EnumValues({
//     "default-pic.png": UserLogo.DEFAULT_PIC_PNG,
//     "1607598966.jpg": UserLogo.THE_1607598966_JPG,
//     "1652182443.jpg": UserLogo.THE_1652182443_JPG
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         if (reverseMap == null) {
//             reverseMap = map.map((k, v) => new MapEntry(v, k));
//         }
//         return reverseMap;
//     }
// }
