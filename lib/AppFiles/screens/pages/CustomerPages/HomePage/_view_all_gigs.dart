import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_query_top_rated_gigs_modle.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/ListItems/item_view_all_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_homepager_header.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_gig_detail_page.dart';

class ViewAllGigs extends StatefulWidget {
  @override
  State<ViewAllGigs> createState() => _ViewAllGigsState();
}

class _ViewAllGigsState extends State<ViewAllGigs> {
  final AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    responseLoginUser = responseLoginUserFromJson(userData!);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    _appController.getAllCityRelatedGigs(
        QueryTopRatedGigsModle(cityId: 3), apiKey.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 237, 236, 236),
        child: Column(
          children: [
            HomePageHeader(false),
            const SizedBox(
              height: 106,
            ),
            Obx(() {
              if (_appController.isresponseViewAllGigs.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _appController.responseViewAllGigs!.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print(
                              "CliekdUserGig${_appController.responseViewAllGigs!.data[index]}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserGigDetailPage(
                                  _appController
                                      .responseViewAllGigs!.data[index].gigId
                                      .toString(),
                                  _appController
                                      .responseViewAllGigs!.data[index].userId
                                      .toString(),
                                  false,
                                  _appController.responseViewAllGigs!
                                      .data[index].gigPrice)));
                        },
                        child: ItemViewAllGig(
                            _appController.responseViewAllGigs!.data[index],
                            skillCitiesProfessions,
                            responseLoginUser),
                      );
                    }),
              );
            })
          ],
        ),
      ),
    );
  }
}
