// To parse this JSON data, do
//
//     final responsePostReview = responsePostReviewFromJson(jsonString);

import 'dart:convert';

ResponsePostReview responsePostReviewFromJson(String str) =>
    ResponsePostReview.fromJson(json.decode(str));

String responsePostReviewToJson(ResponsePostReview data) =>
    json.encode(data.toJson());

class ResponsePostReview {
  ResponsePostReview({
    required this.status,
    required this.message,
    required this.reviewId,
  });

  String status;
  String message;
  int reviewId;

  factory ResponsePostReview.fromJson(Map<String, dynamic> json) =>
      ResponsePostReview(
        status: json["status"],
        message: json["message"],
        reviewId: json["review_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "review_id": reviewId,
      };
}
