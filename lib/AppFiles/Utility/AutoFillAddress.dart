import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';

class AutoFillAddress {
  static String autoLocationAddress = "";
  static String autoLocationLocality = "";
  static String autoLocationSubAdmin = "";
  static double autoLocationLat = 0.0;
  static double autoLocationLong = 0.0;
  static bool autoLocationAvaviable = false;
//function to get cityId and cityName

  static Future<CityIdName> getCityIdName(String locality, String SubAdmin,
      SkillCitiesProfessions skillCitiesProfessions) async {
    int cityId = 0;
    String cityName = "";
    String city_name,city_name1;
    for (var i = 0; i < skillCitiesProfessions.city.length; i++) {
      city_name = skillCitiesProfessions.city[i].cityTitle.toString();
      city_name1 = skillCitiesProfessions.city[i].cityTitle2.toString();
      if (city_name == locality || city_name == SubAdmin) {
        cityId = skillCitiesProfessions.city[i].cityId;
        cityName = city_name;
        print("CityId$cityId");
      }
      else if(city_name1 == locality || city_name1 == SubAdmin){
cityId = skillCitiesProfessions.city[i].cityId;
        cityName = city_name;
        print("CityId$cityId");
      }
      print("CityName$city_name");
    }
    return new CityIdName(cityId, cityName);
  }
}
