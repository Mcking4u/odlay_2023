// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/Tabs/_started_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/Tabs/closed_jobs.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/Tabs/opne_jobs.dart';
import 'package:get/get.dart';

class CustomerJobMangerTabs extends StatefulWidget {
  BuildContext mainContext;
  CustomerJobMangerTabs(this.mainContext);

  @override
  State<CustomerJobMangerTabs> createState() => _CustomerJobMangerTabsState();
}

class _CustomerJobMangerTabsState extends State<CustomerJobMangerTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
                  text: 'tab_opne'.tr,
                ),
                Tab(
                  text: 'tab_started'.tr,
                ),
                Tab(
                  text: 'tab_closed'.tr,
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  CustomerOpenJobs(widget.mainContext),
                  StartedJobs(widget.mainContext),
                  ClosedJobs(widget.mainContext)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
