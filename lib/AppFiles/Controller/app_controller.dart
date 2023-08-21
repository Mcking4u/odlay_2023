import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/firebase_realtime_database.dart';
import 'package:odlay_services/AppFiles/Services/remote_services.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_change_job_status.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_query_apply_job.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_query_edit_proposal.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/_reponse_apply_job.dart';
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
import 'package:odlay_services/AppFiles/model/WalletModel/_query_wallet.dart';
import 'package:odlay_services/AppFiles/model/WalletModel/_wallet_response.dart';
import 'package:odlay_services/AppFiles/model/WalletModelSp/_wallets_response_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/AuthPages/enter_phone.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/customerJobDetail/_customer_job_detail.dart';

import '../model/LogEvents/query_log_event.dart';

class AppController extends GetxController {
  var skillCitiesProfessionsValue = false.obs;
  JobsModel? jobsModel;
  var isLoadingJobsModel = true.obs;

  JobsModel? jobsModelViewAll;
  var isLoadingJobsModelViewAlll = true.obs;
  var isLoadingJobsModelViewAlllMore = true.obs;

  TopRatedServiceProviders? topRatedServiceProviders;
  var isLoadingTopRatedServiceProvider = true.obs;

  TopRatedServiceProviders? viewAllServiceProviders;
  var isLoadingViewAllServiceProvider = true.obs;
  var isLoadingViewAllMoreServiceProvider = true.obs;

  SpTopRatedServiceProviders? SpRecomdedtopRatedServiceProviders;
  var isLoadingRecomServiceProvider = true.obs;

  ResponsePostJob? responsePostJob;
  var responsePostJobLoading = false.obs;
  var responseEditJobLoading = false.obs;
  var jobPostedSuccessfully = false.obs;
  ReposneGeneral? generalResponse;

  late ResponseCheckPermission responseCheckPermission;

  var responseApplyJobLoading = false.obs;
  var responseEditProposalLoading = false.obs;
  late List<ResponseCustomersShowJobs> responseCustomersShowJobs;
  var responseCustomersShowJobsLoading = false.obs;
  late ServiceproviderJobsShowResponse? serviceproviderJobsShowResponse;
  var serviceproviderJobsShowResponseLoading = false.obs;
  late ResponseFeaturedGigs? responseFeaturedGigs;
  var isLoadingFeaturedGigs = true.obs;

  late ResponseFeaturedGigs? responseViewAllGigs;
  var isresponseViewAllGigs = true.obs;

  ResponseJobDetail? responseJobDetail;
  var isJobDetailLoading = true.obs;
  ResponseLoginUser? responseLoginUser;
  SkillCitiesProfessions? skillCitiesProfessions;

  ResponseServiceProviderProfile? _serviceProviderProfile;
  var isLoadingServiceProviderProfile = false.obs;
  ResponseCreateGig? responseCreateGig;
  var isLoadingResponseCreateGig = false.obs;
  var updatingSkill = false.obs;
  var updatingProfile = false.obs;
  var responseChangeJobStatus = false.obs;
  late QuickUpdateResponse quickUpdateResponse;
  late ResponseGetStripeKey responseGetStripeKey;
  var isGettingStripeKey = true.obs;
  var isPaymentProcessedSuccessfull = false.obs;
//payment variables cust
  late WalletResponse walletResponseCust;
  var walletResponseValueCust = false.obs;
//payment variables sp
  late WalletResponseSp walletResponseSp;
  var walletResponseValueSp = false.obs;

  late ResponsePostReview responsePostReview;
  var responsePostReviewValue = false.obs;

  late ResponsePostJobVsServiceProvider responsePostJobVsServiceProvider;
  late ResponseMyJobsSummary responseMyJobsSummary;
  var responseMyJobsSummaryValue = false.obs;
  late ResponseDirectJobCreation responseDirectJobCreation;
  var responseDirectJobCreationValue = false.obs;
  late ResponseSearchAllServiceProviders responseSearchAllServiceProviders;
  var responseSearchAllServiceProvidersValue = false.obs;
  var responseSearchAllServiceProvidersValueMore = false.obs;
  JobsModel? searchJobsModel;
  var searchJobsModelValue = false.obs;
  var searchJobsModelValueMore = false.obs;

  late ResposneServiceProviderProfile resposneServiceProviderProfile;
  var resposneServiceProviderProfileValue = false.obs;

  late ResponseEditGig responseEditGig;
  late ResponseReadSingleGigDetail readSingleGigDetail;
  var readSingleGigDetailValue = false.obs;

  late ResponseDiableUser responseDiableUser;

  FirebaseRealtimeDatabaseController _firebaseRealtimeDatabaseController =
      Get.put(FirebaseRealtimeDatabaseController());

