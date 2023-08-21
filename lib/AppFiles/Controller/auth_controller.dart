import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';

import 'package:odlay_services/AppFiles/Services/remote_services.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_configure_app_variables.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/check_user.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/VerifyPhoneModel/_query_verify_phone.dart';
import 'package:odlay_services/AppFiles/model/VerifyPhoneModel/_response_verify_phone.dart';
import 'package:odlay_services/AppFiles/screens/pages/AuthPages/Otp.dart';
import 'package:odlay_services/AppFiles/screens/pages/AuthPages/registeration_page.dart';

import 'package:odlay_services/AppFiles/screens/pages/SelectionPages/selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthController extends GetxController {
  var skillCitiesProfessionsValue = false.obs;
  SkillCitiesProfessions? skillCitiesProfessions;
  var checkUser = false.obs;
  CheckUserModel? checkUserModel;
  final databaseReference = FirebaseDatabase.instance.ref();

  var verifyPhoneValue = false.obs;
  ResponseVerifyPhone? _responseVerifyPhone;

  void checkUserStatus(String phoneNumber, BuildContext context, String uuid,
      String deviceToken, String regionCode) async {
    try {
      var apiResponse =
          await RemoteServices.checkUserState(phoneNumber, regionCode);
      if (apiResponse != null) {
        checkUserModel = apiResponse;
        print("UserStatus${checkUserModel?.status}");
        String? user_status = checkUserModel?.status;
        String? user_message = checkUserModel?.message;
        if (user_status == "registered") {
          if (user_message == "User is old one" ||
              user_message == "password not set" ||
              user_message == "User created successfully") {
            Get.to(RegistrationPage(phoneNumber, uuid));
          } else {
            loginUser(phoneNumber, uuid, deviceToken, context);
          }
        } else if (user_status == "not registered") {
          Get.to(RegistrationPage(phoneNumber, uuid));
        }
      } else {
        print("VlaueNull");
      }
    } catch (e) {
      print("Exception$e");
    } finally {
      checkUser(false);
    }
  }

//verify phone and confinure base url
  void verifyPhone(
      QueryVerifyPhone queryVerifyPhone, BuildContext context) async {
    try {
      verifyPhoneValue(true);
      var apiResponse = await RemoteServices.verifyPhone(queryVerifyPhone);
      if (apiResponse != null) {
        _responseVerifyPhone = apiResponse;
        if (_responseVerifyPhone!.status == "success") {
          setUserRegionCode(_responseVerifyPhone!.apiRegion!.regionCode);
          ConfigureAppVariable.configureUrls(
              _responseVerifyPhone!.apiRegion!.regionCode);

          Get.to(OtpPage(
            phone_number: queryVerifyPhone.phone.toString(),
            dial_code: _responseVerifyPhone!.apiRegion!.dialcode.toString(),
          ));
        } else {
          showToast(_responseVerifyPhone!.message.toString(),
              context: context, backgroundColor: Colors.red);
        }
      } else {
        showToast("Unable to Verify User please try again later",
            context: context, backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Exception$e");
      showToast("Unable to Verify User please try again later",
          context: context, backgroundColor: Colors.red);
    } finally {
      checkUser(false);
    }
  }

  void registerUser(
      String email,
      String fName,
      String phoneNumber,
      String fUuid,
      String deviceToken,
      String gender,
      BuildContext context) async {
    try {
      var apiResponseRegister = await RemoteServices.registerUser(
          email, fName, gender, fUuid, phoneNumber);
      if (apiResponseRegister != null) {
        loginUser(phoneNumber, fUuid, deviceToken, context);
      } else {}
    } catch (e) {
      print("object$e");
    } finally {}
  }

  Future updateFirebaseUid(
    String deviceToken,
    String firebaseUid,
    String userId,
  ) async {
    try {
      var apiResponseUuid = await RemoteServices.updatedFirebasUuid(
          deviceToken, firebaseUid, userId);
      if (apiResponseUuid != null) {
      } else {}
    } catch (e) {
      print("object$e");
    } finally {}
  }

  void loginUser(String phoneNumber, String uUid, String deviceToken,
      BuildContext context) async {
    try {
      var apiResponseLogin = await RemoteServices.loginUser(phoneNumber);
      if (apiResponseLogin != null) {
        showToast("User Logged In",
            context: context, backgroundColor: Colors.green);
        Constants.sharedPreferences = await SharedPreferences.getInstance();
        Constants.sharedPreferences.setBool("isLoggedIn", true);
        print(
            "ApiKeyWhileLogin${apiResponseLogin.user.apiPlanText.toString()}");
        Constants.sharedPreferences.setString(SharePrefrencesValues.API_KEY,
            apiResponseLogin.user.apiPlanText.toString());
//SavedKeykey
        Constants.sharedPreferences.setString(SharePrefrencesValues.STRIPE_SAVED_KEY,
            apiResponseLogin.user.stp_sec.toString());

        stroreDataInRDB(apiResponseLogin, uUid, deviceToken);
        await updateFirebaseUid(
            deviceToken, uUid, apiResponseLogin.user.id.toString());
        if (apiResponseLogin.user.language == AppConstants.LANGUAGE_SUOMI) {
          Constants.sharedPreferences
              .setInt(SharePrefrencesValues.LANGUAGE_INTIALS, 1);
        } else {
          Constants.sharedPreferences
              .setInt(SharePrefrencesValues.LANGUAGE_INTIALS, 0);
        }
        Get.offAll(selection_page());
      }
    } catch (e) {
      print("LoginException${e}");
    }
  }

  void stroreDataInRDB(ResponseLoginUser responseLoginUser, String uUid,
      String deviceToken) async {
    await databaseReference
        .child(FireBaseConstants.userDbRoot)
        .child(uUid)
        .set({
      FireBaseConstants.userName: responseLoginUser.user.firstName,
      FireBaseConstants.userEmail: responseLoginUser.user.email,
      FireBaseConstants.userDeviceToken: deviceToken,
      FireBaseConstants.userNumber: responseLoginUser.user.phone,
      FireBaseConstants.userImage: responseLoginUser.user.logo,
      FireBaseConstants.userSkills: '[]',
      FireBaseConstants.userLastSeen: '213134321412'
    }).whenComplete(() {
      print("DataInserted");
    }).onError((error, stackTrace) {
      print("ErrorInsertingUser${error}");
    });
  }

  void setUserRegionCode(int? regionCode) {
    if (regionCode == 1) {
      Constants.sharedPreferences.setInt(SharePrefrencesValues.APP_REGION, 1);
    } else {
      Constants.sharedPreferences.setInt(SharePrefrencesValues.APP_REGION, 2);
    }
  }

  void readSkillCities(int langaugeCode, String apiKey) async {
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
}
