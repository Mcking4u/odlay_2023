import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chip_list/chip_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';

import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_simple_search_serice_provider.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:get/get.dart';

class ViewAllCategoriesHeader extends StatefulWidget {
  @override
  State<ViewAllCategoriesHeader> createState() =>
      _ViewAllCategoriesHeaderState();
}

class _ViewAllCategoriesHeaderState extends State<ViewAllCategoriesHeader> {
  late List<String> listBannerImages = [];
  late SkillCitiesProfessions skillCitiesProfessions;
  final List<String> _selectedSkill = [];
  List<String> spinnerItems = ['5km', '10km', '15km', '25km', '50km'];
  String dropdownValue = '5km';
  @override
  void initState() {
    getBannerList();
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              height: 190,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 102, 102, 1),
                        Color.fromRGBO(255, 133, 76, 1)
                      ]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Odlay Service",
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Islambad",
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      margin:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Autocomplete<Skill>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  return skillCitiesProfessions.skills
                                      .where((Skill skill) => skill.skillName
                                          .toLowerCase()
                                          .startsWith(textEditingValue.text
                                              .toLowerCase()))
                                      .toList();
                                },
                                displayStringForOption: (Skill option) =>
                                    option.skillName,
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController
                                        fieldTextEditingController,
                                    FocusNode fieldFocusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Plumber,Electrian',
                                      border: InputBorder.none,
                                    ),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                                onSelected: (Skill selection) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SimpleSearchSericeProvider(
                                              selection.skillName.toString(),
                                              false)));
                                },
                                optionsViewBuilder: (BuildContext context,
                                    AutocompleteOnSelected<Skill> onSelected,
                                    Iterable<Skill> options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      child: Container(
                                        width: 300,
                                        color: Colors.white,
                                        child: ListView.builder(
                                          padding: EdgeInsets.all(10.0),
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final Skill option =
                                                options.elementAt(index);

                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: ListTile(
                                                title: Text(option.skillName,
                                                    style: const TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showBottomSheetApply(context);
                            },
                            child: Container(
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 209, 208, 208),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              child: Image.asset(
                                "assets/ic_advance_search.png",
                                color: Colors.white,
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
            Positioned(
              // ignore: sort_child_properties_last
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 140,
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                    ),
                    items: listBannerImages
                        .cast<String>()
                        .map((item) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: CachedNetworkImage(
                                imageUrl: item,
                                width: MediaQuery.of(context).size.width,
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
                  ),
                ),
              ),
              right: 0,
              left: 0,
              bottom: -100,
            ),
          ],
        ),
      ),
    );
  }

  void getBannerList() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    late ResponseLoginUser responseLoginUser =
        responseLoginUserFromJson(user_data!);
    print("BaannerImages${responseLoginUser.user.bannerImages}");
    for (var bannerImage in responseLoginUser.user.bannerImages) {
      String ImageUrl = "${AppConstants.BANNERIMAGESURLS}$bannerImage.jpg";
      print("BannerImage$ImageUrl");
      listBannerImages
          .add("https://pakapi.odlay.com/public/images/banners/banner1.jpg");
    }
  }

  _showBottomSheetApply(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Column(
            children: [
              Container(
                width: 60,
                color: Colors.grey,
                margin: const EdgeInsets.only(
                    bottom: 10, top: 20, left: 10, right: 10),
                child: Image.asset(
                  "assets/ic_edit_screen_line.png",
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 4,
                ),
              ),
              Text("Search With Filter",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Color.fromRGBO(255, 118, 87, 1),
                          fontSize: 17,
                          fontWeight: FontWeight.bold))),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                color: const Color.fromARGB(255, 230, 230, 230),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'plzz enter budget';
                    }
                    return null;
                  },
                  // controller: budgetAmount,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      fillColor: const Color.fromARGB(255, 230, 230, 230),
                      filled: true,
                      hintText: 'search_by_b_name'.tr,
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 230, 230, 230),
                            width: 0.5),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 230, 230, 230),
                            width: 0.7),
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  SelectDialog.showModal<Skill>(
                    context,
                    label: "Select Skills",
                    items: skillCitiesProfessions.skills,
                    onChange: (Skill skill) {
                      setState(() {
                        _selectedSkill.add(skill.skillName.toString());
                      });
                    },
                  );
                },
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const ListTile(
                    title: Text(
                      "Select Skills",
                      style: TextStyle(color: Colors.grey),
                    ),
                    leading: Icon(Icons.settings_accessibility),
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: ChipList(
                  listOfChipNames: _selectedSkill,
                  activeBgColorList: const [Color.fromARGB(255, 210, 209, 209)],
                  inactiveBgColorList: const [
                    Color.fromARGB(255, 210, 209, 209)
                  ],
                  activeTextColorList: const [Colors.white],
                  inactiveTextColorList: const [Colors.white],
                  listOfChipIndicesCurrentlySeclected: const [0],
                  activeBorderColorList: const [
                    Color.fromARGB(255, 210, 209, 209)
                  ],
                  shouldWrap: true,
                  runSpacing: 10,
                ),
              ),
              Container(
                height: 35,
                margin: const EdgeInsets.only(top: 5),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 0.30),
                  ),
                  child: DropdownButton<String>(
                    onChanged: (value) {},
                    value: dropdownValue,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    items: spinnerItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: ListTile(
                              title: TextField(
                                // controller: address,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10.0),
                                  border: InputBorder.none,
                                  filled: false,
                                  hintText: "Enter address",
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                              leading: const Icon(Icons.search),
                            ))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            color: Colors.grey[200],
                            child: Image.asset(
                              "assets/ic_pickmylocation.png",
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: 55,
                            )))
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: Styles.appElevatedJobStatusButtonStyle,
                        onPressed: () {},
                        child: const Text('Reset'),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: Styles.appElevatedJobStatusButtonStyle,
                        onPressed: () {},
                        child: const Text('Apply'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ));
        });
  }
}