  void readSkillCities(int? langaugeCode, String apiKey) async {
    print("ReadSkillsKey${apiKey}");
    try {
      skillCitiesProfessionsValue(true);
      var skillCitiesReponse =
          await RemoteServices.getSkillCitiesProfessiona(langaugeCode, apiKey);
      if (skillCitiesReponse != null) {
        skillCitiesProfessions = skillCitiesReponse;
      } else {}
    } catch (e) {
      print("SkillCityException${e}");
    } finally {
      skillCitiesProfessionsValue(false);
    }
  }

  void getLatestJob(String cityId, String langaugeCode, String page,
      String apiKey, String lat, String lng) async {
    isLoadingJobsModel(true);
    try {
      var jobsReponse = await RemoteServices.getLatestJobs(
          cityId, langaugeCode, page, apiKey, lat, lng);
      if (jobsReponse != null) {
        jobsModel = jobsReponse;
      } else {}
    } catch (e) {
      print("LatestPostedJobs${e}");
    } finally {
      isLoadingJobsModel(false);
    }
  }
//view all paginated jobs

  void getAllJobs(String cityId, String langaugeCode, String page,
      String apiKey, String lat, String lng) async {
    if (int.parse(page) == 1) {
      isLoadingJobsModelViewAlll(true);
    } else {
      isLoadingJobsModelViewAlllMore(true);
    }

    try {
      var jobsReponse = await RemoteServices.viewAllJobs(
          cityId, langaugeCode, page, apiKey, lat, lng);
      if (jobsReponse != null) {
        if (int.parse(page) > 1) {
          jobsModelViewAll!.data.addAll(jobsReponse.data);
        } else {
          jobsModelViewAll = jobsReponse;
        }
      } else {}
    } catch (e) {
      print("LatestPostedJobs${e}");
    } finally {
      if (int.parse(page) == 1) {
        isLoadingJobsModelViewAlll(false);
      } else {
        isLoadingJobsModelViewAlllMore(false);
      }
    }
  }

  Future updateProfile(String userId, int? langCode, String apiKey) async {
    try {
      var updatetProfileReponse =
          await RemoteServices.updatedProfile(userId, langCode, apiKey);
      if (updatetProfileReponse != null) {
        responseLoginUser = updatetProfileReponse;
        if (responseLoginUser!.user.logoutUser == 1) {
          Constants.sharedPreferences.setBool("isLoggedIn", false);
          Constants.sharedPreferences.clear();
          Navigator.pushAndRemoveUntil(
            AppConstants.baseContext,
            MaterialPageRoute(builder: (context) => EnterPhone()),
            (Route<dynamic> route) => false,
          );
        }
      } else {}
    } catch (e) {
      print("updatedProfileException${e}");
    } finally {}
  }

  void getTopRatedSerViceProvider(String cityId, String langaugeCode,
      String page, String apiKey, String lat, String lng) async {
    isLoadingTopRatedServiceProvider(true);
    try {
      var topRatedReponse = await RemoteServices.getServiceProviders(
          cityId, langaugeCode, page, apiKey, lat, lng);
      if (topRatedReponse != null) {
        topRatedServiceProviders = topRatedReponse;
      } else {}
    } catch (e) {
      print("TopRated${e}");
    } finally {
      isLoadingTopRatedServiceProvider(false);
    }
  }
//view all service provider on base of city

  void viewAllServiceProvider(String cityId, String langaugeCode, String page,
      String apiKey, String lat, String lng) async {
    if (int.parse(page) == 1) {
      isLoadingViewAllServiceProvider(true);
    } else {
      isLoadingViewAllMoreServiceProvider(true);
    }
    try {
      var topRatedReponse = await RemoteServices.viewAllServiceProvider(
          cityId, langaugeCode, page, apiKey, lat, lng);
      if (topRatedReponse != null) {
        if (int.parse(page) > 1) {
          viewAllServiceProviders!.serviceproviders.data
              .addAll(topRatedReponse.serviceproviders.data);
        } else {
          viewAllServiceProviders = topRatedReponse;
        }
      } else {}
    } catch (e) {
      print("TopRated${e}");
    } finally {
      if (int.parse(page) == 1) {
        isLoadingViewAllServiceProvider(false);
      } else {
        isLoadingViewAllMoreServiceProvider(false);
      }
    }
  }

  Future postJob(
      QueryPostJob queryPostJob, String apiKey, BuildContext context) async {
    try {
      responsePostJobLoading(true);
      var response = await RemoteServices.postJob(queryPostJob, apiKey);
      if (response != null) {
        responsePostJob = response;
        if (responsePostJob!.status == "success") {
          print("JobPostedSuccessfully");
        } else {}
      } else {}
    } catch (e) {
      print("PostJob${e}");
    } finally {
      responsePostJobLoading(false);
    }
  }

