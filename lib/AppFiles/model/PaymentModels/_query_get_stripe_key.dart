// To parse this JSON data, do
//
//     final queryGetStripeKey = queryGetStripeKeyFromJson(jsonString);

import 'dart:convert';

QueryGetStripeKey queryGetStripeKeyFromJson(String str) =>
    QueryGetStripeKey.fromJson(json.decode(str));

String queryGetStripeKeyToJson(QueryGetStripeKey data) =>
    json.encode(data.toJson());

class QueryGetStripeKey {
  QueryGetStripeKey({
    required this.currency,
    required this.items,
  });

  String currency;
  List<Item> items;

  factory QueryGetStripeKey.fromJson(Map<String, dynamic> json) =>
      QueryGetStripeKey(
        currency: json["currency"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.jobId,
    required this.amount,
  });

  String jobId;
  String amount;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        jobId: json["job_id"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "job_id": jobId,
        "amount": amount,
      };
}
