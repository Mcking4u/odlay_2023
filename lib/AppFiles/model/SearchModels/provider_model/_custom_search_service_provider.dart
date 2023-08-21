// To parse this JSON data, do
//
//     final responseCustomSearchServiceProvider = responseCustomSearchServiceProviderFromJson(jsonString);

import 'dart:convert';

ResponseCustomSearchServiceProvider responseCustomSearchServiceProviderFromJson(
        String str) =>
    ResponseCustomSearchServiceProvider.fromJson(json.decode(str));

String responseCustomSearchServiceProviderToJson(
        ResponseCustomSearchServiceProvider data) =>
    json.encode(data.toJson());

class ResponseCustomSearchServiceProvider {
  ResponseCustomSearchServiceProvider({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory ResponseCustomSearchServiceProvider.fromJson(
          Map<String, dynamic> json) =>
      ResponseCustomSearchServiceProvider(
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
    required this.address,
    required this.cityId,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.userLogo,
    required this.firebaseUid,
    required this.deviceToken,
    this.jobLogo,
  });

  int id;
  int consumerId;
  String title;
  String jobgid;
  String contactPerson;
  String contactPhone;
  String detail;
  String deadline;
  int urgent;
  int gender;
  int distanceType;
  int status;
  String budget;
  DateTime createdAt;
  DateTime updatedAt;
  String jobImages;
  String address;
  int cityId;
  dynamic postalCode;
  String latitude;
  String longitude;
  String userLogo;
  String firebaseUid;
  String deviceToken;
  dynamic jobLogo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        consumerId: json["consumer_id"],
        title: json["title"],
        jobgid: json["jobgid"],
        contactPerson:
            json["contact_person"] == null ? null : json["contact_person"],
        contactPhone:
            json["contact_phone"] == null ? null : json["contact_phone"],
        detail: json["detail"],
        deadline: json["deadline"] == null ? null : json["deadline"],
        urgent: json["urgent"],
        gender: json["gender"],
        distanceType: json["distance_type"],
        status: json["status"],
        budget: json["budget"] == null ? null : json["budget"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        jobImages: json["job_images"] == null ? null : json["job_images"],
        address: json["address"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        userLogo: json["user_logo"],
        firebaseUid: json["firebase_uid"] == null ? null : json["firebase_uid"],
        deviceToken: json["device_token"] == null ? null : json["device_token"],
        jobLogo: json["job_logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "consumer_id": consumerId,
        "title": title,
        "jobgid": jobgid,
        "contact_person": contactPerson == null ? null : contactPerson,
        "contact_phone": contactPhone == null ? null : contactPhone,
        "detail": detail,
        "deadline": deadline == null ? null : deadline,
        "urgent": urgent,
        "gender": gender,
        "distance_type": distanceType,
        "status": status,
        "budget": budget == null ? null : budget,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "job_images": jobImages == null ? null : jobImages,
        "address": address,
        "city_id": cityId,
        "postal_code": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "user_logo": userLogo,
        "firebase_uid": firebaseUid == null ? null : firebaseUid,
        "device_token": deviceToken == null ? null : deviceToken,
        "job_logo": jobLogo,
      };
}