  Future editJob(
      QuerEditJob queryEditJob, String apiKey, BuildContext context) async {
    try {
      responseEditJobLoading(true);
      var response = await RemoteServices.editJob(queryEditJob, apiKey);
      if (response != null) {
        responsePostJob = response;
        if (responsePostJob!.status == "success") {
          print("JobPostedSuccessfully");
        } else {}
      } else {}
    } catch (e) {
      print("PostJob${e}");
    } finally {
      responseEditJobLoading(false);
    }
  }

  Future applyJob(
      QueryApplyJob queryApplyJob,
      String apiKey,
      String current_user_Id,
      String other_user_id,
      String messageTitleCurrent,
      String notification_title,
      String notification_type,
      String messageTitleOther,
      BuildContext context) async {
    try {
      responseApplyJobLoading(true);
      var response = await RemoteServices.applyJob(queryApplyJob, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("JobApplySuccessfully");
          showToast("Job applied Successfull please check in job Manager",
              context: context, backgroundColor: Colors.green);
          _firebaseRealtimeDatabaseController.sendJobMessage(
              current_user_Id,
              other_user_id,
              messageTitleCurrent,
              notification_type,
              notification_title,
              messageTitleOther);
        } else {
          showToast(generalResponse!.message.toString(),
              context: context, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to Apply",
            context: context, backgroundColor: Colors.red);
      }
    } catch (e) {
      showToast("Unable to Apply",
          context: context, backgroundColor: Colors.red);
    } finally {
      responseApplyJobLoading(false);
    }
  }

//edit proposal
  Future editProposal(
      QuerEditProposal queryApplyJob,
      String apiKey,
      String current_user_Id,
      String other_user_id,
      String messageTitleCurrent,
      String notification_title,
      String notification_type,
      String messageTitleOther,
      BuildContext context) async {
    try {
      responseEditProposalLoading(true);
      var response = await RemoteServices.editProposal(queryApplyJob, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("JobProposalEditSuccessfully");

          _firebaseRealtimeDatabaseController.sendJobMessage(
              current_user_Id,
              other_user_id,
              messageTitleCurrent,
              notification_type,
              notification_title,
              messageTitleOther);
        } else {
          showToast("Unable to Update Bid Amount",
              context: context, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to Apply",
            context: context, backgroundColor: Colors.red);
      }
    } catch (e) {
      showToast("Unable to Apply",
          context: context, backgroundColor: Colors.red);
    } finally {
      responseEditProposalLoading(false);
    }
  }

