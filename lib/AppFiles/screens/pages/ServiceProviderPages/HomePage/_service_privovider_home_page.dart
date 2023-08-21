import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:matcher/matcher.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/home_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/HomePage/home_page_sp.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SpHomePageCover extends StatefulWidget {
  BuildContext mainContext;
  SpHomePageCover(this.mainContext);
  @override
  State<SpHomePageCover> createState() => _SpHomePageCoverState();
}

class _SpHomePageCoverState extends State<SpHomePageCover> {
  RxInt isVisible = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: VisibilityDetector(
        key: Key('my-widget-key_sp_home_page'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          print("Visisblity$visiblePercentage");
          if (visiblePercentage == 100.0) {
            isVisible(1);
            setState(() {});
          }
        },
        child:
            isVisible.value == 1 ? HomePageSp(widget.mainContext) : Container(),
      ),
    );
  }
}
