import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Utility/ApiPathsConstats.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_change_job_status.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_query_apply_job.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_query_edit_proposal.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/check_user.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/query_check_user_model.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/query_firebase_uid.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/query_login_user.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/query_register_user_model.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/reponse_register_user.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/_reponse_apply_job.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/query_updated_profile.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CreateGigModel/_quer_read_single_gig_detail.dart';
import 'package:odlay_services/AppFiles/model/CreateGigModel/_query_create_gig.dart';
import 'package:odlay_services/AppFiles/model/CreateGigModel/_reponse_create_gig.dart';
import 'package:odlay_services/AppFiles/model/CreateGigModel/_response_single_gig_detail.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/CustomerModels/jobs_model.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_edit_gig.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_query_top_rated_gigs_modle.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_response_edit_gig.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_response_featured_gigs.dart';
import 'package:odlay_services/AppFiles/model/JobDetailModels/ResponseJobDetail.dart';
import 'package:odlay_services/AppFiles/model/JobDetailModels/_query_job_detail.dart';
import 'package:odlay_services/AppFiles/model/PaymentModels/_query_get_stripe_key.dart';
import 'package:odlay_services/AppFiles/model/PaymentModels/_query_process_payment.dart';
import 'package:odlay_services/AppFiles/model/PaymentModels/_response_stripe_key.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/_check_permission_response.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/_query_change_language.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/_query_change_permission.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/query_check_phone_status.dart';
import 'package:odlay_services/AppFiles/model/PostJobModel/_queryEditjob.dart';
import 'package:odlay_services/AppFiles/model/PostJobModel/_query_delete_job.dart';
import 'package:odlay_services/AppFiles/model/PostJobModel/_querypostjob.dart';
import 'package:odlay_services/AppFiles/model/PostJobModel/_responsePostJob.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_quer_edit_profile.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_direct_job_creation.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_invite_on_job.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_my_jobs_summary.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_post_job_vs_service_provider.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_update_address.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_direct_job_creation.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_my_jobs_summary.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_service_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_resposne_post_job_vs_service_provider.dart';
import 'package:odlay_services/AppFiles/model/Review/_query_post_review.dart';
import 'package:odlay_services/AppFiles/model/Review/_response_post_review.dart';
import 'package:odlay_services/AppFiles/model/SearchModels/customerModel/_response_simple_search_all_sp.dart';

import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_SptopRatedServiceProvider.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:odlay_services/AppFiles/model/UpdateSkills/_update_service_provider_skill.dart';
import 'package:odlay_services/AppFiles/model/UpdateUserDetail.dart/_query_quick_update.dart';
import 'package:odlay_services/AppFiles/model/UpdateUserDetail.dart/_response_quick_update.dart';
import 'package:odlay_services/AppFiles/model/UserSettings/_query_disable_user.dart';
import 'package:odlay_services/AppFiles/model/UserSettings/_response_disable_user.dart';
import 'package:odlay_services/AppFiles/model/VerifyPhoneModel/_query_verify_phone.dart';
import 'package:odlay_services/AppFiles/model/VerifyPhoneModel/_response_verify_phone.dart';
import 'package:odlay_services/AppFiles/model/WalletModel/_query_wallet.dart';
import 'package:odlay_services/AppFiles/model/WalletModel/_wallet_response.dart';
import 'package:odlay_services/AppFiles/model/WalletModelSp/_wallets_response_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/AuthPages/enter_phone.dart';

