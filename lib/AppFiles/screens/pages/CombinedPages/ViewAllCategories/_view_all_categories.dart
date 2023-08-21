import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/ViewAllCategories/_view_all_categories_header.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_homepager_header.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_simple_search_serice_provider.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:get/get.dart';

class ViewAllCategories extends StatefulWidget {
  @override
  State<ViewAllCategories> createState() => _ViewAllCategoriesState();
}

class _ViewAllCategoriesState extends State<ViewAllCategories> {
  late SkillCitiesProfessions skillCitiesProfessions;

  @override
  void initState() {
    String? userSkillsData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkillsData!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomePageHeader(false),
          const SizedBox(
            height: 106,
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'view_all'.tr,
                style: Styles.headingText,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (3 / 1),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                //physics:BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                children: skillCitiesProfessions.professions
                    .map(
                      (profession) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SimpleSearchSericeProvider(
                                        profession.professionId.toString(),
                                        true)));
                          },
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            elevation: 5,
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  Image.network(
                                    AppConstants.PROFESSIONIMAGESURLS +
                                        profession.professionImage.toString(),
                                    fit: BoxFit.fill,
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                        profession.professionName.toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                  )
                                ],
                              ),
                            ),
                          )),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
