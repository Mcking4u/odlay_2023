import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_body_create_gig.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:get/get.dart';

class CreateGigPage extends StatelessWidget {
  bool isUpdateGig;
  SpGig? myGig;
  CreateGigPage(this.isUpdateGig, this.myGig);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('post_your_service'.tr),
        backgroundColor: Color.fromRGBO(255, 118, 87, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: BodyCreateGig(isUpdateGig, myGig),
    );
  }
}
