// ignore_for_file: non_constant_identifier_names

import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_response.dart';

class JobConstants {
//customer jobs  list
  static List<ResponseCustomersShowJobs> list_cus_open_jobs = [];
  static List<ResponseCustomersShowJobs> list_cus_started_jobs = [];
  static List<ResponseCustomersShowJobs> list_cus_closed_jobs = [];
//service Provider jobs  list
  static List<Applied> list_sp_applied_jobs = [];
  static List<Applied> list_sp_started_jobs = [];
  static List<Applied> list_sp_closed_jobs = [];
//job status
  static int NOT_VIEWED_STATUS = 0;
  static int VIEW_STATUS = 1;
  static int SHORTLISTED_STATUS = 2;
  static int REJECTED_STATUS = 3;
  static int HIRED_STATUS = 4;
  static int STARTED_STATUS = 5;
  static int REVSION_STATUS = 6;
  static int DELIVERED_STATUS = 7;
  static int COMPLETED_STATUS = 8;
  static int DISPUTED_STATUS = 9;
  static int CANCELED_STATUS = 10;
  static int JOB_DELETED = 11;
  static int SP_ACCEPTED = 12;
  static int PAYMENTDONE = 13;
  static int WAITING_FOR_SKILL_APPROVAL = 14;
  static int INVITED_FOR_JOB = 15;
  static int USER_APPLIED_AFTER_INVITATION = 16;
  static int SERVICE_PROVIDER_APPLIED = 17;
  static int HIRED_THROUGH_GIG = 18;
  static int USER_APPLIED_TO_OPEN_JOB = 19;
  static int APPLICANT_WITHDRAW_REQUEST = 21;
  static int APPLICANT_UNSUCCESSFULL = 22;
  static int COMPLETED_Job_REVIEWE_DONE = 23;
//payment methods
  static int CASH_PAYMENT = 0;
  static int CARD_PAYMENT = 1;
  static int EASY_PAISA_PAYMENT = 2;
  static int JAZZ_CASH_PAYMENT = 3;
  static int U_PAYMENT = 4;
//payment Info key
  static String PAYMENTKEYCUST = "customer";
  static String PAYMENTKEYSP = "Service Provider";
}
