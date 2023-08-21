import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_item_user_gig.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_gig_detail_page.dart';

class UserGigs extends StatelessWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  ResponseLoginUser responseLoginUser;
  BuildContext MainPageContext;
  UserGigs(this._resposneServiceProviderProfile, this.MainPageContext,
      this.responseLoginUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _resposneServiceProviderProfile.gigs != null
              ? Expanded(
                  child: Container(
                    child: ListView.builder(
                        itemCount: _resposneServiceProviderProfile.gigs!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                print(
                                    "CliekdUserGig${_resposneServiceProviderProfile.gigs![index]}");
                                Navigator.of(MainPageContext).push(
                                    MaterialPageRoute(
                                        builder: (context) => UserGigDetailPage(
                                            _resposneServiceProviderProfile
                                                .gigs![index].gigId
                                                .toString(),
                                            _resposneServiceProviderProfile
                                                .serviceId
                                                .toString(),
                                            false,
                                            _resposneServiceProviderProfile
                                                .gigs![index].gigPrice)));
                              },
                              child: ItemUserGig(
                                  _resposneServiceProviderProfile.gigs![index],
                                  _resposneServiceProviderProfile.rating != null
                                      ? double.parse(
                                          _resposneServiceProviderProfile.rating
                                              .toString())
                                      : 0.0,
                                  responseLoginUser
                                  // parseRating(_resposneServiceProviderProfile
                                  //     .rating
                                  //     .toString()
                                  //     )
                                  ));
                        }),
                  ),
                )
              : const Center(
                  child: Text("No Gig found"),
                )
        ],
      ),
    );
  }

  double parseRating(String gigRating) {
    print("GIGLun${gigRating}");
    double defaultRating = 0.0;
    if (gigRating == null) {
      print("Tata");
    } else {
      defaultRating = double.parse(gigRating);
    }
    return defaultRating;
  }
}
