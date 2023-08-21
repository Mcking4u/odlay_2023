// To parse this JSON data, do
//
//     final responseSearchCustom = responseSearchCustomFromJson(jsonString);

import 'dart:convert';

ResponseSearchServiceProvider responseSearchCustomFromJson(String str) =>
    ResponseSearchServiceProvider.fromJson(json.decode(str));

String responseSearchServiceToJson(ResponseSearchServiceProvider data) =>
    json.encode(data.toJson());

class ResponseSearchServiceProvider {
  ResponseSearchServiceProvider({
    required this.serviceproviders,
    required this.gigs,
  });

  Gigs serviceproviders;
  Gigs gigs;

  factory ResponseSearchServiceProvider.fromJson(Map<String, dynamic> json) =>
      ResponseSearchServiceProvider(
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
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  int? currentPage;
  List<dynamic> data;
  String? firstPageUrl;
  dynamic from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  dynamic to;
  int? total;

  factory Gigs.fromJson(Map<String, dynamic> json) => Gigs(
        currentPage: json["current_page"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
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
        "data": List<dynamic>.from(data.map((x) => x)),
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
