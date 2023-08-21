import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:matcher/matcher.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/home_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/_customer_job_manger.dart';
import 'package:visibility_detector/visibility_detector.dart';

class JobPageCover extends StatefulWidget {
  @override
  State<JobPageCover> createState() => _JobPageCoverState();
}

class _JobPageCoverState extends State<JobPageCover> {
  RxInt isVisible = 0.obs;

  @override
  void initState() {
    print("InternetClicked");
    if(AppConstants.allowCustLoad){
      AppConstants.allowCustLoad=false;
      isVisible(1);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: VisibilityDetector(
        key: Key('my-widget-key_job_cus'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          print("VisisblityjobManager$visiblePercentage");
          if (visiblePercentage == 100.0) {
            isVisible(1);
            setState(() {});
          }
        },
        child: isVisible.value == 1 ? CustomerJobManager() : Container(),
      ),
    );
  }
}