  Future changeJobStatus(
      QueryChangeJobStatus queryChangeJobStatus,
      String apiKey,
      String current_user_Id,
      String other_user_id,
      String messageTitleCurrent,
      String notification_type,
      String notification_title,
      String messageTitleOther,
      BuildContext context) async {
    try {
      print("OtherUserId$other_user_id");
      print("CurrentUserID$current_user_Id");
      responseChangeJobStatus(true);
      var response =
          await RemoteServices.changeJobStatus(queryChangeJobStatus, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("JobStatusChange");

          _firebaseRealtimeDatabaseController.sendJobMessage(
              current_user_Id,
              other_user_id,
              messageTitleCurrent,
              notification_type,
              notification_title,
              messageTitleOther);
        }
      } else {}
    } catch (e) {
      print("SkillCityException${e}");
    } finally {
      responseChangeJobStatus(false);
    }
  }

  Future getCustomerJobs(QueryCustomersShowJobs queryCustomersShowJobs,
      String apiKey, bool is_mainCall) async {
    try {
      if (is_mainCall) {
        responseCustomersShowJobsLoading(true);
      }
      var response =
          await RemoteServices.getCustomerJobs(queryCustomersShowJobs, apiKey);
      if (response != null) {
        responseCustomersShowJobs = response;
        if (responseCustomersShowJobs.isNotEmpty) {
          manageJobsCustomer(responseCustomersShowJobs);
        }
      } else {}
    } catch (e) {
      print("CustomerJobException${e}");
    } finally {
      if (is_mainCall) {
        responseCustomersShowJobsLoading(false);
      }
    }
  }

  void manageJobsCustomer(
      List<ResponseCustomersShowJobs> responseCustomersShowJobs) {
    JobConstants.list_cus_open_jobs.clear();
    JobConstants.list_cus_started_jobs.clear();
    JobConstants.list_cus_closed_jobs.clear();
    for (var job in responseCustomersShowJobs) {
      if (job.status! < JobConstants.HIRED_STATUS ||
          job.status == JobConstants.INVITED_FOR_JOB) {
        JobConstants.list_cus_open_jobs.add(job);
      } else if (job.status! >= JobConstants.HIRED_STATUS &&
              job.status! <= JobConstants.DELIVERED_STATUS ||
          job.status == JobConstants.SP_ACCEPTED ||
          job.status == JobConstants.DISPUTED_STATUS ||
          job.status == JobConstants.PAYMENTDONE) {
        JobConstants.list_cus_started_jobs.add(job);
      } else {
        JobConstants.list_cus_closed_jobs.add(job);
      }
    }
  }

  Future getSpAppliedJobs(
      ServiceproviderJobsShowQuery serviceproviderJobsShowQuery,
      String apiKey,
      bool isCallFromMain) async {
    try {
      if (isCallFromMain) {
        serviceproviderJobsShowResponseLoading(true);
      }
      var response = await RemoteServices.getServiceProviderAppliedJobs(
          serviceproviderJobsShowQuery, apiKey);
      if (response != null) {
        serviceproviderJobsShowResponse = response;
        if (serviceproviderJobsShowResponse!.applied.isNotEmpty) {
          manageJobsServiceProvider(serviceproviderJobsShowResponse);
        }
      } else {}
    } catch (e) {
      print("SkillCityException${e}");
    } finally {
      if (isCallFromMain) {
        serviceproviderJobsShowResponseLoading(false);
      }
    }
  }

  void manageJobsServiceProvider(
      ServiceproviderJobsShowResponse? serviceproviderJobsShowResponse) {
    JobConstants.list_sp_applied_jobs.clear();
    JobConstants.list_sp_started_jobs.clear();
    JobConstants.list_sp_closed_jobs.clear();
    for (var job in serviceproviderJobsShowResponse!.applied) {
      if (job.status! >= JobConstants.NOT_VIEWED_STATUS &&
              job.status! <= JobConstants.SHORTLISTED_STATUS ||
          job.status == JobConstants.HIRED_STATUS ||
          job.status == JobConstants.USER_APPLIED_TO_OPEN_JOB ||
          job.status == JobConstants.INVITED_FOR_JOB ||
          job.status == JobConstants.SP_ACCEPTED ||
          job.status == JobConstants.USER_APPLIED_AFTER_INVITATION ||
          job.status == JobConstants.PAYMENTDONE) {
        JobConstants.list_sp_applied_jobs.add(job);
      } else if (job.status! >= JobConstants.STARTED_STATUS &&
              job.status! <= JobConstants.DELIVERED_STATUS ||
          job.status == JobConstants.DISPUTED_STATUS) {
        JobConstants.list_sp_started_jobs.add(job);
      } else if (job.status == JobConstants.COMPLETED_STATUS ||
          job.status == JobConstants.CANCELED_STATUS ||
          job.status == JobConstants.APPLICANT_WITHDRAW_REQUEST||
          job.status == JobConstants.APPLICANT_UNSUCCESSFULL||
          job.status == JobConstants.COMPLETED_Job_REVIEWE_DONE) {
        JobConstants.list_sp_closed_jobs.add(job);
      }
    }
  }

  void getFeaturedGigs(
      QueryTopRatedGigsModle queryTopRatedGigsModle, String apiKey) async {
    try {
      isLoadingFeaturedGigs(true);
      var response =
          await RemoteServices.getFeaturedGigs(queryTopRatedGigsModle, apiKey);
      if (response != null) {
        responseFeaturedGigs = response;
      } else {}
    } catch (e) {
      print("SkillCityException${e}");
    } finally {
      isLoadingFeaturedGigs(false);
    }
  }
//view All Gigs

  void getAllCityRelatedGigs(
      QueryTopRatedGigsModle queryTopRatedGigsModle, String apiKey) async {
    try {
      isresponseViewAllGigs(true);
      var response =
          await RemoteServices.viewAllGigs(queryTopRatedGigsModle, apiKey);
      if (response != null) {
        print("ViewAllGigsRecived");
        responseViewAllGigs = response;
      } else {}
    } catch (e) {
      print("ViewAllGigsException${e}");
    } finally {
      isresponseViewAllGigs(false);
    }
  }

  void getJobDetail(QueryJobDetail queryJobDetail, String apiKey) async {
    isJobDetailLoading(true);
    try {
      var response = await RemoteServices.getJobDetail(queryJobDetail, apiKey);
      if (response != null) {
        responseJobDetail = response;
      } else {}
    } catch (e) {
      print("SkillCityException${e}");
    } finally {
      isJobDetailLoading(false);
    }
  }

  void getSkillRecomendedJob(
      String cityId,
      String jobId,
      String customer,
      String codeLang,
      String userLat,
      String userLng,
      String value,
      String page,
      String apiKey) async {
    isLoadingRecomServiceProvider(true);
    try {
      var topRatedReponse = await RemoteServices.getSpForJobs(cityId, jobId,
          customer, codeLang, userLat, userLng, value, page, apiKey);
      if (topRatedReponse != null) {
        SpRecomdedtopRatedServiceProviders = topRatedReponse;
      } else {}
    } catch (e) {
      print("RecomedndTopRated${e}");
    } finally {
      isLoadingRecomServiceProvider(false);
    }
  }

  void getServiceProviderDetail(
      int spId, int isSp, int language, String apiKey) async {
    isLoadingRecomServiceProvider(true);
    try {
      isLoadingServiceProviderProfile(true);
      var serviceProviderDetail = await RemoteServices.getServiceProviderDetail(
          spId, isSp, language, apiKey);
      if (serviceProviderDetail != null) {
        _serviceProviderProfile = serviceProviderDetail;
      } else {}
    } catch (e) {
      print("TopRated${e}");
    } finally {
      isLoadingServiceProviderProfile(false);
    }
  }

