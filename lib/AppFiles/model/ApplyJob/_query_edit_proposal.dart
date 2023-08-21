// To parse this JSON data, do
//
//     final querEditProposal = querEditProposalFromJson(jsonString);

import 'dart:convert';

QuerEditProposal querEditProposalFromJson(String str) =>
    QuerEditProposal.fromJson(json.decode(str));

String querEditProposalToJson(QuerEditProposal data) =>
    json.encode(data.toJson());

class QuerEditProposal {
  QuerEditProposal({
    required this.jobId,
    required this.applicantId,
    required this.budgetAmount,
  });

  String? jobId;
  String? applicantId;
  String? budgetAmount;

  factory QuerEditProposal.fromJson(Map<String, dynamic> json) =>
      QuerEditProposal(
        jobId: json["job_id"],
        applicantId: json["applicant_id"],
        budgetAmount: json["budget_amount"],
      );

  Map<String, dynamic> toJson() => {
        "job_id": jobId,
        "applicant_id": applicantId,
        "budget_amount": budgetAmount,
      };
}
