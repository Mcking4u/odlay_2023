import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_header_profile_widget.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_service_provider_skills.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_portfolio.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_skills.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_visit_user_portfolio.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/user_revirews.dart';
import 'package:odlay_services/Styles/styles.dart';

class VisitSpProfilePage extends StatelessWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  BuildContext MainPagecontext;
  late int? appRegion;
  VisitSpProfilePage(
      this._resposneServiceProviderProfile, this.MainPagecontext);
  @override
  Widget build(BuildContext context) {
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Column(
              children: [
                HeaderProfileWidget(
                    _resposneServiceProviderProfile, MainPagecontext),
                appRegion == 2
                    ? Container(
                        height: 10,
                      )
                    : Container(
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10),
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
                                            top: 5, left: 5, right: 5),
                                        child: const Divider(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Image.asset(
                                                "assets/ic_verfiied.png",
                                                fit: BoxFit.contain,
                                                width: 25,
                                                height: 25,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "profile",
                                                  style:
                                                      Styles.strengthTextStyle,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Image.asset(
                                                "assets/ic_cross_flutter.png",
                                                fit: BoxFit.contain,
                                                width: 25,
                                                height: 25,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "picture",
                                                  style:
                                                      Styles.strengthTextStyle,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Image.asset(
                                                "assets/ic_cross_flutter.png",
                                                fit: BoxFit.contain,
                                                width: 25,
                                                height: 25,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "cnic",
                                                  style:
                                                      Styles.strengthTextStyle,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Image.asset(
                                                "assets/ic_cross_flutter.png",
                                                fit: BoxFit.contain,
                                                width: 25,
                                                height: 25,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "address",
                                                  style:
                                                      Styles.strengthTextStyle,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 40,
                                ))
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ServiceProviderSkill(_resposneServiceProviderProfile)),
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: VisitUserPortfolio(_resposneServiceProviderProfile)),
          UserReviews(_resposneServiceProviderProfile)
        ],
      ),
    ));
  }
}
