// To parse this JSON data, do
//
//     final responseGetStripeKey = responseGetStripeKeyFromJson(jsonString);

import 'dart:convert';

ResponseGetStripeKey responseGetStripeKeyFromJson(String str) =>
    ResponseGetStripeKey.fromJson(json.decode(str));

String responseGetStripeKeyToJson(ResponseGetStripeKey data) =>
    json.encode(data.toJson());

class ResponseGetStripeKey {
  ResponseGetStripeKey({
    required this.status,
    required this.sintent,
    required this.skey,
    required this.transId,
  });

  String status;
  String sintent;
  String skey;
  String transId;

  factory ResponseGetStripeKey.fromJson(Map<String, dynamic> json) =>
      ResponseGetStripeKey(
        status: json["status"],
        sintent: json["Sintent"],
        skey: json["Skey"],
        transId: json["trans_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Sintent": sintent,
        "Skey": skey,
        "trans_id": transId,
      };
}
