import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';

import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';

import 'package:odlay_services/Styles/styles.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:get/get.dart';

class ServiceProviderSkill extends StatefulWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  ServiceProviderSkill(this._resposneServiceProviderProfile);
  @override
  State<ServiceProviderSkill> createState() => _ServiceProviderSkillState();
}

class _ServiceProviderSkillState extends State<ServiceProviderSkill> {
  AppController _appController = Get.put(AppController());
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  late ResponseLoginUser responseLoginUser;

  String skillName = "";
  @override
  void initState() {
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    // print(
    //     "ServiceProviderSkills${widget.serviceProvider.skills![0].skillName}");
    populateSkills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/ic_skills.png",
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('skills'.tr, style: Styles.profileHeadings),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(skillName.isEmpty ? "" : skillName.substring(1),
                        style: Styles.textSkillsStyle),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void populateSkills() {
    for (var skill in widget._resposneServiceProviderProfile.skills!) {
      skillName = skillName + "," + skill.skillName.toString();
      skillName.substring(1);
    }
  }
}
