import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/FullImageShow.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class VisitUserPortfolio extends StatefulWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  VisitUserPortfolio(this._resposneServiceProviderProfile);
  @override
  State<VisitUserPortfolio> createState() => _VisitUserPortfolioState();
}

class _VisitUserPortfolioState extends State<VisitUserPortfolio> {
  AppController _appController = Get.put(AppController());
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  List<String> listPortfolioImages = [];
  @override
  void initState() {
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    if (widget._resposneServiceProviderProfile.portfolioImages != null) {
      listPortfolioImages = GenericAppFunctions.getPortfolioImagesFromString(
          widget._resposneServiceProviderProfile.portfolioImages);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 15, right: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/ic_portfolio.png",
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('str_portfolio'.tr,
                          style: Styles.profileHeadings),
                    )
                  ],
                ),
                listPortfolioImages.isEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 10, left: 25),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'str_no_portfolio'.tr,
                            style: Styles.headingText,
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ListView.builder(
                              itemCount: listPortfolioImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 50,
                                  width: 50,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SimplePhotoViewPage(
                                                          listPortfolioImages[
                                                              index])));
                                        },
                                        child: Image.network(
                                          listPortfolioImages[index],
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