//create gig
  Future createNewGig(QueryCreateGig queryCreateGig, String apiKey) async {
    isLoadingResponseCreateGig(true);
    try {
      var response = await RemoteServices.createGig(queryCreateGig, apiKey);
      if (response != null) {
        responseCreateGig = response;
      } else {}
    } catch (e) {
      print("SkillCityException${e}");
    } finally {
      isLoadingResponseCreateGig(false);
    }
  }

//update skill
  Future updateUserSkills(
      QueryUpdateSkill queryUpdateSkill, String apiKey) async {
    try {
      updatingSkill(true);

      var response = await RemoteServices.updateSkill(queryUpdateSkill, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("SkillUpdted");
        } else {}
      } else {}
    } catch (e) {
      print("updating_skill${e}");
    } finally {
      updatingSkill(false);
    }
  }

//edit_profile
  Future editProfile(QueryEditProfile queryEditProfile, String apiKey) async {
    try {
      updatingProfile(true);
      var response = await RemoteServices.editProfile(queryEditProfile, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("ProfileUpdted");
          await updateProfile(queryEditProfile.id.toString(),
              responseLoginUser!.user.language, apiKey);
        } else {}
      } else {}
    } catch (e) {
      print("updating_skill${e}");
    } finally {
      updatingProfile(false);
    }
  }

  //Process payment
  Future processPayment(
    QueryProcessPayment queryProcessPayment,
    String apiKey,
  ) async {
    try {
      isPaymentProcessedSuccessfull(true);
      var response =
          await RemoteServices.processPayement(queryProcessPayment, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("paymentprocesed");
        } else {}
      } else {}
    } catch (e) {
      print("updating_skill${e}");
    } finally {
      isPaymentProcessedSuccessfull(false);
    }
  }

//get stripe key
  Future getStripeKey(
      QueryGetStripeKey queryGetStripeKey, String apiKey) async {
    try {
      isGettingStripeKey(true);
      var response =
          await RemoteServices.getStripeToken(queryGetStripeKey, apiKey);
      if (response != null) {
        responseGetStripeKey = response;
        // if (generalResponse!.status == "success") {
        print("StripeToken");
        // } else {}
      } else {}
    } catch (e) {
      print("stripeTokenException${e}");
    } finally {
      isGettingStripeKey(false);
    }
  }

  //upload images
  Future uploadImages(String desId, String imgType, String delImages,
      String apiKey, List<File>? imageFileList) async {
    try {
      var response = await RemoteServices.uploadImages(
          desId, imgType, delImages, apiKey, imageFileList);
      if (response != null) {
        generalResponse = response;
        // if (generalResponse!.status == "success") {
        print("ImageUploaded");
        // } else {}
      } else {}
    } catch (e) {
      print("updating_skill${e}");
    } finally {
      isPaymentProcessedSuccessfull(false);
    }
  }

//update profile image
  Future uploadProfilImages(
      String userId, String imgType, String apiKey, File imgFile) async {
    try {
      var response = await RemoteServices.uploadProfileImages(
          userId, imgType, apiKey, imgFile);

      if (response != null) {
        generalResponse = response;
        // if (generalResponse!.status == "success") {
        print("ProfileImageUploaded");
        // } else {}
      } else {}
    } catch (e) {
      print("updating_skill${e}");
    } finally {
      isPaymentProcessedSuccessfull(false);
    }
  }

//controller quick update user detail
  Future quickUpdate(QueryQuickUpdate queryQuickUpdate, String apiKey) async {
    try {
      var response = await RemoteServices.quickUpdate(queryQuickUpdate, apiKey);
      if (response != null) {
        quickUpdateResponse = response;
        if (quickUpdateResponse.status == "success") {
          print("AddressUpdate");
        } else {}
      } else {}
    } catch (e) {
      print("QucikUpdateException${e}");
    } finally {}
  }

//Controller Update Address
  Future updateAddress(
      QueryUpdateAddress queryUpdateAddress, String apiKey) async {
    try {
      var response =
          await RemoteServices.updateAddress(queryUpdateAddress, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("AddressUpdate");
        } else {}
      } else {}
    } catch (e) {
      print("QucikUpdateException${e}");
    } finally {}
  }

