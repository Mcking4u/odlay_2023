import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/DirectHire/_body_direct_hire.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';

class DirectHirePage extends StatelessWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  DirectHirePage(this._resposneServiceProviderProfile);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text("Direct Hire"),
        backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: BodyDirectHire(_resposneServiceProviderProfile),
    );
  }
}
