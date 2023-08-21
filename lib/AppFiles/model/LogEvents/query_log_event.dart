// To parse this JSON data, do
//
//     final queryLogEvent = queryLogEventFromJson(jsonString);

import 'dart:convert';

QueryLogEvent queryLogEventFromJson(String str) => QueryLogEvent.fromJson(json.decode(str));

String queryLogEventToJson(QueryLogEvent data) => json.encode(data.toJson());

class QueryLogEvent {
  String? userId;
  String? eventName;
  int? activityId;

  QueryLogEvent({
    required this.userId,
    required this.eventName,
    required this.activityId,
  });

  factory QueryLogEvent.fromJson(Map<String, dynamic> json) => QueryLogEvent(
    userId: json["user_id"],
    eventName: json["event_name"],
    activityId: json["activity_id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "event_name": eventName,
    "activity_id": activityId,
  };
}
