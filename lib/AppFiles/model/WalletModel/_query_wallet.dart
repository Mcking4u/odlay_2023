// To parse this JSON data, do
//
//     final queryWallet = queryWalletFromJson(jsonString);

import 'dart:convert';

QueryWallet queryWalletFromJson(String str) =>
    QueryWallet.fromJson(json.decode(str));

String queryWalletToJson(QueryWallet data) => json.encode(data.toJson());

class QueryWallet {
  QueryWallet({
    required this.userId,
    required this.key,
  });

  String userId;
  String key;

  factory QueryWallet.fromJson(Map<String, dynamic> json) => QueryWallet(
        userId: json["user_id"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "key": key,
      };
}