//get payment info
  Future getWalletInfoCustomer(QueryWallet queryWallet, String apiKey) async {
    try {
      walletResponseValueCust(true);
      var response = await RemoteServices.getPaymentInfo(queryWallet, apiKey);
      if (response != null) {
        walletResponseCust = response;
      } else {}
    } catch (e) {
      print("walletInfoException${e}");
    } finally {
      walletResponseValueCust(false);
    }
  }

//get payment info service provider
  Future getWalletInfoSp(QueryWallet queryWallet, String apiKey) async {
    try {
      walletResponseValueSp(true);
      var response = await RemoteServices.getPaymentInfoSp(queryWallet, apiKey);
      if (response != null) {
        walletResponseSp = response;
      } else {}
    } catch (e) {
      print("walletInfoException${e}");
    } finally {
      walletResponseValueSp(false);
    }
  }

//set phone permission
  Future setPhonePermission(
      QueryChangePermission queryChangePermission, String apiKey) async {
    try {
      var response = await RemoteServices.setPhonePermission(
          queryChangePermission, apiKey);
      if (response != null) {
        generalResponse = response;
      } else {}
    } catch (e) {
      print("setPhonePermissionException${e}");
    } finally {}
  }

//check phone permission
  Future checkPhonePermission(
      QueryIsPhoneStatus queryIsPhoneStatus, String apiKey) async {
    try {
      var response =
          await RemoteServices.isPhoneEnabled(queryIsPhoneStatus, apiKey);
      if (response != null) {
        responseCheckPermission = response;
      } else {}
    } catch (e) {
      print("CheckPhoneException${e}");
    } finally {}
  }

//change app language
  Future changeLanguage(
      QueryChangeLanguage queryChangeLanguage, String apiKey) async {
    try {
      var response =
          await RemoteServices.changeLanguage(queryChangeLanguage, apiKey);
      if (response != null) {
        generalResponse = response;
      } else {}
    } catch (e) {
      print("ChangeLangaugeException${e}");
    } finally {}
  }

//post review
  Future postReview(QuerypostReview querypostReview, String apiKey) async {
    try {
      responsePostReviewValue(true);
      var response = await RemoteServices.postReview(querypostReview, apiKey);
      if (response != null) {
        responsePostReview = response;
      } else {}
    } catch (e) {
      print("PostReviewExceptio${e}");
    } finally {
      responsePostReviewValue(false);
    }
  }

// check jobs vs service provider
  Future checkJobServiceProvider(
      QueryPostJobVsServiceProvider queryPostJobVsServiceProvider,
      String apiKey) async {
    try {
      var response = await RemoteServices.checkJobsVsServiceProviders(
          queryPostJobVsServiceProvider, apiKey);
      if (response != null) {
        responsePostJobVsServiceProvider = response;
      } else {}
    } catch (e) {
      print("CheckServiceProviderVsJobException${e}");
    } finally {}
  }

//get customer jobs summary
  Future getCustomerJobsSummary(
      QueryMyJobsSummary queryMyJobsSummary, String apiKey) async {
    try {
      responseMyJobsSummaryValue(true);
      var response =
          await RemoteServices.getJobsSummary(queryMyJobsSummary, apiKey);
      if (response != null) {
        print("JobSummaryreceived");
        responseMyJobsSummary = response;
      } else {}
    } catch (e) {
      print("getCustomerJobsSummary${e}");
    } finally {
      responseMyJobsSummaryValue(false);
    }
  }

  //invite on job
  Future inviteSpOnJob(
      QueryInviteOnJob queryInviteOnJob,
      String apiKey,
      String current_user_Id,
      String other_user_id,
      String messageTitleCurrent,
      String notification_title,
      String notification_type,
      String messageTitleOther,
      BuildContext context) async {
    try {
      var response = await RemoteServices.inviteOnJob(queryInviteOnJob, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status.toString().toLowerCase() == "success") {
          print("JobApplySuccessfully");
          _firebaseRealtimeDatabaseController.sendJobMessage(
              current_user_Id,
              other_user_id,
              messageTitleCurrent,
              notification_type,
              notification_title,
              messageTitleOther);
        } else {
          showToast("Unable to Invite",
              context: context, backgroundColor: Colors.red);
        }
        print("user_appController");
      } else {}
    } catch (e) {
      print("inviteSpOnJob${e}");
    } finally {}
  }

  //dire job creation
  Future directJobCreation(
      QueryDirectJobCreation queryDirectJobCreation,
      String apiKey,
      String current_user_Id,
      String other_user_id,
      String messageTitleCurrent,
      String notification_type,
      String notification_title,
      String messageTitleOther,
      BuildContext context) async {
    try {
      var response = await RemoteServices.createJobCreation(
          queryDirectJobCreation, apiKey);
      if (response != null) {
        responseDirectJobCreation = response;
        if (responseDirectJobCreation.status == "success") {
          _firebaseRealtimeDatabaseController.sendJobMessage(
              current_user_Id,
              other_user_id,
              messageTitleCurrent,
              notification_type,
              notification_title,
              messageTitleOther);
        }
      } else {}
    } catch (e) {
      print("directJobCreation${e}");
    } finally {}
  }

