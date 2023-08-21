import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/visit_sp_profil_page.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:get/get.dart';

class VisitServiceProviderProfileTabs extends StatefulWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  VisitServiceProviderProfileTabs(this._resposneServiceProviderProfile);

  @override
  State<VisitServiceProviderProfileTabs> createState() =>
      _VisitServiceProviderProfileTabsState();
}

class _VisitServiceProviderProfileTabsState
    extends State<VisitServiceProviderProfileTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ResponseLoginUser responseLoginUser;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Color.fromRGBO(255, 118, 87, 1),
            indicatorColor: Color.fromRGBO(255, 118, 87, 1),
            tabs: [
              Tab(
                text: 'visit_sp_tab_name_profile'.tr,
              ),
              Tab(
                text: 'visit_sp_tab_name_services'.tr,
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                VisitSpProfilePage(
                    widget._resposneServiceProviderProfile, context),
                UserGigs(widget._resposneServiceProviderProfile, context,
                    responseLoginUser),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
