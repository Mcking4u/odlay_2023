import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/ViewAllCategories/_view_all_categories.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SearchPages/_simple_search_serice_provider.dart';
import 'package:get/get.dart';

class HomePageCategories extends StatefulWidget {
  @override
  State<HomePageCategories> createState() => _HomePageCategoriesState();
}

class _HomePageCategoriesState extends State<HomePageCategories> {
  late SkillCitiesProfessions skillCitiesProfessions;
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(user_data!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'categories'.tr,
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewAllCategories()));
                  }),
                  child: Text(
                    'view_all'.tr,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: 100,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: skillCitiesProfessions.professions.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 100,
                      width: 100,
                      child: GestureDetector(
                        onTap: () {
                          print(
                              "OpneSinpleSearch${skillCitiesProfessions.professions[index].professionName.toString()}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SimpleSearchSericeProvider(
                                  skillCitiesProfessions
                                      .professions[index].professionId
                                      .toString(),
                                  true)));
                        },
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Image.network(
                                  AppConstants.PROFESSIONIMAGESURLS +
                                      skillCitiesProfessions
                                          .professions[index].professionImage
                                          .toString(),
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: 60,
                                ),
                                Text(
                                    skillCitiesProfessions
                                        .professions[index].professionName
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)))
                              ],
                            )),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