//read search service provider and related gigs
  void readSearchServiceProviderAndGigs(String cityId, String codeLang,
      String page, String apiKey, double lat, double lng, String value) async {
    try {
      if (int.parse(page) == 1) {
        responseSearchAllServiceProvidersValue(true);
      } else {
        responseSearchAllServiceProvidersValueMore(true);
      }
      var serviceProviderAndGigs =
          await RemoteServices.makeSimpleSearchServiceProvider(
              cityId, codeLang, page, apiKey, lat, lng, value);

      if (serviceProviderAndGigs != null) {
        print("SearchResultFound");
        if (int.parse(page) > 1) {
          responseSearchAllServiceProviders.serviceproviders.data
              .addAll(serviceProviderAndGigs.serviceproviders.data);
        } else {
          responseSearchAllServiceProviders = serviceProviderAndGigs;
        }
      } else {}
    } catch (e) {
      print("readSearchServiceProviderAndGigs${e}");
    } finally {
      if (int.parse(page) == 1) {
        responseSearchAllServiceProvidersValue(false);
      } else {
        responseSearchAllServiceProvidersValueMore(false);
      }
    }
  }

//custom search  service
  void searchCustomServiceProvider(
      String language,
      String lat1,
      String lng1,
      String profession,
      String skills,
      String serachField,
      String apiKey,
      int search_distance,
      String page) async {
    try {
      if (int.parse(page) == 1) {
        responseSearchAllServiceProvidersValue(true);
      } else {
        responseSearchAllServiceProvidersValueMore(true);
      }
      var serviceProviderAndGigs =
          await RemoteServices.getCustomerSearchResultForServiceProvider(
              language,
              lat1,
              lng1,
              profession,
              skills,
              serachField,
              apiKey,
              page,
              search_distance);

      if (serviceProviderAndGigs != null) {
        print("SearchResultFoundCustom");
        if (int.parse(page) > 1) {
        } else {
          if (int.parse(page) > 1) {
            responseSearchAllServiceProviders.serviceproviders.data
                .addAll(serviceProviderAndGigs.serviceproviders.data);
          } else {
            responseSearchAllServiceProviders = serviceProviderAndGigs;
          }
        }
      } else {}
    } catch (e) {
      print("readSearchServiceProviderAndGigs${e}");
    } finally {
      if (int.parse(page) == 1) {
        responseSearchAllServiceProvidersValue(false);
      } else {
        responseSearchAllServiceProvidersValueMore(false);
      }
    }
  }

//search sp by profesion
//read search service provider and related gigs
  void readSearchServicePsearchSpByProfession(String cityId, String codeLang,
      String page, String apiKey, double lat, double lng, String value) async {
    try {
      if (int.parse(page) == 1) {
        responseSearchAllServiceProvidersValue(true);
      } else {
        responseSearchAllServiceProvidersValueMore(true);
      }
      var serviceProviderAndGigs = await RemoteServices.searchSpByProfessions(
          cityId, codeLang, page, apiKey, lat, lng, value);

      if (serviceProviderAndGigs != null) {
        print("SearchResultFound");
        if (int.parse(page) > 1) {
          responseSearchAllServiceProviders.serviceproviders.data
              .addAll(serviceProviderAndGigs.serviceproviders.data);
        } else {
          responseSearchAllServiceProviders = serviceProviderAndGigs;
        }
      } else {}
    } catch (e) {
      print("readSearchServiceProviderAndGigs${e}");
    } finally {
      if (int.parse(page) == 1) {
        responseSearchAllServiceProvidersValue(false);
      } else {
        responseSearchAllServiceProvidersValueMore(false);
      }
    }
  }

//searched jobs
  void searechSimpleJobs(String cityId, String codeLang, String page,
      String apiKey, double lat, double lng, String value) async {
    try {
      if (int.parse(page) == 1) {
        searchJobsModelValue(true);
      } else {
        searchJobsModelValueMore(true);
      }
      var jobsResponse = await RemoteServices.makeSimpleSearchJobs(
          cityId, codeLang, page, apiKey, lat, lng, value);

      if (jobsResponse != null) {
        print("SearchResultFoundJobs");
        if (int.parse(page) > 1) {
          searchJobsModel!.data.addAll(jobsResponse.data);
        } else {
          searchJobsModel = jobsResponse;
        }
      } else {}
    } catch (e) {
      print("readSearchServiceProviderAndGigs${e}");
    } finally {
      if (int.parse(page) == 1) {
        searchJobsModelValue(false);
      } else {
        searchJobsModelValueMore(false);
      }
    }
  }

