import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_service_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/Styles/styles.dart';

class GigDetailPage extends StatefulWidget {
  SpGig myGig;
  GigDetailPage(this.myGig);
  @override
  State<GigDetailPage> createState() => _GigDetailPageState(myGig);
}

class _GigDetailPageState extends State<GigDetailPage> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  SpGig myGig;
  _GigDetailPageState(this.myGig);
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Gig Detail"),
        backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .62,
                width: double.infinity,
                color: Colors.blue,
              ),
            ],
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .28,
                right: 0.0,
                left: 0.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 35),
                    padding: const EdgeInsets.only(top: 40),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: SingleChildScrollView(
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Text(
                                      myGig.gigTitle.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/Postajob.png",
                                        fit: BoxFit.contain,
                                        width: 30,
                                        height: 30,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        height: 30,
                                        width: 60,
                                        color: Colors.green,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  myGig.gigDetail.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Image.network(
                                            AppConstants.PROFILEIMAGESURLS +
                                                responseLoginUser.user.logo
                                                    .toString(),
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                myGig.firstName.toString(),
                                                style:
                                                    Styles.textStyleGigTitle),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RatingBarIndicator(
                                                rating: 2,
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.orange[900],
                                                ),
                                                itemCount: 5,
                                                itemSize: 12.0,
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/ic_skills.png",
                                                  fit: BoxFit.contain,
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text("Skills",
                                                      style: Styles
                                                          .profileHeadings),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                populateSkillName(
                                                    myGig.gigSkills),
                                                style: Styles.textProfileStyle1,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text("Service Quantity",
                                                    style:
                                                        Styles.profileHeadings),
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Image.asset(
                                                    "assets/minus-sign.png",
                                                    fit: BoxFit.contain,
                                                    width: 5,
                                                    height: 10,
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    "1",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Image.asset(
                                                    "assets/ic_pluss.png",
                                                    fit: BoxFit.contain,
                                                    width: 10,
                                                    height: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Odlay Fee",
                                                style: Styles.textStyleGigTitle,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "6.0",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Note:All the amounts include VAT",
                                                  style: Styles.noteTextColor),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: Styles.appElevatedButtonStyle,
                                onPressed: () {},
                                child: Text('Hire ${myGig.firstName}'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      child: Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(10.0),
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Container(
                            height: 80,
                            width: 50,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String populateSkillName(List<GigSkills>? gigSkills) {
    String SkillName = "";
    for (var skill in gigSkills!) {
      SkillName = SkillName + "," + skill.title.toString();
    }
    return SkillName;
  }
}
