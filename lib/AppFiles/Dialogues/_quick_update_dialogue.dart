import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:select_dialog/select_dialog.dart';

class QuickUpdateDialogue {
  static QuickUpdateDialogue _instance = new QuickUpdateDialogue.internal();

  QuickUpdateDialogue.internal();

  factory QuickUpdateDialogue() => _instance;
  static void showDisclaimerDialog(
      BuildContext context,
      ResponseLoginUser responseLoginUser,
      AppController appController,
      SkillCitiesProfessions skillCitiesProfessions) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (BuildContext dialogueContext, __, ___) {
        TextEditingController jobAddress = TextEditingController();
        late String cityName = "";
        final List<Skill> _selectedSkill = [];
        return Center(
          child: Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 118, 87, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          "Quick Update",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(dialogueContext),
                        child: const Positioned(
                            right: 10,
                            top: 10,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 230, 230, 230),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: ListTile(
                                      title: TextFormField(
                                        minLines: 1,
                                        controller: jobAddress,
                                        onTap: () async {
                                          // Prediction? p = await PlacesAutocomplete.show(
                                          //   context: context,
                                          //   apiKey: apiKeyAutoCompleteSearch,
                                          //   offset: 0,
                                          //   radius: 1000,
                                          //   types: [],
                                          //   strictbounds: false,
                                          //   mode: Mode.overlay,
                                          //   language: "en",
                                          //   components: [
                                          //     new Component(Component.country, "pk")
                                          //   ],
                                          // );
                                          // if (p != null) {
                                          //   if (p.placeId.toString().isNotEmpty) {
                                          //     PlacesDetailsResponse response =
                                          //         await _places.getDetailsByPlaceId(
                                          //             p.placeId.toString());
                                          //     var location =
                                          //         response.result.geometry!.location;
                                          //     print("AddressSelected${location}");
                                          //     jobLatitude = location.lat;
                                          //     jobLongitude = location.lng;
                                          //     manipulateCityAndAdress();
                                          //   } else {
                                          //     showToast("No Address Selected",
                                          //         context: context,
                                          //         backgroundColor: Colors.lightBlue);
                                          //   }
                                          // }
                                        },
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: "Enter Address",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      leading: const Icon(Icons.search),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    // _getUserLocation();
                                  },
                                  child: Container(
                                      color: Colors.grey[200],
                                      child: Image.asset(
                                        "assets/ic_pickmylocation.png",
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        height: 55,
                                      )),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 230, 230, 230),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Stack(
                          children: [
                            Container(
                              height: 40,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 40,
                                      child: const Align(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Icon(
                                              Icons.stacked_line_chart_outlined,
                                              size: 20,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        cityName,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      height: 40,
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          SelectDialog.showModal<Skill>(
                            context,
                            label: "Select Skills",
                            items: skillCitiesProfessions.skills,
                            onChange: (Skill skill) {
                              // setState(() {
                              //   _selectedSkill.add(skill);
                              // });
                            },
                          );
                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Stack(
                            children: [
                              Container(
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: 40,
                                        child: const Align(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: Icon(
                                                Icons
                                                    .stacked_line_chart_outlined,
                                                size: 20,
                                              ),
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 25),
                                        child: const Text(
                                          "Select Skills",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        height: 40,
                                        child: const Icon(
                                          Icons.arrow_drop_down,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: <Widget>[
                          for (var skill in _selectedSkill)
                            Chip(
                              avatar: CircleAvatar(
                                backgroundColor: Colors.white70,
                                child: Text(skill.skillName[0].toUpperCase()),
                              ),
                              label: Text(
                                skill.skillName,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              deleteIcon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onDeleted: () {
                                // setState(() {
                                //   _selectedSkill.remove(skill_label);
                                // });
                              },
                              backgroundColor: Colors.grey[200],
                              elevation: 6.0,
                              shadowColor: Colors.grey[60],
                            )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogueContext);
                            },
                            style: Styles.appElevatedJobStatusButtonStyle,
                            child: const Text('Decline')),
                      ),
                      SizedBox(
                        width: 80,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogueContext);
                            },
                            style: Styles.appElevatedJobStatusButtonStyle,
                            child: const Text('Accept')),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
