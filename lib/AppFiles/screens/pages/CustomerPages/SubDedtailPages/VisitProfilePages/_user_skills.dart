import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/UpdateSkills/_update_service_provider_skill.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/_service_provider_job_manger.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';

import 'package:odlay_services/Styles/styles.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:get/get.dart';

class UserSkill extends StatefulWidget {
  @override
  State<UserSkill> createState() => _UserSkillState();
}

class _UserSkillState extends State<UserSkill> {
  AppController _appController = Get.put(AppController());
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  late ResponseLoginUser responseLoginUser;
  final List<Skill> _selectedSkill = [];

  String skillName = "";
  @override
  void initState() {
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    if (responseLoginUser.user.skills != null) {
      populateSkills();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10),
      elevation: 2,
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
                      child: Text('skill_sp'.tr, style: Styles.profileHeadings),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        responseLoginUser.user.skills != null &&
                                responseLoginUser.user.skills!.isNotEmpty
                            ? skillName.substring(1)
                            : "Please add Skill to  complete profile",
                        style: Styles.textSkillsStyle),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  showBottomSheetEditSkill(context);
                },
                child: Image.asset(
                  "assets/ic_Add_icon.png",
                  color: const Color.fromRGBO(255, 118, 87, 1),
                  fit: BoxFit.contain,
                  width: 30,
                  height: 30,
                ),
              ))
        ],
      ),
    );
  }

  showBottomSheetEditSkill(BuildContext mainContext) {
    print("OpenSheet");
    populateSkillsbottomsheet();
    showModalBottomSheet<void>(
        context: mainContext,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 60,
                      color: Colors.grey,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Image.asset(
                        "assets/ic_edit_screen_line.png",
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 2,
                      ),
                    ),
                    Text(
                      'add_skill'.tr,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        SelectDialog.showModal<Skill>(
                          context,
                          label: 'select_skills'.tr,
                          items: skillCitiesProfessions.skills,
                          onChange: (Skill skill) {
                            setState(() {
                              if (_selectedSkill.contains(skill)) {
                              } else {
                                if (_selectedSkill.length < 5) {
                                  _selectedSkill.add(skill);
                                } else {
                                  showToast(
                                      "You can not add more then 5 skills",
                                      context: context,
                                      backgroundColor: Colors.blue);
                                }
                              }
                            });
                          },
                        );
                      },
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 230, 230, 230),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/ic_skill_grey.png",
                                  fit: BoxFit.contain,
                                  width: 20,
                                  height: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: const TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        filled: false,
                                        hintText: "Select Skills",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Positioned(
                                top: 5,
                                right: 10,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: <Widget>[
                        for (var skill in _selectedSkill)
                          Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Text(skill.skillName[0].toUpperCase()),
                            ),
                            label: Text(
                              skill.skillName,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 15, 3, 0),
                              ),
                            ),
                            deleteIcon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onDeleted: () {
                              setState(() {
                                _selectedSkill.remove(skill);
                              });
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 189, 188, 188),
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                          )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 40,
                      width: double.infinity,
                      child: Obx(() => AppElevatedButton(
                            borderRadius: BorderRadius.circular(20),
                            onPressed: () async {
                              print("PreUpdateSkill");
                              await _appController.updateUserSkills(
                                  QueryUpdateSkill(
                                      apiKey: responseLoginUser.user.apiPlanText
                                          .toString(),
                                      userId: responseLoginUser
                                          .user.serviceProviders.userId
                                          .toString(),
                                      skills: getSelectedSkillIds()),
                                  apiKey.toString());
                              print("PostUpdateSkill");
                              await _appController.updateProfile(
                                  responseLoginUser.user.serviceProviders.userId
                                      .toString(),
                                  responseLoginUser.user.language,
                                  apiKey.toString());
                              print("AfterUpdatingSkill");
                              Navigator.pop(context);

                              print("AfterPoping");
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileLandingPage()),
                                (Route<dynamic> route) => true,
                              );
                            },
                            child: Text(_appController.updatingSkill.value
                                ? 'updating'.tr
                                : 'update'.tr),
                          )),
                    )
                  ],
                ),
              ),
            );
          }));
        });
  }

  void populateSkills() {
    print("UserSkillsAre${responseLoginUser.user.skills}");
    final List<String> _jobSKills = [];
    for (var sId in responseLoginUser.user.skills!) {
      print("SkilId$sId");
      var Skill =
          skillCitiesProfessions.skills.where((skill) => skill.skillId == sId);
      print("SKillName${Skill.first}");
      skillName = skillName + "," + Skill.first.toString();
    }
    if (skillName.isNotEmpty) {
      skillName.substring(1);
    }
  }

  void populateSkillsbottomsheet() {
    if (_selectedSkill.isNotEmpty) {
      _selectedSkill.clear();
    }
    print("UserSkillsAre${responseLoginUser.user.skills}");
    final List<String> _jobSKills = [];
    for (var sId in responseLoginUser.user.skills!) {
      int skillIndex = skillCitiesProfessions.skills
          .indexWhere((skill) => skill.skillId == sId);
      print("MySkill${skillIndex}");
      print("SkillFullData");
      _selectedSkill.add(skillCitiesProfessions.skills[skillIndex]);
    }
  }

  List<int> getSelectedSkillIds() {
    List<int> skillIdList = [];
    for (var selectedSkill in _selectedSkill) {
      skillIdList.add(selectedSkill.skillId);
    }
    print("SelectedSkillId${skillIdList.toString()}");
    return skillIdList;
  }
}
