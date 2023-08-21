import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:matcher/matcher.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/home_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/HomePage/home_page_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/_service_provider_job_manger.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_profile_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../Utility/AppConstants.dart';

class SpJobManagerPageCover extends StatefulWidget {
  @override
  State<SpJobManagerPageCover> createState() => _SpJobManagerCoverState();
}

class _SpJobManagerCoverState extends State<SpJobManagerPageCover> {
  RxInt isVisible = 0.obs;
@override
  void initState() {
  if(AppConstants.allowSpLoad){
    AppConstants.allowSpLoad=false;
    isVisible(1);
  }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: VisibilityDetector(
        key: Key('my-widget-key_job_sp'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          print("Visisblity$visiblePercentage");
          if (visiblePercentage == 100.0) {
            isVisible(1);
            setState(() {});
          }
        },
        child: isVisible.value == 1 ? ServiceProviderJobManager() : Container(),
      ),
    );
  }
}
