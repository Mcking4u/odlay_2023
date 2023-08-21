import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_service_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/FullImageShow.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:get/get.dart';

class UserReviews extends StatelessWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  UserReviews(this._resposneServiceProviderProfile);
  List<String> reviewImges = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 10, top: 5),
            child: Row(
              children: [
                Image.asset(
                  "assets/ic_reviews.png",
                  fit: BoxFit.contain,
                  width: 20,
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('review_sp'.tr, style: Styles.profileHeadings),
                )
              ],
            ),
          ),
          _resposneServiceProviderProfile.reviews != null
              ? Container(
                  child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _resposneServiceProviderProfile.reviews!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ExpansionTileCard(
                          expandedColor: Colors.grey[200],
                          title: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _resposneServiceProviderProfile
                                      .reviews![index].skillName
                                      .toString(),
                                  style: Styles.headingTextColor,
                                ),
                                Container(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RatingBarIndicator(
                                      rating: double.parse(_resposneServiceProviderProfile
                                      .reviews![index].rating.toString()),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.orange[900],
                                      ),
                                      itemCount: 5,
                                      itemSize: 12.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          children: <Widget>[
                            Column(
                              children: _buildExpandableContent(
                                  context,
                                  _resposneServiceProviderProfile
                                      .reviews![index].detailedReviews),
                            ),
                          ]),
                    );
                  },
                ))
              : Text(
                  "No Reviews found",
                  style: Styles.headingText,
                )
        ],
      ),
    );
  }

  _buildExpandableContent(
      BuildContext context, List<DetailedReviewUser>? detailedReview) {
    List<Widget> columnContent = [];

    for (var i = 0; i < detailedReview!.length; i++) {
      reviewImges = [];
      print("ReviewImages${detailedReview[i].reviewImages}");
      if (detailedReview[i].reviewImages != null) {
        reviewImges = GenericAppFunctions.getReviewImageListFromString(
            detailedReview[i].reviewImages);
      }
      columnContent.add(GestureDetector(
          onTap: () {
            print("OpenDetailSheet");
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          detailedReview[i].title.toString(),
                          style: Styles.profileHeadings,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          GenericAppFunctions.getFormattedDate(
                              detailedReview[i].createdAt.toString()),
                          style: Styles.textStyleMyAccount,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      AppConstants.PROFILEIMAGESURLS +
                                          detailedReview[i].logo.toString(),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: RatingBarIndicator(
                                    rating: double.parse(
                                        detailedReview[i].rating.toString()),
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.orange[900],
                                    ),
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    direction: Axis.horizontal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Center(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      detailedReview[i].firstName.toString(),
                                      style: Styles.detailViewStyleHeader,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        maxLines: 2,
                                        detailedReview[i].feedback.toString(),
                                        style: Styles.detailViewStyleChild,
                                      ),
                                    ),
                                  ),
                                  reviewImges.isEmpty
                                      ? Container()
                                      : Container(
                                          height: 50,
                                          width: double.infinity,
                                          child: GridView.count(
                                              crossAxisCount: 1,
                                              scrollDirection: Axis.horizontal,
                                              crossAxisSpacing: 4.0,
                                              mainAxisSpacing: 8.0,
                                              children: List.generate(
                                                  reviewImges.length, (index) {
                                                return Center(
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        String clkUrl = GenericAppFunctions
                                                            .getReviewImageListFromStringOneUrl(
                                                                detailedReview[
                                                                        i]
                                                                    .reviewImages,
                                                                index);
                                                        print(
                                                            "ImageClikedUrl${clkUrl}");
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SimplePhotoViewPage(
                                                                        clkUrl)));
                                                      },
                                                      child: Image.network(
                                                        reviewImges[index],
                                                        fit: BoxFit.fill,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })),
                                        )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )));
    }
    return columnContent;
  }
}