import '../model/LogEvents/query_log_event.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<CheckUserModel?> checkUserState(
      String phone_number, String code) async {
    QueryCheckUserModel queryCheckUserModel =
        QueryCheckUserModel(phone: phone_number, country_code: code);
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.CHECKPHONE),
        body: queryCheckUserModelToJson(queryCheckUserModel),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY
        });
    if (response.statusCode == 200) {
      print("Resposne_Received");
      var jsontring = response.body;
      return checkUserModelFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//verify phone api call
  static Future<ResponseVerifyPhone?> verifyPhone(
      QueryVerifyPhone queryVerifyPhone) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.VERIFYPHONE),
        body: queryVerifyPhoneToJson(queryVerifyPhone),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY
        });
    if (response.statusCode == 200) {
      print("Resposne_Received");
      var jsontring = response.body;
      return responseVerifyPhoneFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

  static Future<ResponseLoginUser?> loginUser(String phone_number) async {
    QueryLoginUser queryLoginUser =
        QueryLoginUser(phone: phone_number, password: "N9&jvXMxe++4ghFT");
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.LOGINUSER),
        body: queryLoginUserToJson(queryLoginUser),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY
        });
    if (response.statusCode == 200) {
      print("Resposne_Received");
      var jsontring = response.body;
      Constants.sharedPreferences
          .setString(SharePrefrencesValues.SAVEDUSERDATA, jsontring);
      return responseLoginUserFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

  static Future<ResponseRegisterUser?> registerUser(String email, String fName,
      String gender, String fbUuid, String phone) async {
    QueryRegisterUser queryRegisterUser = QueryRegisterUser(
        email: email,
        firstName: fName,
        gender: gender,
        password: "N9&jvXMxe++4ghFT",
        firebaseUid: fbUuid,
        phone: phone);
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.REGISTER),
        body: queryRegisterUserToJson(queryRegisterUser),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY
        });
    if (response.statusCode == 200) {
      print("Resposne_Received");
      var jsontring = response.body;
      return responseRegisterUserFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get skill cities and professions
  static Future<SkillCitiesProfessions?> getSkillCitiesProfessiona(
      int? codeLang, String apiKey) async {
    print("AuthrizationPrimary${AppConstants.AUTHOEIZATION_KEY_PRIMARY}");
    print("AuthrizationToken${AppConstants.AUTHOEIZATION_BEARER} $apiKey");
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.GETALLSKILLS}")
        .replace(queryParameters: {"language": codeLang.toString()});
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER}$apiKey"
    });
    if (response.statusCode == 200) {
      print("ResponseHeader${response.headers}");
      var jsontring = response.body;
      // print("Resposne_Received${jsontring}");
      Constants.sharedPreferences
          .setString(SharePrefrencesValues.SKILLCITIESCATGORIES, jsontring);
      return skillCitiesProfessionsFromJson(jsontring);
    } else {
      print("ResponseHeader${response.headers}");
      print("Not_Received${response.statusCode}");

      return null;
    }
  }

//get latest jobs
  static Future<JobsModel?> getLatestJobs(String cityId, String codeLang,
      String page, String apiKey, String lat, String lng) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.GETLATESTJOBS}")
        .replace(queryParameters: {
      "city_id": cityId,
      "language": codeLang,
      "page": page,
      "lat1": lat,
      "lng1": lng,
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return jobsModelFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      if (response.reasonPhrase == "Unauthorized") {
        print("MakeUserLogout");
        Constants.sharedPreferences.setBool("isLoggedIn", false);
        Constants.sharedPreferences.clear();
        Navigator.pushAndRemoveUntil(
          AppConstants.baseContext,
          MaterialPageRoute(builder: (context) => EnterPhone()),
          (Route<dynamic> route) => false,
        );
      }
      return null;
    }
  }

