// To parse this JSON data, do
//
//     final responseLoginUser = responseLoginUserFromJson(jsonString);

import 'dart:convert';

ResponseLoginUser responseLoginUserFromJson(String str) =>
    ResponseLoginUser.fromJson(json.decode(str));

String responseLoginUserToJson(ResponseLoginUser data) =>
    json.encode(data.toJson());

class ResponseLoginUser {
  ResponseLoginUser({
    required this.status,
    required this.user,
  });

  String status;
  User user;

  factory ResponseLoginUser.fromJson(Map<String, dynamic> json) =>
      ResponseLoginUser(
        status: json["status"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.logo,
    required this.roleId,
    required this.status,
    required this.apiKey,
    required this.firebaseUid,
    required this.deviceToken,
    required this.isOld,
    required this.logoutUser,
    required this.idCardStatus,
    required this.addressProofStatus,
    required this.idCardImage,
    required this.addressProofImage,
    required this.cnic,
    required this.profilePicStatus,
    required this.gender,
    required this.language,
    required this.allowMobileCall,
    required this.currencyTitle,
    required this.currencySymbol,
    required this.custMessages,
    required this.spMessages,
    required this.userMessages,
    required this.skills,
    required this.bannerImages,
    required this.spfee,
    required this.custfee,
    required this.min_amount,
    required this.max_amount,
    required this.hashTags,
    required this.gigpost,
    required this.sppost,
    required this.encryptionMode,
    required this.apiPlanText,
    required this.apiKeyHashed,
    required this.consumer,
    required this.serviceProviders,
    required this.stp_sec,
  });

  int? id;
  String? firstName;
  String? email;
  String? phone;
  String? logo;
  int? roleId;
  int? status;
  String? apiKey;
  String? firebaseUid;
  String? deviceToken;
  int? isOld;
  int? logoutUser;
  int? idCardStatus;
  int? addressProofStatus;
  dynamic idCardImage;
  dynamic addressProofImage;
  dynamic cnic;
  dynamic profilePicStatus;
  String? gender;
  int? language;
  int? allowMobileCall;
  String? currencyTitle;
  String? currencySymbol;
  CustMessages custMessages;
  SpMessages spMessages;
  UserMessages userMessages;
  List<dynamic>? skills;
  List<String> bannerImages;
  String? hashTags;
  String? sppost;
  String? gigpost;
  String? spfee;
  String? custfee;
  int? min_amount;
  int? max_amount;
  String? encryptionMode;
  String? apiPlanText;
  String? apiKeyHashed;
  Consumer consumer;
  ServiceProviders serviceProviders;
  String? stp_sec;
  // List<ServiceproviderSkill>? serviceproviderSkills;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        email: json["email"],
        phone: json["phone"],
        logo: json["logo"],
        roleId: json["role_id"],
        status: json["status"],
        apiKey: json["api_key"],
        firebaseUid: json["firebase_uid"],
        deviceToken: json["device_token"],
        isOld: json["is_old"],
        logoutUser: json["logout_user"],
        idCardStatus: json["id_card_status"],
        addressProofStatus: json["address_proof_status"],
        idCardImage: json["id_card_image"],
        addressProofImage: json["address_proof_image"],
        cnic: json["cnic"],
        profilePicStatus: json["profile_pic_status"],
        gender: json["gender"],
        language: json["language"],
        allowMobileCall: json["allow_mobile_call"],
        currencyTitle: json["currency_title"],
        currencySymbol: json["currency_symbol"],
        custMessages: CustMessages.fromJson(json["cust_messages"]),
        spMessages: SpMessages.fromJson(json["sp_messages"]),
        userMessages: UserMessages.fromJson(json["user_messages"]),
        skills: List<dynamic>.from(json["skills"].map((x) => x)),
        bannerImages: List<String>.from(json["banner_images"].map((x) => x)),
        encryptionMode: json["ENCRYPTION_MODE"],
        apiPlanText: json["api_plan_text"],
        hashTags: json["hashTags"],
        sppost: json["sppost"],
        gigpost: json["gigpost"],
        spfee: json["spfee"],
        custfee: json["custfee"],
        min_amount: json["min_amount"],
        max_amount: json["max_amount"],
        apiKeyHashed: json["api_key_hashed"],
        consumer: Consumer.fromJson(json["consumer"]),
        serviceProviders: ServiceProviders.fromJson(json["service_providers"]),
        stp_sec: json["stp_sec"],
        // serviceproviderSkills: List<ServiceproviderSkill>.from(
        //     json["serviceprovider_skills"]
        //         .map((x) => ServiceproviderSkill.fromJson(x))
        //         ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "email": email,
        "phone": phone,
        "logo": logo,
        "role_id": roleId,
        "status": status,
        "api_key": apiKey,
        "firebase_uid": firebaseUid,
        "device_token": deviceToken,
        "is_old": isOld,
        "logout_user": logoutUser,
        "id_card_status": idCardStatus,
        "address_proof_status": addressProofStatus,
        "id_card_image": idCardImage,
        "address_proof_image": addressProofImage,
        "cnic": cnic,
        "profile_pic_status": profilePicStatus,
        "gender": gender,
        "language": language,
        "allow_mobile_call": allowMobileCall,
        "currency_title": currencyTitle,
        "currency_symbol": currencySymbol,
        "cust_messages": custMessages.toJson(),
        "sp_messages": spMessages.toJson(),
        "user_messages": userMessages.toJson(),
        "skills": List<dynamic>.from(skills!.map((x) => x)),
        "banner_images": List<dynamic>.from(bannerImages.map((x) => x)),
        "hashTags": hashTags,
        "sppost": sppost,
        "gigpost": gigpost,
        "spfee": spfee,
        "custfee": custfee,
        "min_amount": min_amount,
        "max_amount": max_amount,
        "ENCRYPTION_MODE": encryptionMode,
        "api_plan_text": apiPlanText,
        "api_key_hashed": apiKeyHashed,
        "consumer": consumer.toJson(),
        "service_providers": serviceProviders.toJson(),
        "stp_sec": stp_sec,
      };
}