//custom search jobs
  void customSearchJob(
      String language,
      String lat1,
      String lng1,
      String profession,
      String skills,
      String serachField,
      String apiKey,
      int search_distance,
      String page) async {
    try {
      if (int.parse(page) == 1) {
        searchJobsModelValue(true);
      } else {
        searchJobsModelValueMore(true);
      }
      var jobsResponse = await RemoteServices.getCustomSearchJobs(
          language,
          lat1,
          lng1,
          profession,
          skills,
          serachField,
          apiKey,
          search_distance,
          page);

      if (jobsResponse != null) {
        print("SearchResultFound");
        if (int.parse(page) > 1) {
          searchJobsModel!.data.addAll(jobsResponse.data);
        } else {
          searchJobsModel = jobsResponse;
        }
      } else {}
    } catch (e) {
      print("readSearchServiceProviderAndGigs${e}");
    } finally {
      if (int.parse(page) == 1) {
        searchJobsModelValue(false);
      } else {
        searchJobsModelValueMore(false);
      }
    }
  }

//search job by profession
  void searchJobNyProfession(String cityId, String codeLang, String page,
      String apiKey, double lat, double lng, String value) async {
    try {
      if (int.parse(page) == 1) {
        searchJobsModelValue(true);
      } else {
        searchJobsModelValueMore(true);
      }
      var jobsResponse = await RemoteServices.seachJobByProfession(
          cityId, codeLang, page, apiKey, lat, lng, value);

      if (jobsResponse != null) {
        print("SearchResultFound");
        if (int.parse(page) > 1) {
          searchJobsModel!.data.addAll(jobsResponse.data);
        } else {
          searchJobsModel = jobsResponse;
        }
      } else {}
    } catch (e) {
      print("readSearchServiceProviderAndGigs${e}");
    } finally {
      if (int.parse(page) == 1) {
        searchJobsModelValue(false);
      } else {
        searchJobsModelValue(false);
      }
    }
  }

//read service provider profile
  void readSpProfileData(String userId, String isServiceProvider,
      String language, String apiKey, String lat, String lng) async {
    try {
      resposneServiceProviderProfileValue(true);
      var reponseSpProfile = await RemoteServices.readServiceProviderProfile(
          userId, isServiceProvider, language, apiKey, lat, lng);

      if (reponseSpProfile != null) {
        print("serviceProviderProfileDataSuccess");
        resposneServiceProviderProfile = reponseSpProfile;
      } else {}
    } catch (e) {
      print("readSpProfileData${e}");
    } finally {
      resposneServiceProviderProfileValue(false);
    }
  }

//delte job
  Future deleteJob(QueryDeleteJob queryDeleteJob, String apiKey) async {
    try {
      var response = await RemoteServices.deleteJob(queryDeleteJob, apiKey);
      if (response != null) {
        responseDirectJobCreation = response;
      } else {}
    } catch (e) {
      print("directJobCreation${e}");
    } finally {}
  }

//edit my gig
  Future editGig(QueryEditGig queryEditGig, String apiKey) async {
    try {
      var response = await RemoteServices.editGig(queryEditGig, apiKey);
      if (response != null) {
        responseEditGig = response;
      } else {}
    } catch (e) {
      print("directJobCreation${e}");
    } finally {}
  }

//read gig detail by gig id
  Future readGigDetail(
      QueryReadSingleGigDetail queryReadSingleGigDetail, String apiKey) async {
    try {
      readSingleGigDetailValue(true);
      var response = await RemoteServices.readSingleGigDetai(
          queryReadSingleGigDetail, apiKey);
      if (response != null) {
        readSingleGigDetail = response;
      } else {}
    } catch (e) {
      print("directJobCreation${e}");
    } finally {
      readSingleGigDetailValue(false);
    }
  }

//diable my account
  Future disableMyAccount(QuerDiableUser querDiableUser, String apiKey) async {
    try {
      readSingleGigDetailValue(true);
      var response =
          await RemoteServices.disableOrDeleteMyAccount(querDiableUser, apiKey);
      if (response != null) {
        responseDiableUser = response;
      } else {}
    } catch (e) {
      print("directJobCreation${e}");
    } finally {
      readSingleGigDetailValue(false);
    }
  }

  void signOutFromRdb(String uUid) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference
        .child(FireBaseConstants.userDbRoot)
        .child(uUid)
        .child(FireBaseConstants.userDeviceToken)
        .set("")
        .whenComplete(() {});
  }
//change language
//log any event to server
  Future logEvent(
      QueryLogEvent queryLogEvent, String apiKey) async {
    try {
      updatingSkill(true);

      var response = await RemoteServices.logEvent(queryLogEvent, apiKey);
      if (response != null) {
        generalResponse = response;
        if (generalResponse!.status == "success") {
          print("SkillUpdted");
        } else {}
      } else {}
    } catch (e) {
      print("updating_skill${e}");
    } finally {
      updatingSkill(false);
    }
  }
}
