import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_portfolio.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_skills.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/user_revirews.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_header_profile_widget_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/body_bottom_sheet_cnic.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';

class SpProfilePage extends StatefulWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  SpProfilePage(this._resposneServiceProviderProfile);
  @override
  State<SpProfilePage> createState() => _SpProfilePageState();
}

class _SpProfilePageState extends State<SpProfilePage> {
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  final ImagePicker imagePicker = ImagePicker();
  int? appRegion;
  @override
  void initState() {
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  HeaderProfileWidgetSp(widget._resposneServiceProviderProfile),
                  appRegion == 1
                      ? Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, left: 5, right: 20),
                                          child: const Divider(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/ic_verfiied.png",
                                                        fit: BoxFit.contain,
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        child: Text("Phone",
                                                            style: Styles
                                                                .strengthTextStyle),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/ic_cross_flutter.png",
                                                        fit: BoxFit.contain,
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        child: Text(
                                                            "Picture verification",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Styles
                                                                .strengthTextStyle),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/ic_cross_flutter.png",
                                                        fit: BoxFit.contain,
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        child: Text(
                                                            "CNIC verification",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Styles
                                                                .strengthTextStyle),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/ic_cross_flutter.png",
                                                        fit: BoxFit.contain,
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            "Address verification",
                                                            style: Styles
                                                                .strengthTextStyle),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        print("OpenEditCnic");
                                        showBottomSheetAddPortfolio(
                                            AppConstants.baseContext);
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          height: 30,
                                          child: Image.asset(
                                            "assets/ic_Add_icon.png",
                                            color: const Color.fromRGBO(
                                                255, 118, 87, 1),
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                          )),
                                    ),
                                  ))
                            ],
                          ),
                        )
                      : Container(
                          height: 10,
                        )
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10), child: UserSkill()),
            Container(
                margin: const EdgeInsets.only(top: 10), child: UserPortfolio()),
            UserReviews(widget._resposneServiceProviderProfile)
          ],
        ),
      ),
    ));
  }

  showBottomSheetAddPortfolio(BuildContext context) {
    print("OpenSheet");
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return BodyBottomSheetVerifyIdentity();
        });
  }
}
