import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/visit_service_provider_profile_tabs.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';

class ProfileLandingVisitPage extends StatefulWidget {
  Datum serviceProvider;
  ProfileLandingVisitPage(this.serviceProvider);

  @override
  State<ProfileLandingVisitPage> createState() =>
      _ProfileLandingVisitPageState();
}

class _ProfileLandingVisitPageState extends State<ProfileLandingVisitPage> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  AppController _appController = Get.put(AppController());
  late String? apiKey;
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    _appController.readSpProfileData(
        widget.serviceProvider.id.toString(),
        "1",
        responseLoginUser.user.language.toString(),
        apiKey.toString(),
        LocationConstants.USERCURRENTLATITUDE.toString(),
        LocationConstants.USERCURRENTLONGITUDE.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const Text("Service Provider Profile"),
          backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )),
        ),
        body: Obx(() {
          if (_appController.resposneServiceProviderProfileValue.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return VisitServiceProviderProfileTabs(
              _appController.resposneServiceProviderProfile);
        }));
  }
}
