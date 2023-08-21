import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:matcher/matcher.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_conversion_header.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/home_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/_customer_job_manger.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ConversationCover extends StatefulWidget {
  @override
  State<ConversationCover> createState() => _ConversationCoverState();
}

class _ConversationCoverState extends State<ConversationCover> {
  RxInt isVisible = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: VisibilityDetector(
        key: Key('my-widget-key_conversation'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          print("Visisblityjob$visiblePercentage");
          if (visiblePercentage == 100.0) {
            isVisible(1);
            setState(() {});
          }
        },
        child: isVisible.value == 1 ? ConversionHeader() : Container(),
      ),
    );
  }
}
