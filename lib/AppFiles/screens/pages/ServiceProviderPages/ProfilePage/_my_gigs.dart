import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_edit_gig.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/GigDetailPage/_gig_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_gig_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_create_gig_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_item_my_gig.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:get/get.dart';

class MyGigs extends StatefulWidget {
  BuildContext mainContext;
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  MyGigs(this.mainContext, this._resposneServiceProviderProfile);

  @override
  State<MyGigs> createState() => _MyGigsState();
}

class _MyGigsState extends State<MyGigs> {
  final _customViewKey = GlobalKey<_MyGigsState>();

  callback(SpGig gig, String clickType, String gigStatus) async {
    print("GigTitle${gig.gigTitle}");
    print("ClickedType${clickType}");
    print("gigStatus${gigStatus}");
    if (clickType == AppConstants.GIGSTATUS) {
      if (gigStatus == AppConstants.ACTVIESTATUS.toString()) {
        await _appController.editGig(
            QueryEditGig(
                apiKey: apiKey,
                gigId: gig.gigId.toString(),
                editType: "status_change",
                status: AppConstants.ACTVIESTATUS),
            apiKey.toString());
        int gigIndex = widget._resposneServiceProviderProfile.gigs!
            .indexWhere((Gig) => Gig.gigId == gig.gigId);
        print(
            "SlectedGigName${widget._resposneServiceProviderProfile.gigs![gigIndex].gigTitle}");
        widget._resposneServiceProviderProfile.gigs![gigIndex].status =
            AppConstants.ACTVIESTATUS;
        refreshState();
      } else if (gigStatus == AppConstants.DEACTVIESTATUS.toString()) {
        await _appController.editGig(
            QueryEditGig(
                apiKey: apiKey,
                gigId: gig.gigId.toString(),
                editType: "status_change",
                status: AppConstants.DEACTVIESTATUS),
            apiKey.toString());
        int gigIndex = widget._resposneServiceProviderProfile.gigs!
            .indexWhere((Gig) => Gig.gigId == gig.gigId);
        print(
            "SlectedGigName${widget._resposneServiceProviderProfile.gigs![gigIndex].gigTitle}");
        widget._resposneServiceProviderProfile.gigs![gigIndex].status =
            AppConstants.DEACTVIESTATUS;
        refreshState();
      } else {
        await _appController.editGig(
            QueryEditGig(
                apiKey: apiKey,
                gigId: gig.gigId.toString(),
                editType: "status_change",
                status: AppConstants.DEACTVIESTATUS),
            apiKey.toString());
        // widget._resposneServiceProviderProfile.gigs!.remove(gig);
        // setState(() {});
      }
      print("showDropDown");
    } else if (clickType == AppConstants.DELTEGIG) {
      print("DELTEGIG");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Delete service"),
          content: const Text("Are you sure you want Delete this Service!"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                print("PreDelete");
                await _appController.editGig(
                    QueryEditGig(
                        apiKey: apiKey,
                        gigId: gig.gigId.toString(),
                        editType: "status_change",
                        status: AppConstants.DELETEGIGSTATUS),
                    apiKey.toString());
                widget._resposneServiceProviderProfile.gigs!.remove(gig);
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Text(
                  "Yes",
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print("EditGig");
      Navigator.of(widget.mainContext).push(
          MaterialPageRoute(builder: (context) => CreateGigPage(true, gig)));
    }

    print("SetState");
  }

  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  AppController _appController = Get.put(AppController());

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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            height: 40,
            width: double.infinity,
            child: AppElevatedButton(
              borderRadius: BorderRadius.circular(20),
              onPressed: () {
//make refresh data again
                String? userSavedData = Constants.sharedPreferences
                    .getString(SharePrefrencesValues.SAVEDUSERDATA);
                ResponseLoginUser responseLoginUserRefresh =
                    responseLoginUserFromJson(userSavedData!);
                if (responseLoginUserRefresh.user.serviceProviders.address !=
                    null) {
                  if (responseLoginUser.user.skills != null &&
                      responseLoginUser.user.skills!.isEmpty) {
                    showSnackBarCompletedProfil(
                        "Please update your business address and skills before you can create gigs or apply for a job");
                  } else {
                    Navigator.of(widget.mainContext).push(MaterialPageRoute(
                        builder: (context) => CreateGigPage(false, null)));
                  }
                } else {
                  showSnackBarCompletedProfil(
                      "Please update your business address and skills before you can create gigs or apply for a job");
                }
              },
              child: Text(
                'btn_post_service'.tr,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ),
          Expanded(
            child: widget._resposneServiceProviderProfile.gigs != null
                ? Container(
                    child: ListView.builder(
                        itemCount:
                            widget._resposneServiceProviderProfile.gigs!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              print(
                                  "ClikcedGig${widget._resposneServiceProviderProfile.gigs![index]}");
                              Navigator.of(widget.mainContext).push(
                                  MaterialPageRoute(
                                      builder: (context) => UserGigDetailPage(
                                          widget._resposneServiceProviderProfile
                                              .gigs![index].gigId
                                              .toString(),
                                          responseLoginUser
                                              .user.serviceProviders.serviceId
                                              .toString(),
                                          true,
                                          widget._resposneServiceProviderProfile
                                              .gigs![index].gigPrice)));
                            },
                            child: ItemMyGig(
                                widget._resposneServiceProviderProfile
                                    .gigs![index],
                                callback,
                                widget._resposneServiceProviderProfile.rating !=
                                        null
                                    ? double.parse(widget
                                        ._resposneServiceProviderProfile.rating
                                        .toString())
                                    : 0.0),
                          );
                        }),
                  )
                : Container(
                    child: const Text(
                      "No Gig Found",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  void showSnackBarCompletedProfil(String snackMsg) {
    final snackBar = SnackBar(
      content: Text(snackMsg),
      backgroundColor: (Colors.red),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void refreshState() {
    setState(() {});
  }
}
