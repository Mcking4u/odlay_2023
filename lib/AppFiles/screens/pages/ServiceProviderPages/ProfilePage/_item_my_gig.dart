import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_create_gig_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_my_gigs.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';

class ItemMyGig extends StatefulWidget {
  SpGig myGigs;
  Function callback;
  double gig_rating;
  ItemMyGig(this.myGigs, this.callback, this.gig_rating);

  @override
  State<ItemMyGig> createState() => _ItemMyGigState(myGigs);
}

class _ItemMyGigState extends State<ItemMyGig> {
  SpGig myGig;
  _ItemMyGigState(this.myGig);
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    responseLoginUser = responseLoginUserFromJson(userData!);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ItemRebuild");
    return Container(
      width: double.infinity,
      height: 200,
      child: Card(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        elevation: 10,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            myGig.gigImages != null
                ? CarouselSlider(
                    options: CarouselOptions(
                        aspectRatio: 2.1,
                        disableCenter: true,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        autoPlay: false),
                    items: GenericAppFunctions.getGigListFromString(
                            myGig.gigImages)
                        .cast<String>()
                        .map((item) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: CachedNetworkImage(
                                imageUrl: item,
                                width: double.infinity,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ))
                        .toList(),
                  )
                : Container(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child:
                          myGig.gigSkills != null && myGig.gigSkills!.isNotEmpty
                              ? Image.network(
                                  AppConstants.IMAGESLIBRARYURLS +
                                      myGig.gigSkills![0].gid!
                                          .toLowerCase()
                                          .replaceAll(" ", "") +
                                      ".jpg",
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/test_gig_image.jpg",
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                    );
                                  },
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                )
                              : Image.asset(
                                  "assets/test_gig_image.jpg",
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                    ),
                  ),
            Positioned(right: 10, top: 10, child: _childPopup()),
            Positioned(
                bottom: 0,
                left: 2,
                right: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(93, 2, 1, 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              myGig.gigTitle.toString(),
                              style: Styles.simpletextStyleGig,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                responseLoginUser.user.currencySymbol! +
                                    myGig.gigPrice.toString(),
                                style: Styles.simpletextStyleGigColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                myGig.gigDetail.toString(),
                                maxLines: 2,
                                style: Styles.simpletextStyleGig,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateGigPage(
                                                        false, myGig)));
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.callback(
                                              myGig, AppConstants.EDITGIG, "");
                                        },
                                        child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/ic_edit.png'),
                                                fit: BoxFit.contain,
                                              ),
                                            )),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print("DeleteGig");
                                        widget.callback(
                                            myGig, AppConstants.DELTEGIG, "");
                                      },
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/ic_gig_delete.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Text(
                                      myGig.firstName.toString(),
                                      style: Styles.simpletextStyleGig,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Image.asset(
                                        'assets/play.png',
                                        height: 10,
                                        width: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      GenericAppFunctions.getCityNameFromCityId(
                                          skillCitiesProfessions, myGig.cityId),
                                      style: Styles.simpletextStyleGig,
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: RatingBarIndicator(
                                rating: widget.gig_rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 218, 81, 7),
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _childPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Text(
              "Close",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          const PopupMenuItem(
            value: 0,
            child: Text(
              "Active",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        onSelected: (value) {
          print("SlectedValue${value}");
          if (value == 0) {
            widget.callback(myGig, AppConstants.GIGSTATUS,
                AppConstants.ACTVIESTATUS.toString());
          } else {
            widget.callback(myGig, AppConstants.GIGSTATUS,
                AppConstants.DEACTVIESTATUS.toString());
          }
        },
        child: Image.asset(
          "assets/ic_wht_dots.png",
          height: 30,
          width: 20,
          color: myGig.status == AppConstants.ACTVIESTATUS
              ? Colors.green
              : Colors.red,
        ),
      );
}
