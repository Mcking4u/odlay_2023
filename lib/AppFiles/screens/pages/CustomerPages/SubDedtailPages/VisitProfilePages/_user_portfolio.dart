import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/FullImageShow.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/bottom_sheet_add_portfolio_images.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class UserPortfolio extends StatefulWidget {
  @override
  State<UserPortfolio> createState() => _UserPortfolioState();
}

class _UserPortfolioState extends State<UserPortfolio> {
  AppController _appController = Get.put(AppController());
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  final ImagePicker imagePicker = ImagePicker();

  File? image;
  List<String> portfolioImages = [];
  late String? apiKey;
  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (responseLoginUser.user.serviceProviders.portfolioImages != null) {
      portfolioImages = GenericAppFunctions.getPortfolioImagesFromString(
          responseLoginUser.user.serviceProviders.portfolioImages);
    }
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10),
      elevation: 2,
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
                      child: Text('add_your_work_images'.tr,
                          style: Styles.profileHeadings),
                    )
                  ],
                ),
                portfolioImages.isEmpty
                    ? Container(
                        child: Text(
                          'please_add_portfolio_images'.tr,
                          style: Styles.headingText,
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 60,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ListView.builder(
                              itemCount: portfolioImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 60,
                                  width: 60,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("LoadImageFullScreen");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SimplePhotoViewPage(
                                                      portfolioImages[index])));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        portfolioImages[index],
                                        fit: BoxFit.fill,
                                        width: 40,
                                        height: 40,
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
          Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  print("EditPortfolio");
                  showBottomSheetAddPortfolio(context);
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

  showBottomSheetAddPortfolio(BuildContext context) {
    print("OpenSheet");
    showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return BodyBottomSheetAddPortfolio();
        });
  }
}
