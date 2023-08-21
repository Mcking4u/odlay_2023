// To parse this JSON data, do
//
//     final resposnePhoneStatus = resposnePhoneStatusFromJson(jsonString);

import 'dart:convert';

ResposnePhoneStatus resposnePhoneStatusFromJson(String str) =>
    ResposnePhoneStatus.fromJson(json.decode(str));

String resposnePhoneStatusToJson(ResposnePhoneStatus data) =>
    json.encode(data.toJson());

class ResposnePhoneStatus {
  ResposnePhoneStatus({
    required this.status,
    required this.allowMobileCall,
  });

  String status;
  int allowMobileCall;

  factory ResposnePhoneStatus.fromJson(Map<String, dynamic> json) =>
      ResposnePhoneStatus(
        status: json["status"],
        allowMobileCall: json["allow_mobile_call"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "allow_mobile_call": allowMobileCall,
      };
}
