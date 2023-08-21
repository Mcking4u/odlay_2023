import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:get/get.dart';

class ItemUserGig extends StatelessWidget {
  SpGig gig;
  double giRating;
  ResponseLoginUser responseLoginUser;
  ItemUserGig(this.gig, this.giRating, this.responseLoginUser);

  @override
  Widget build(BuildContext context) {
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
            gig.gigImages != null
                ? CarouselSlider(
                    options: CarouselOptions(
                        aspectRatio: 2.1,
                        disableCenter: true,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        autoPlay: false),
                    items:
                        GenericAppFunctions.getGigListFromString(gig.gigImages)
                            .cast<String>()
                            .map((item) => ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  child: CachedNetworkImage(
                                    imageUrl: item,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
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
                      child: gig.gigSkills != null && gig.gigSkills!.isNotEmpty
                          ? Image.network(
                              AppConstants.IMAGESLIBRARYURLS +
                                  gig.gigSkills![0].gid!
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
            Positioned(
                bottom: 0,
                left: 2,
                right: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(181, 0, 0, 0),
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
                              gig.gigTitle.toString(),
                              style: Styles.simpletextStyleGig,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                responseLoginUser.user.currencySymbol
                                        .toString() +
                                    gig.gigPrice.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
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
                                gig.gigDetail.toString(),
                                maxLines: 2,
                                style: Styles.simpletextStyleGig,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 20,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(left: 10),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.green),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'str_detail'.tr,
                                    style: Styles.simpletextStyleGig,
                                  ),
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
                                      gig.firstName.toString(),
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
                                      "Islambad",
                                      style: Styles.simpletextStyleGig,
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: RatingBarIndicator(
                                  rating: giRating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 218, 81, 7),
                                  ),
                                  itemCount: 5,
                                  itemSize: 15.0,
                                  direction: Axis.horizontal,
                                ),
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
}