//View All jobs
  static Future<JobsModel?> viewAllJobs(String cityId, String codeLang,
      String page, String apiKey, String lat, String lng) async {
    var uri =
        Uri.parse("${AppConstants.base_api_url}${ApiPathsConstant.VIEWALLJObs}")
            .replace(queryParameters: {
      "city_id": cityId,
      "language": codeLang,
      "page": page,
      "lat1": lat,
      "lng1": lng,
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return jobsModelFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

  static Future<ResponseLoginUser?> updatedProfile(
      String userId, int? langCode, String apiKey) async {
    QueryUpdatedProfile queryUpdatedProfile =
        QueryUpdatedProfile(userId: userId, language: langCode);
    var response = await client.post(
        Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.UPDATEDPROFILE}"),
        body: queryUpdatedProfileToJson(queryUpdatedProfile),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER}$apiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_Received_updatedprofile");
      var jsontring = response.body;
      Constants.sharedPreferences
          .setString(SharePrefrencesValues.SAVEDUSERDATA, jsontring);
      return responseLoginUserFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      print("ReponsePhrase${response.reasonPhrase}");
      if (response.reasonPhrase == "Unauthorized") {
        print("MakeUserLogout");
        Constants.sharedPreferences.setBool("isLoggedIn", false);
        Constants.sharedPreferences.clear();
        Navigator.pushAndRemoveUntil(
          AppConstants.baseContext,
          MaterialPageRoute(builder: (context) => EnterPhone()),
          (Route<dynamic> route) => false,
        );
      }
      return null;
    }
  }

  static Future<ResponseLoginUser?> updatedFirebasUuid(
      String deviceToken, String firebaseUuid, String userId) async {
    QueryFirebaseUid queryFirebaseUid = QueryFirebaseUid(
        deviceToken: deviceToken, firebaseUid: firebaseUuid, userId: userId);
    var response = await client.post(
        Uri.parse(
            AppConstants.base_api_url + ApiPathsConstant.UPDATEFIREBASEUUID),
        body: queryFirebaseUidToJson(queryFirebaseUid),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY
        });
    if (response.statusCode == 200) {
      print("Resposne_ReceivedUpdateFirebaseid");
      var jsontring = response.body;
      return responseLoginUserFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get top rated service provider
  static Future<TopRatedServiceProviders?> getServiceProviders(
      String cityId,
      String codeLang,
      String page,
      String apiKey,
      String lat,
      String lng) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.GETOPRATEDSERVICEPROVIDERS}")
        .replace(queryParameters: {
      "city_id": cityId,
      "language": codeLang,
      "page": page,
      "lat1": lat,
      "lng1": lng,
      "test_value": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      //print("Resposne_Received");
      var jsontring = response.body;
      return topRatedServiceProvidersFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      if (response.reasonPhrase == "Unauthorized") {
        print("MakeUserLogout");
        Constants.sharedPreferences.setBool("isLoggedIn", false);
        Constants.sharedPreferences.clear();
        Navigator.pushAndRemoveUntil(
          AppConstants.baseContext,
          MaterialPageRoute(builder: (context) => EnterPhone()),
          (Route<dynamic> route) => false,
        );
      }
      return null;
    }
  }

//view All service providers
  static Future<TopRatedServiceProviders?> viewAllServiceProvider(
      String cityId,
      String codeLang,
      String page,
      String apiKey,
      String lat,
      String lng) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.VIEWALLSERVICEPROVIDER}")
        .replace(queryParameters: {
      "city_id": cityId,
      "language": codeLang,
      "page": page,
      "lat1": lat,
      "lng1": lng,
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return topRatedServiceProvidersFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

  //post new job
  static Future<ResponsePostJob?> postJob(
      QueryPostJob queryPostJob, String apiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.POSTJOB),
        body: queryPostJobToJson(queryPostJob),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_post_job");
      var jsontring = response.body;
      return responsePostJobFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//edit job
  static Future<ResponsePostJob?> editJob(
      QuerEditJob queryEditJob, String apiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.EDITJOB),
        body: querEditJobToJson(queryEditJob),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_post_job");
      var jsontring = response.body;
      return responsePostJobFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//apply job
  static Future<ReposneGeneral?> applyJob(
      QueryApplyJob queryApplyJob, String apiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.APPLYJOBS),
        body: queryApplyJobToJson(queryApplyJob),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_apply");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//edit proposal or edit bid amount
  static Future<ReposneGeneral?> editProposal(
      QuerEditProposal querEditProposal, String apiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.EDITPROPOSAL),
        body: querEditProposalToJson(querEditProposal),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_edit_proposal");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//chnage job satus
  static Future<ReposneGeneral?> changeJobStatus(
      QueryChangeJobStatus queryChangeJobStatus, String apiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.CHNAGEJOBSTATUS),
        body: queryChangeJobStatusToJson(queryChangeJobStatus),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_apply");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get customer jobs
  static Future<List<ResponseCustomersShowJobs>?> getCustomerJobs(
      QueryCustomersShowJobs queryCustomersShowJobs, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.CUSTOMERJOBS),
        body: queryCustomersShowJobsToJson(queryCustomersShowJobs),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apkiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_custmer_job");
      var jsontring = response.body;
      return responseCustomersShowJobsFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get Applied jobs
  static Future<ServiceproviderJobsShowResponse?> getServiceProviderAppliedJobs(
      ServiceproviderJobsShowQuery serviceproviderJobsShowQuery,
      String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.SPAPPLIEDJOBS),
        body: serviceproviderJobsShowQueryToJson(serviceproviderJobsShowQuery),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apkiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_apply");
      var jsontring = response.body;
      return serviceproviderJobsShowResponseFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get featured gig
  static Future<ResponseFeaturedGigs?> getFeaturedGigs(
      QueryTopRatedGigsModle queryTopRatedGigsModle, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.TOPRATEDGIGS),
        body: queryTopRatedGigsModleToJson(queryTopRatedGigsModle),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER}$apkiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_apply");
      var jsontring = response.body;
      return responseFeaturedGigsFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//view All gigs
  static Future<ResponseFeaturedGigs?> viewAllGigs(
      QueryTopRatedGigsModle queryTopRatedGigsModle, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.VIEWALLGIGS),
        body: queryTopRatedGigsModleToJson(queryTopRatedGigsModle),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apkiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_all_gigs");
      var jsontring = response.body;
      return responseFeaturedGigsFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//job detail
  static Future<ResponseJobDetail?> getJobDetail(
      QueryJobDetail queryJobDetail, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.JOBDETAIL),
        body: queryJobDetailToJson(queryJobDetail),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_apply");
      var jsontring = response.body;
      return responseJobDetailFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//upload Images
  static Future<ReposneGeneral?> uploadImages(String desId, String imgType,
      String delImages, String apkiKey, List<File>? imageFileList) async {
    var uri =
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.UPLOADIMAGES);
    var request = new http.MultipartRequest('POST', uri);
    request.headers.addAll({
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
    });

    request.fields['dest_id'] = desId;
    request.fields['imageType'] = imgType;
    request.fields['deleted_images[]'] = delImages;
    List<http.MultipartFile> newList = [];
    for (int i = 0; i < imageFileList!.length; i++) {
      File Imagefile = File(imageFileList[i].path);
      var stream = http.ByteStream(Imagefile.openRead());
      stream.cast();
      var length = await Imagefile.length();
      var multiport = http.MultipartFile('imageName[]', stream, length,
          filename: Imagefile.path);
      newList.add(multiport);
    }
    request.files.addAll(newList);

    var response = await request.send();

    print(response.stream.toString());
    if (response.statusCode == 200) {
      print('image uploaded$response');
      // var jsontring = response.;
      // return reposneGeneralFromJson(jsontring);
    } else {
      var reponse_code = response.statusCode;
      print('failed$reponse_code');
    }
  }

