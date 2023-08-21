import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:matcher/matcher.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/home_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePageCover extends StatefulWidget {
  @override
  State<HomePageCover> createState() => _HomePageCoverState();
}

class _HomePageCoverState extends State<HomePageCover> {
  RxInt isVisible = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: VisibilityDetector(
        key: Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          print("Visisblity$visiblePercentage");
          if (visiblePercentage == 100.0) {
            isVisible(1);
            setState(() {});
          }
        },
        child: isVisible.value == 1 ? HomePage1() : Container(),
      ),
    );
  }
}
