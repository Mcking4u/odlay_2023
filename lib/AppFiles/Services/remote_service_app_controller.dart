import 'package:http/http.dart' as http;
import 'package:odlay_services/AppFiles/Utility/ApiPathsConstats.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';

class RemoteServicesAppController {
  static var client = http.Client();
  static Future<SkillCitiesProfessions?> getSkillCitiesProfessiona(
      int codeLang, String apiKey) async {
    print("AuthrizationPrimary${AppConstants.AUTHOEIZATION_KEY_PRIMARY}");
    print("AuthrizationToken${AppConstants.AUTHOEIZATION_BEARER} $apiKey");
    var uri = Uri.parse(
            "${AppConstants.base_api_url}${ApiPathsConstant.GETALLSKILLS}")
        .replace(queryParameters: {"language": codeLang.toString()});
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization-Primary": AppConstants.AUTHOEIZATION_KEY_PRIMARY,
      "Authorization": "${AppConstants.AUTHOEIZATION_BEARER} $apiKey"
    });
    if (response.statusCode == 200) {
      print("ResponseHeader${response.headers}");
      var jsontring = response.body;
      print("Resposne_Received${jsontring}");
      Constants.sharedPreferences
          .setString(SharePrefrencesValues.SKILLCITIESCATGORIES, jsontring);
      return skillCitiesProfessionsFromJson(jsontring);
    } else {
      print("ResponseHeader${response.headers}");
      print("Not_Received${response.statusCode}");

      return null;
    }
  }
}