//upload profile image
//upload Images
  static Future<ReposneGeneral?> uploadProfileImages(
      String userId, String imgType, String apkiKey, File? imageFile) async {
    var uri = Uri.parse(
            AppConstants.base_api_url + ApiPathsConstant.UPLOADPROFILEIMAGES)
        .replace(queryParameters: {
      "id": userId,
      "image_type": imgType,
    });
    var request = new http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
    });

    File Imagefile = File(imageFile!.path);
    var stream = http.ByteStream(Imagefile.openRead());
    stream.cast();
    var length = await Imagefile.length();
    var multiport =
        http.MultipartFile('logo', stream, length, filename: Imagefile.path);

    request.files.add(multiport);

    var response = await request.send();

    print(response.stream.toString());
    if (response.statusCode == 200) {
      print('profile_image uploaded$response');
      // var jsontring = response.;
      // return reposneGeneralFromJson(jsontring);
    } else {
      var reponse_code = response.statusCode;
      print('failed$reponse_code');
    }
  }

  static Future<SpTopRatedServiceProviders?> getSpForJobs(
      String cityId,
      String jobId,
      String customer,
      String codeLang,
      String userLat,
      String userLng,
      String value,
      String page,
      String apiKey) async {
    var uri =
        Uri.parse("${AppConstants.base_api_url}${ApiPathsConstant.SPFORJOBS}")
            .replace(queryParameters: {
      "city_id": cityId,
      "job_id": jobId,
      "key": customer,
      "lat1": userLat,
      "lng1": userLng,
      "value": value,
      "language": codeLang,
      "page": page,
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return spTopRatedServiceProvidersFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get service provider detail
  static Future<ResponseServiceProviderProfile?> getServiceProviderDetail(
      int spId, int isSp, int language, String apiKey) async {
    var uri =
        Uri.parse("${AppConstants.base_api_url}${ApiPathsConstant.SPDETAIL}")
            .replace(queryParameters: {
      "id": spId,
      "is_service_provider": isSp,
      "language": language,
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return responseServiceProviderProfileFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//creaet new Gig
  static Future<ResponseCreateGig?> createGig(
      QueryCreateGig queryJobDetail, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.CREATEGIG),
        body: queryCreateGigToJson(queryJobDetail),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_create gig");
      var jsontring = response.body;
      return responseCreateGigFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

  //update user skill
  static Future<ReposneGeneral?> updateSkill(
      QueryUpdateSkill queryUpdateSkill, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.UPDATESKILL),
        body: queryUpdateSkillToJson(queryUpdateSkill),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_create gig");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//edit user profile
  static Future<ReposneGeneral?> editProfile(
      QueryEditProfile queryEditProfile, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.EDITPROFILE),
        body: queryEditProfileToJson(queryEditProfile),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_edit_profile");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//process payment
  static Future<ReposneGeneral?> processPayement(
      QueryProcessPayment queryProcessPayment, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.PROCESSPAYMENT),
        body: queryProcessPaymentToJson(queryProcessPayment),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_edit_profile");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get stripe key
  static Future<ResponseGetStripeKey?> getStripeToken(
      QueryGetStripeKey queryGetStripeKey, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.GETSTRIPEKEY),
        body: queryGetStripeKeyToJson(queryGetStripeKey),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_stripe_token");
      var jsontring = response.body;
      return responseGetStripeKeyFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//quick Update User info
  static Future<QuickUpdateResponse?> quickUpdate(
      QueryQuickUpdate queryQuickUpdate, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.QUICKUPDATE),
        body: queryQuickUpdateToJson(queryQuickUpdate),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_stripe_token");
      var jsontring = response.body;
      return quickUpdateResponseFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//update user address
  static Future<ReposneGeneral?> updateAddress(
      QueryUpdateAddress queryUpdateAddress, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.UPDATEADDRESS),
        body: queryUpdateAddressToJson(queryUpdateAddress),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("Resposne_stripe_token");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//read wallet information on base of key
  static Future<WalletResponse?> getPaymentInfo(
      QueryWallet queryWallet, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.PAYMENTINFO),
        body: queryWalletToJson(queryWallet),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("walletResponse");
      var jsontring = response.body;
      return walletResponseFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//read wallet info service provider
//read wallet information on base of key
  static Future<WalletResponseSp?> getPaymentInfoSp(
      QueryWallet queryWallet, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.PAYMENTINFO),
        body: queryWalletToJson(queryWallet),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("walletResponse");
      var jsontring = response.body;
      return walletResponseSpFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//set phone permission
  static Future<ReposneGeneral?> setPhonePermission(
      QueryChangePermission queryChangePermission, String apkiKey) async {
    var response = await client.post(
        Uri.parse(
            AppConstants.base_api_url + ApiPathsConstant.SETPHONEPERMISSION),
        body: queryChangePermissionToJson(queryChangePermission),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//check is phone permission avaiable or not
  static Future<ResponseCheckPermission?> isPhoneEnabled(
      QueryIsPhoneStatus queryIsPhoneStatus, String apkiKey) async {
    var response = await client.post(
        Uri.parse(
            AppConstants.base_api_url + ApiPathsConstant.CHECKPHONEPERMISSION),
        body: queryIsPhoneStatusToJson(queryIsPhoneStatus),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return responseCheckPermissionFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//change language on basis of switch
  static Future<ReposneGeneral?> changeLanguage(
      QueryChangeLanguage queryChangeLanguage, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.CHANGELANGUAGE),
        body: queryChangeLanguageToJson(queryChangeLanguage),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

  //post review
  static Future<ResponsePostReview?> postReview(
      QuerypostReview querypostReview, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.POSTREVIEW),
        body: querypostReviewToJson(querypostReview),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return responsePostReviewFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

// check jobs vs service provider
  static Future<ResponsePostJobVsServiceProvider?> checkJobsVsServiceProviders(
      QueryPostJobVsServiceProvider queryPostJobVsServiceProvider,
      String apkiKey) async {
    var response = await client.post(
        Uri.parse(
            AppConstants.base_api_url + ApiPathsConstant.POSTEDJOBSVSPROVIDER),
        body:
            queryPostJobVsServiceProviderToJson(queryPostJobVsServiceProvider),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return responsePostJobVsServiceProviderFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//get jobs summary
  static Future<ResponseMyJobsSummary?> getJobsSummary(
      QueryMyJobsSummary queryMyJobsSummary, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url +
            ApiPathsConstant.GETALLCUSTOMEROPENJOBS),
        body: queryMyJobsSummaryToJson(queryMyJobsSummary),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return responseMyJobsSummaryFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//invite on job
  static Future<ReposneGeneral?> inviteOnJob(
      QueryInviteOnJob queryInviteOnJob, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.INVITEONJOB),
        body: queryInviteOnJobToJson(queryInviteOnJob),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("user_invited${response.body}");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//direct job creation
  static Future<ResponseDirectJobCreation?> createJobCreation(
      QueryDirectJobCreation queryDirectJobCreation, String apkiKey) async {
    var response = await client.post(
        Uri.parse(
            AppConstants.base_api_url + ApiPathsConstant.DIRECTJOBCREATION),
        body: queryDirectJobCreationToJson(queryDirectJobCreation),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return responseDirectJobCreationFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//search all jobs
  static Future<JobsModel?> makeSimpleSearchJobs(String cityId, String codeLang,
      String page, String apiKey, double lat, double lng, String value) async {
    var uri =
        Uri.parse("${AppConstants.base_api_url}${ApiPathsConstant.SEARCHALL}")
            .replace(queryParameters: {
      "city_id": cityId,
      "key": "serviceprovider",
      "language": codeLang,
      "lat1": lat.toString(),
      "lng1": lng.toString(),
      "value": value,
      "page": page
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return jobsModelFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//search job by profession
  static Future<JobsModel?> seachJobByProfession(
      String cityId,
      String codeLang,
      String page,
      String apiKey,
      double lat,
      double lng,
      String professionValue) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.SEARCHBYPROFESSION}")
        .replace(queryParameters: {
      "city_id": cityId,
      "key": "serviceprovider",
      "language": codeLang,
      "lat1": lat.toString(),
      "lng1": lng.toString(),
      "profession": professionValue,
      "page": page
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return jobsModelFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//search service provider
  static Future<ResponseSearchAllServiceProviders?>
      makeSimpleSearchServiceProvider(
          String cityId,
          String codeLang,
          String page,
          String apiKey,
          double lat,
          double lng,
          String value) async {
    var uri =
        Uri.parse("${AppConstants.base_api_url}${ApiPathsConstant.SEARCHALL}")
            .replace(queryParameters: {
      "city_id": cityId,
      "key": "customer",
      "language": codeLang,
      "lat1": lat.toString(),
      "lng1": lng.toString(),
      "value": value,
      "page": page
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return responseSearchAllServiceProvidersFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//make api call for custom search service Provider
  static Future<ResponseSearchAllServiceProviders?>
      getCustomerSearchResultForServiceProvider(
          String language,
          String lat1,
          String lng1,
          String profession,
          String skills,
          String serachField,
          String apiKey,
          String page,
          int search_distance) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.CUSTOMSEARCH}")
        .replace(queryParameters: {
      "keyword": "provider",
      "language": language,
      "lat1": lat1,
      "lng1": lng1,
      "profession": profession,
      "skills": skills,
      "value": serachField,
      "page": page,
      "search_distance": search_distance.toString()
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      print("Resposne_Received_customer");
      var jsontring = response.body;
      return responseSearchAllServiceProvidersFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//make customer search for jobs
  static Future<JobsModel?> getCustomSearchJobs(
      String language,
      String lat1,
      String lng1,
      String profession,
      String skills,
      String serachField,
      String apiKey,
      int search_distance,
      String page) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.CUSTOMSEARCH}")
        .replace(queryParameters: {
      "keyword": "customer",
      "language": language,
      "lat1": lat1,
      "lng1": lng1,
      "profession": profession,
      "skills": skills,
      "value": serachField,
      "page": page,
      "search_distance": search_distance.toString()
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return jobsModelFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//search service provider by profession
  static Future<ResponseSearchAllServiceProviders?> searchSpByProfessions(
      String cityId,
      String codeLang,
      String page,
      String apiKey,
      double lat,
      double lng,
      String professionValue) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.SEARCHBYPROFESSION}")
        .replace(queryParameters: {
      "city_id": cityId,
      "key": "customer",
      "language": codeLang,
      "lat1": lat.toString(),
      "lng1": lng.toString(),
      "profession": professionValue,
      "page": page
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return responseSearchAllServiceProvidersFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//read service provider information
  static Future<ResposneServiceProviderProfile?> readServiceProviderProfile(
      String userId,
      String isServiceProvider,
      String language,
      String apiKey,
      String lat,
      String lng) async {
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.SERVICEPROVIDERPROFILE}")
        .replace(queryParameters: {
      "id": userId,
      "language": language,
      "is_service_provider": isServiceProvider,
      "lat1": lat,
      "lng1": lng
    });
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      // print("Resposne_Received");
      var jsontring = response.body;
      return resposneServiceProviderProfileFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//delete job
  static Future<ResponseDirectJobCreation?> deleteJob(
      QueryDeleteJob queryDeleteJob, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.DELETJOB),
        body: queryDeleteJobToJson(queryDeleteJob),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("upate_phone_permission");
      var jsontring = response.body;
      return responseDirectJobCreationFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//edit gig
  static Future<ResponseEditGig?> editGig(
      QueryEditGig queryEditGig, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.EDITGIG),
        body: queryEditGigToJson(queryEditGig),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("update_gig_info");
      var jsontring = response.body;
      return responseEditGigFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//read single Gig
  static Future<ResponseReadSingleGigDetail?> readSingleGigDetai(
      QueryReadSingleGigDetail queryReadSingleGigDetail, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.READGIGDETAIL),
        body: queryReadSingleGigDetailToJson(queryReadSingleGigDetail),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("update_gig_info");
      var jsontring = response.body;
      return responseReadSingleGigDetailFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }

//disable user
  static Future<ResponseDiableUser?> disableOrDeleteMyAccount(
      QuerDiableUser querDiableUser, String apkiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.DISABLECOUNT),
        body: querDiableUserToJson(querDiableUser),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": AppConstants.AUTHOEIZATION_BEARER + apkiKey
        });
    if (response.statusCode == 200) {
      print("update_gig_info");
      var jsontring = response.body;
      return responseDiableUserFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }
//log event
  static Future<ReposneGeneral?> logEvent(
      QueryLogEvent queryLogEvent, String apiKey) async {
    var response = await client.post(
        Uri.parse(AppConstants.base_api_url + ApiPathsConstant.QUERYLOGEVENT),
        body: queryLogEventToJson(queryLogEvent),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
          "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
        });
    if (response.statusCode == 200) {
      print("Resposne_logEvent");
      var jsontring = response.body;
      return reposneGeneralFromJson(jsontring);
    } else {
      print("Not_Received${response.statusCode}");
      return null;
    }
  }
}