class Consumer {
  Consumer({
    required this.id,
    required this.userId,
    required this.alerts,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceId,
    required this.consumerId,
    required this.jobId,
    required this.streetNo,
    required this.address,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.cityId,
  });

  int id;
  int userId;
  int alerts;
  DateTime createdAt;
  DateTime updatedAt;
  int serviceId;
  int consumerId;
  int jobId;
  dynamic streetNo;
  dynamic address;
  dynamic postalCode;
  String? latitude;
  String? longitude;
  dynamic cityId;

  factory Consumer.fromJson(Map<String, dynamic> json) => Consumer(
        id: json["id"],
        userId: json["user_id"],
        alerts: json["alerts"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        serviceId: json["service_id"],
        consumerId: json["consumer_id"],
        jobId: json["job_id"],
        streetNo: json["street_no"],
        address: json["address"],
        postalCode: json["postal_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        cityId: json["city_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "alerts": alerts,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "service_id": serviceId,
        "consumer_id": consumerId,
        "job_id": jobId,
        "street_no": streetNo,
        "address": address,
        "postal_code": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "city_id": cityId,
      };
}

class CustMessages {
  CustMessages({
    required this.callinviteText,
    required this.invitedforjob,
    required this.awardAction,
    required this.custPaymentAlert,
    required this.custCashPaypmentWarning,
    required this.custPaymentOnlineSuccessful,
    required this.custJobStarted,
    required this.custJobAward,
    required this.jobPosted,
    required this.spInvitied,
    required this.custJobAwarded,
    required this.custPaymentDoneCash,
    required this.custPaymentDoneOnline,
    required this.custComplaint,
    required this.custJobAwardedInfo,
    required this.custJobCompletedAlert,
    required this.custJobUpdated,
    required this.custJobCompleteDiscl,
    required this.custPaymentDoneCashToast,
    required this.custJobBacktoProgress,
    required this.custJobApproved,
    required this.custHireBeforeCall,
    required this.disableCustJobsInprogress,
    required this.recSpNotAvailable,
    required this.recSkillMissingFromjob,
    required this.custAddressUpdate,
    required this.postJobAddressUpdate,
    required this.gigHireAddressUpdate,
    required this.cust_job_cancel_discl,
    required this.cust_job_not_finished_discl,
    required this.cust_job_dispute_discl,
    required this.cust_payment_info,
    required this.cust_gig_info,
  });

  AwardAction callinviteText;
  AwardAction invitedforjob;
  AwardAction awardAction;
  AwardAction custPaymentAlert;
  AwardAction custCashPaypmentWarning;
  AwardAction custPaymentOnlineSuccessful;
  AwardAction custJobStarted;
  AwardAction custJobAward;
  AwardAction jobPosted;
  AwardAction spInvitied;
  AwardAction custJobAwarded;
  AwardAction custPaymentDoneCash;
  AwardAction custPaymentDoneOnline;
  AwardAction custComplaint;
  AwardAction custJobAwardedInfo;
  AwardAction custJobCompletedAlert;
  AwardAction custJobUpdated;
  AwardAction custJobCompleteDiscl;
  AwardAction custPaymentDoneCashToast;
  AwardAction custJobBacktoProgress;
  AwardAction custJobApproved;
  AwardAction custHireBeforeCall;
  AwardAction disableCustJobsInprogress;
  AwardAction recSpNotAvailable;
  AwardAction recSkillMissingFromjob;
  AwardAction custAddressUpdate;
  AwardAction postJobAddressUpdate;
  AwardAction gigHireAddressUpdate;
  AwardAction cust_job_cancel_discl;
  AwardAction cust_job_not_finished_discl;
  AwardAction cust_job_dispute_discl;
  AwardAction cust_payment_info;
  AwardAction cust_gig_info;

  factory CustMessages.fromJson(Map<String, dynamic> json) => CustMessages(
        callinviteText: AwardAction.fromJson(json["callinviteText"]),
        invitedforjob: AwardAction.fromJson(json["invitedforjob"]),
        awardAction: AwardAction.fromJson(json["award_action"]),
        custPaymentAlert: AwardAction.fromJson(json["cust_payment_alert"]),
        custCashPaypmentWarning:
            AwardAction.fromJson(json["cust_cash_paypment_warning"]),
        custPaymentOnlineSuccessful:
            AwardAction.fromJson(json["cust_payment_online_successful"]),
        custJobStarted: AwardAction.fromJson(json["cust_job_started"]),
        custJobAward: AwardAction.fromJson(json["cust_job_award"]),
        jobPosted: AwardAction.fromJson(json["job_posted"]),
        spInvitied: AwardAction.fromJson(json["sp_invitied"]),
        custJobAwarded: AwardAction.fromJson(json["cust_job_awarded"]),
        custPaymentDoneCash:
            AwardAction.fromJson(json["cust_payment_done_cash"]),
        custPaymentDoneOnline:
            AwardAction.fromJson(json["cust_payment_done_online"]),
        custComplaint: AwardAction.fromJson(json["cust_complaint"]),
        custJobAwardedInfo: AwardAction.fromJson(json["cust_job_awarded_info"]),
        custJobCompletedAlert:
            AwardAction.fromJson(json["cust_job_completed_alert"]),
        custJobUpdated: AwardAction.fromJson(json["cust_job_updated"]),
        custJobCompleteDiscl:
            AwardAction.fromJson(json["cust_job_complete_discl"]),
        custPaymentDoneCashToast:
            AwardAction.fromJson(json["cust_payment_done_cash_toast"]),
        custJobBacktoProgress:
            AwardAction.fromJson(json["cust_job_backto_progress"]),
        custJobApproved: AwardAction.fromJson(json["cust_job_approved"]),
        custHireBeforeCall: AwardAction.fromJson(json["cust_hire_before_call"]),
        disableCustJobsInprogress:
            AwardAction.fromJson(json["disable_cust_jobs_inprogress"]),
        recSpNotAvailable: AwardAction.fromJson(json["rec_sp_not_available"]),
        recSkillMissingFromjob:
            AwardAction.fromJson(json["rec_skill_missing_fromjob"]),
        custAddressUpdate: AwardAction.fromJson(json["cust_address_update"]),
        postJobAddressUpdate:
            AwardAction.fromJson(json["post_job_address_update"]),
        gigHireAddressUpdate:
            AwardAction.fromJson(json["gig_hire_address_update"]),
        cust_job_cancel_discl:
            AwardAction.fromJson(json["cust_job_cancel_discl"]),
        cust_job_not_finished_discl:
            AwardAction.fromJson(json["cust_job_not_finished_discl"]),
        cust_job_dispute_discl:
            AwardAction.fromJson(json["cust_job_dispute_discl"]),
    cust_payment_info:
    AwardAction.fromJson(json["cust_payment_info"]),
    cust_gig_info:
    AwardAction.fromJson(json["cust_gig_info"]),
      );

  Map<String, dynamic> toJson() => {
        "callinviteText": callinviteText.toJson(),
        "invitedforjob": invitedforjob.toJson(),
        "award_action": awardAction.toJson(),
        "cust_payment_alert": custPaymentAlert.toJson(),
        "cust_cash_paypment_warning": custCashPaypmentWarning.toJson(),
        "cust_payment_online_successful": custPaymentOnlineSuccessful.toJson(),
        "cust_job_started": custJobStarted.toJson(),
        "cust_job_award": custJobAward.toJson(),
        "job_posted": jobPosted.toJson(),
        "sp_invitied": spInvitied.toJson(),
        "cust_job_awarded": custJobAwarded.toJson(),
        "cust_payment_done_cash": custPaymentDoneCash.toJson(),
        "cust_payment_done_online": custPaymentDoneOnline.toJson(),
        "cust_complaint": custComplaint.toJson(),
        "cust_job_awarded_info": custJobAwardedInfo.toJson(),
        "cust_job_completed_alert": custJobCompletedAlert.toJson(),
        "cust_job_updated": custJobUpdated.toJson(),
        "cust_job_complete_discl": custJobCompleteDiscl.toJson(),
        "cust_payment_done_cash_toast": custPaymentDoneCashToast.toJson(),
        "cust_job_backto_progress": custJobBacktoProgress.toJson(),
        "cust_job_approved": custJobApproved.toJson(),
        "cust_hire_before_call": custHireBeforeCall.toJson(),
        "disable_cust_jobs_inprogress": disableCustJobsInprogress.toJson(),
        "rec_sp_not_available": recSpNotAvailable.toJson(),
        "rec_skill_missing_fromjob": recSkillMissingFromjob.toJson(),
        "cust_address_update": custAddressUpdate.toJson(),
        "post_job_address_update": postJobAddressUpdate.toJson(),
        "gig_hire_address_update": gigHireAddressUpdate.toJson(),
        "cust_job_cancel_discl": cust_job_cancel_discl.toJson(),
        "cust_job_dispute_discl": cust_job_dispute_discl.toJson(),
    "cust_payment_info": cust_payment_info.toJson(),
    "cust_gig_info": cust_gig_info.toJson(),
      };
}

class AwardAction {
  AwardAction({
    required this.id,
    required this.messageType,
    required this.userType,
    required this.messageTitle,
    required this.message,
    required this.jobStatusId,
    required this.lngId,
  });

  int id;
  MessageType? messageType;
  UserType? userType;
  String messageTitle;
  String message;
  dynamic jobStatusId;
  int lngId;

  factory AwardAction.fromJson(Map<String, dynamic> json) => AwardAction(
        id: json["id"],
        messageType: messageTypeValues.map[json["message_type"]],
        userType: userTypeValues.map[json["user_type"]],
        messageTitle: json["message_title"],
        message: json["message"],
        jobStatusId: json["job_status_id"],
        lngId: json["lng_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message_type": messageTypeValues.reverse![messageType],
        "user_type": userTypeValues.reverse![userType],
        "message_title": messageTitle,
        "message": message,
        "job_status_id": jobStatusId,
        "lng_id": lngId,
      };
}

enum MessageType { INFO, TOAST, POPUP, DISCL }

final messageTypeValues = EnumValues({
  "discl": MessageType.DISCL,
  "info": MessageType.INFO,
  "popup": MessageType.POPUP,
  "toast": MessageType.TOAST
});

enum UserType { CUST, SP, USER }

final userTypeValues = EnumValues(
    {"cust": UserType.CUST, "sp": UserType.SP, "user": UserType.USER});

class ServiceProviders {
  ServiceProviders({
    required this.id,
    required this.profession,
    required this.objective,
    required this.userId,
    required this.ratePerHour,
    required this.available,
    required this.businesshours,
    required this.workDistanceKm,
    required this.educationId,
    required this.expectedSalaryId,
    required this.currentSalaryId,
    required this.experienceId,
    required this.languageId,
    required this.createdAt,
    required this.updatedAt,
    required this.portfolioImages,
    required this.allowMobileCall,
    required this.serviceId,
    required this.consumerId,
    required this.jobId,
    required this.streetNo,
    required this.address,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.cityId,
  });

  int? id;
  dynamic profession;
  dynamic objective;
  int? userId;
  dynamic ratePerHour;
  int? available;
  String? businesshours;
  int workDistanceKm;
  dynamic educationId;
  dynamic expectedSalaryId;
  dynamic currentSalaryId;
  dynamic experienceId;
  int? languageId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic portfolioImages;
  int? allowMobileCall;
  int? serviceId;
  int? consumerId;
  int? jobId;
  dynamic streetNo;
  String? address;
  dynamic postalCode;
  String? latitude;
  String? longitude;
  dynamic cityId;

  factory ServiceProviders.fromJson(Map<String, dynamic> json) =>
      ServiceProviders(
        id: json["id"],
        profession: json["profession"],
        objective: json["objective"],
        userId: json["user_id"],
        ratePerHour: json["rate_per_hour"],
        available: json["available"],
        businesshours: json["businesshours"],
        workDistanceKm: json["work_distance_km"],
        educationId: json["education_id"],
        expectedSalaryId: json["expected_salary_id"],
        currentSalaryId: json["current_salary_id"],
        experienceId: json["experience_id"],
        languageId: json["language_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        portfolioImages: json["portfolio_images"],
        allowMobileCall: json["allow_mobile_call"],
        serviceId: json["service_id"],
        consumerId: json["consumer_id"],
        jobId: json["job_id"],
        streetNo: json["street_no"],
        address: json["address"],
        postalCode: json["postal_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        cityId: json["city_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profession": profession,
        "objective": objective,
        "user_id": userId,
        "rate_per_hour": ratePerHour,
        "available": available,
        "businesshours": businesshours,
        "work_distance_km": workDistanceKm,
        "education_id": educationId,
        "expected_salary_id": expectedSalaryId,
        "current_salary_id": currentSalaryId,
        "experience_id": experienceId,
        "language_id": languageId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "portfolio_images": portfolioImages,
        "allow_mobile_call": allowMobileCall,
        "service_id": serviceId,
        "consumer_id": consumerId,
        "job_id": jobId,
        "street_no": streetNo,
        "address": address,
        "postal_code": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "city_id": cityId,
      };
}

class SpMessages {
  SpMessages({
    required this.cashpaymentAlert,
    required this.invitedforjob,
    required this.awarded,
    required this.spPaymentAlert,
    required this.spCashPaymentWarning,
    required this.payspMentOnlineSuccessful,
    required this.spJobStartedInfo,
    required this.spJobAccept,
    required this.spJobFinishDiscl,
    required this.spSkillsUpdated,
    required this.spAppliedOnJob,
    required this.spJobAccepted,
    required this.spJobStarted,
    required this.custComplaint,
    required this.spJobFinish,
    required this.spJobApplied,
    required this.disableSpJobsInprogress,
    required this.spAddressUpdate,
    required this.applyJobAddressUpdate,
    required this.bidAmountUpdate,
    required this.sp_job_cancel_discl,
    required this.sp_job_dispute_discl,
    required this.sp_job_caceled,
    required this.sp_job_app_unsuccessful,
    required this.sp_payment_info,
    required this.sp_gig_info,
  });

  AwardAction cashpaymentAlert;
  AwardAction invitedforjob;
  AwardAction awarded;
  AwardAction spPaymentAlert;
  AwardAction spCashPaymentWarning;
  AwardAction payspMentOnlineSuccessful;
  AwardAction spJobStartedInfo;
  AwardAction spJobAccept;
  AwardAction spJobFinishDiscl;
  AwardAction spSkillsUpdated;
  AwardAction spAppliedOnJob;
  AwardAction spJobAccepted;
  AwardAction spJobStarted;
  AwardAction custComplaint;
  AwardAction spJobFinish;
  AwardAction spJobApplied;
  AwardAction disableSpJobsInprogress;
  AwardAction spAddressUpdate;
  AwardAction applyJobAddressUpdate;
  AwardAction bidAmountUpdate;
  AwardAction sp_job_cancel_discl;
  AwardAction sp_job_dispute_discl;
  AwardAction sp_job_caceled;
  AwardAction sp_job_app_unsuccessful;
  AwardAction sp_payment_info;
  AwardAction sp_gig_info;

  factory SpMessages.fromJson(Map<String, dynamic> json) => SpMessages(
        cashpaymentAlert: AwardAction.fromJson(json["cashpayment_alert"]),
        invitedforjob: AwardAction.fromJson(json["invitedforjob"]),
        awarded: AwardAction.fromJson(json["awarded"]),
        spPaymentAlert: AwardAction.fromJson(json["sp_payment_alert"]),
        spCashPaymentWarning:
            AwardAction.fromJson(json["sp_cash_payment_warning"]),
        payspMentOnlineSuccessful:
            AwardAction.fromJson(json["paysp_ment_online_successful"]),
        spJobStartedInfo: AwardAction.fromJson(json["sp_job_started_info"]),
        spJobAccept: AwardAction.fromJson(json["sp_job_accept"]),
        spJobFinishDiscl: AwardAction.fromJson(json["sp_job_finish_discl"]),
        spSkillsUpdated: AwardAction.fromJson(json["sp_skills_updated"]),
        spAppliedOnJob: AwardAction.fromJson(json["sp_applied_on_job"]),
        spJobAccepted: AwardAction.fromJson(json["sp_job_accepted"]),
        spJobStarted: AwardAction.fromJson(json["sp_job_started"]),
        custComplaint: AwardAction.fromJson(json["cust_complaint"]),
        spJobFinish: AwardAction.fromJson(json["sp_job_finish"]),
        spJobApplied: AwardAction.fromJson(json["sp_job_applied"]),
        disableSpJobsInprogress:
            AwardAction.fromJson(json["disable_sp_jobs_inprogress"]),
        spAddressUpdate: AwardAction.fromJson(json["sp_address_update"]),
        applyJobAddressUpdate:
            AwardAction.fromJson(json["apply_job_address_update"]),
        bidAmountUpdate: AwardAction.fromJson(json["bid_amount_update"]),
        sp_job_cancel_discl: AwardAction.fromJson(json["sp_job_cancel_discl"]),
        sp_job_dispute_discl:
            AwardAction.fromJson(json["sp_job_dispute_discl"]),
        sp_job_caceled: AwardAction.fromJson(json["sp_job_caceled"]),
        sp_job_app_unsuccessful: AwardAction.fromJson(json["sp_job_app_unsuccessful"]),
        sp_payment_info: AwardAction.fromJson(json["sp_payment_info"]),
    sp_gig_info: AwardAction.fromJson(json["sp_gig_info"]),
      );

  Map<String, dynamic> toJson() => {
        "cashpayment_alert": cashpaymentAlert.toJson(),
        "invitedforjob": invitedforjob.toJson(),
        "awarded": awarded.toJson(),
        "sp_payment_alert": spPaymentAlert.toJson(),
        "sp_cash_payment_warning": spCashPaymentWarning.toJson(),
        "paysp_ment_online_successful": payspMentOnlineSuccessful.toJson(),
        "sp_job_started_info": spJobStartedInfo.toJson(),
        "sp_job_accept": spJobAccept.toJson(),
        "sp_job_finish_discl": spJobFinishDiscl.toJson(),
        "sp_skills_updated": spSkillsUpdated.toJson(),
        "sp_applied_on_job": spAppliedOnJob.toJson(),
        "sp_job_accepted": spJobAccepted.toJson(),
        "sp_job_started": spJobStarted.toJson(),
        "cust_complaint": custComplaint.toJson(),
        "sp_job_finish": spJobFinish.toJson(),
        "sp_job_applied": spJobApplied.toJson(),
        "disable_sp_jobs_inprogress": disableSpJobsInprogress.toJson(),
        "sp_address_update": spAddressUpdate.toJson(),
        "apply_job_address_update": applyJobAddressUpdate.toJson(),
        "bid_amount_update": bidAmountUpdate.toJson(),
        "sp_job_cancel_discl": sp_job_cancel_discl.toJson(),
        "sp_job_dispute_discl": sp_job_dispute_discl.toJson(),
        "sp_job_caceled": sp_job_caceled.toJson(),
        "sp_job_app_unsuccessful": sp_job_app_unsuccessful.toJson(),
    "sp_payment_info": sp_payment_info.toJson(),
    "sp_gig_info": sp_gig_info.toJson(),
      };
}

class UserMessages {
  UserMessages(
      {required this.userDisableWarning,
      required this.userDeleteWarning,
      required this.userDisabled,
      required this.userBlocked,
      required this.userDeleteInprogress,
      required this.disabledSignout,
      required this.deletedSignout,
      required this.accountEnabled,
      required this.taxMsg,
      required this.job_completed_with_success,
      required this.job_cancelled,
      required this.job_closed_with_dispute});

  AwardAction userDisableWarning;
  AwardAction userDeleteWarning;
  AwardAction userDisabled;
  AwardAction userBlocked;
  AwardAction userDeleteInprogress;
  AwardAction disabledSignout;
  AwardAction deletedSignout;
  AwardAction accountEnabled;
  AwardAction taxMsg;
  AwardAction job_completed_with_success;
  AwardAction job_cancelled;
  AwardAction job_closed_with_dispute;

  factory UserMessages.fromJson(Map<String, dynamic> json) => UserMessages(
        userDisableWarning: AwardAction.fromJson(json["user_disable_warning"]),
        userDeleteWarning: AwardAction.fromJson(json["user_delete_warning"]),
        userDisabled: AwardAction.fromJson(json["user_disabled"]),
        userBlocked: AwardAction.fromJson(json["user_blocked"]),
        userDeleteInprogress:
            AwardAction.fromJson(json["user_delete_inprogress"]),
        disabledSignout: AwardAction.fromJson(json["disabled_signout"]),
        deletedSignout: AwardAction.fromJson(json["deleted_signout"]),
        accountEnabled: AwardAction.fromJson(json["account_enabled"]),
        taxMsg: AwardAction.fromJson(json["tax_msg"]),
        job_completed_with_success:
            AwardAction.fromJson(json["job_completed_with_success"]),
        job_cancelled: AwardAction.fromJson(json["job_cancelled"]),
        job_closed_with_dispute:
            AwardAction.fromJson(json["job_closed_with_dispute"]),
      );

  Map<String, dynamic> toJson() => {
        "user_disable_warning": userDisableWarning.toJson(),
        "user_delete_warning": userDeleteWarning.toJson(),
        "user_disabled": userDisabled.toJson(),
        "user_blocked": userBlocked.toJson(),
        "user_delete_inprogress": userDeleteInprogress.toJson(),
        "disabled_signout": disabledSignout.toJson(),
        "deleted_signout": deletedSignout.toJson(),
        "account_enabled": accountEnabled.toJson(),
        "tax_msg": taxMsg.toJson(),
        "job_completed_with_success": job_completed_with_success.toJson(),
        "job_cancelled": job_cancelled.toJson(),
        "job_closed_with_dispute": job_closed_with_dispute.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class ServiceproviderSkill {
  ServiceproviderSkill({
    required this.id,
    required this.skillId,
    required this.serviceproviderId,
    required this.createdAt,
    required this.updatedAt,
    required this.roughskillId,
    required this.mSkillId,
  });

  int id;
  int skillId;
  int serviceproviderId;
  String? createdAt;
  String? updatedAt;
  String? roughskillId;
  String? mSkillId;

  factory ServiceproviderSkill.fromJson(Map<String, dynamic> json) =>
      ServiceproviderSkill(
        id: json["id"],
        skillId: json["skill_id"],
        serviceproviderId: json["serviceprovider_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        roughskillId: json["roughskill_id"],
        mSkillId: json["m_skill_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "skill_id": skillId,
        "serviceprovider_id": serviceproviderId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "roughskill_id": roughskillId,
        "m_skill_id": mSkillId,
      };
}
