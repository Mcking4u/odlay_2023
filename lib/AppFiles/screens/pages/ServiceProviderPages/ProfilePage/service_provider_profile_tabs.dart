import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_my_gigs.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/sp_profil_page.dart';
import 'package:get/get.dart';

class ServiceProviderProfile extends StatefulWidget {
  BuildContext mainContext;
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  ServiceProviderProfile(
      this.mainContext, this._resposneServiceProviderProfile);

  @override
  State<ServiceProviderProfile> createState() => _ServiceProviderProfileState();
}

class _ServiceProviderProfileState extends State<ServiceProviderProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
                text: 'tab_profile'.tr,
              ),
              Tab(
                text: 'tab_my_service'.tr,
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SpProfilePage(widget._resposneServiceProviderProfile),
                MyGigs(
                    widget.mainContext, widget._resposneServiceProviderProfile),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
