// To parse this JSON data, do
//
//     final querypostReview = querypostReviewFromJson(jsonString);

import 'dart:convert';

QuerypostReview querypostReviewFromJson(String str) =>
    QuerypostReview.fromJson(json.decode(str));

String querypostReviewToJson(QuerypostReview data) =>
    json.encode(data.toJson());

class QuerypostReview {
  QuerypostReview({
    required this.rating,
    required this.feedback,
    required this.consumerId,
    required this.serviceId,
    required this.jobId,
    required this.skills,
  });

  String rating;
  String feedback;
  String consumerId;
  String serviceId;
  String jobId;
  List<int?> skills;

  factory QuerypostReview.fromJson(Map<String, dynamic> json) =>
      QuerypostReview(
        rating: json["rating"],
        feedback: json["feedback"],
        consumerId: json["consumer_id"],
        serviceId: json["service_id"],
        jobId: json["job_id"],
        skills: List<int>.from(json["skills"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "feedback": feedback,
        "consumer_id": consumerId,
        "service_id": serviceId,
        "job_id": jobId,
        "skills": List<dynamic>.from(skills.map((x) => x)),
      };
}
