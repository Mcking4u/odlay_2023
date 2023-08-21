import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/AutoFillAddress.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/GetChatMessagesJob.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationPromt.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_invite_on_job.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_my_jobs_summary.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_post_job_vs_service_provider.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_update_address.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/model/UtilityModels/CityIdAndName.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_chat_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/DirectHire/_direct_hire_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as userCurrentLocation;
import 'package:google_maps_webservice/places.dart';

class HeaderProfileWidget extends StatefulWidget {
  ResposneServiceProviderProfile _resposneServiceProviderProfile;
  BuildContext mainPageContext;
  HeaderProfileWidget(
      this._resposneServiceProviderProfile, this.mainPageContext);

  @override
  State<HeaderProfileWidget> createState() => _HeaderProfileWidgetState();
}

class _HeaderProfileWidgetState extends State<HeaderProfileWidget> {
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  AppController _appController = Get.put(AppController());
  //update address
  TextEditingController filterAddress = TextEditingController();
  late int? appRegion;
  late double filterSearchLatitude, filtersearchLongitude;
  String filterCityName = "";
  int filterCityId = 0;
  String apiKeyAutoCompleteSearch = 'AIzaSyDjBU-oor10ZAk-cq0CEGOFStPFaRq_T-M';
  late var _places;
  late bool _serviceEnabled;
  late userCurrentLocation.PermissionStatus _permissionGranted;
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    String? userSkills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    responseLoginUser = responseLoginUserFromJson(userData!);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(userSkills!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    _places = GoogleMapsPlaces(apiKey: apiKeyAutoCompleteSearch);
    appRegion =Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          AppConstants.PROFILEIMAGESURLS +
                              widget._resposneServiceProviderProfile.logo
                                  .toString()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 0),
                    child: RatingBarIndicator(
                      rating:
                          widget._resposneServiceProviderProfile.rating != null
                              ? double.parse(widget
                                  ._resposneServiceProviderProfile.rating
                                  .toString())
                              : 0,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Color.fromRGBO(255, 118, 87, 1),
                      ),
                      itemCount: 5,
                      itemSize: 15.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                  Text(widget._resposneServiceProviderProfile.reviews!=null?
                  "(${widget._resposneServiceProviderProfile.reviews!.length})":
                  "(0)", style: Styles.textProfileStyle)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/ic_user.png",
                        fit: BoxFit.contain,
                        width: 20,
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                            widget._resposneServiceProviderProfile.firstName
                                .toString(),
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    color: Color.fromRGBO(255, 118, 87, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/ic_company_name.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget._resposneServiceProviderProfile.title !=
                                        null
                                    ? widget
                                        ._resposneServiceProviderProfile.title
                                        .toString()
                                    : "",
                                style: Styles.textProfileStyle),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/ic_address.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                widget._resposneServiceProviderProfile.address
                                    .toString(),
                                style: Styles.textProfileStyle),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/ic-distance.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                              "${widget._resposneServiceProviderProfile.distance}km",
                              style: Styles.textProfileStyle),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            String? userData = Constants.sharedPreferences
                                .getString(SharePrefrencesValues.SAVEDUSERDATA);
                            responseLoginUser =
                                responseLoginUserFromJson(userData!);
                            if (responseLoginUser.user.consumer.address !=
                                null) {
                              showBottomSheetMyJobsSummary(
                                  context,
                                  widget._resposneServiceProviderProfile,
                                  widget.mainPageContext);
                            } else {
                              print("show_address_sheet");
                              _bottomSheetUpdateAddress(context);
                            }
                          },
                          child: Container(
                            height: 20,
                            width: 50,
                            padding: EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromRGBO(255, 118, 87, 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'str_hire'.tr,
                                style: Styles.simpletextStyleGig,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _appController.checkJobServiceProvider(
                                QueryPostJobVsServiceProvider(
                                    consumerId: responseLoginUser
                                        .user.consumer.userId
                                        .toString(),
                                    serviceId: widget
                                        ._resposneServiceProviderProfile.id
                                        .toString()),
                                apiKey.toString());
                            print("CallAvaialbleCheck2");
                            if (_appController
                                    .responsePostJobVsServiceProvider !=
                                null) {
                              if (_appController
                                      .responsePostJobVsServiceProvider
                                      .status ==
                                  "success") {
                                if (_appController
                                        .responsePostJobVsServiceProvider
                                        .isHired ==
                                    1) {
                                  Navigator.of(AppConstants
                                          .baseContext)
                                      .push(MaterialPageRoute(
                                          builder: (context) => ChatDetailPage(
                                              widget
                                                  ._resposneServiceProviderProfile
                                                  .firstName
                                                  .toString(),
                                              widget
                                                  ._resposneServiceProviderProfile
                                                  .firebaseUid
                                                  .toString(),
                                              widget
                                                  ._resposneServiceProviderProfile
                                                  .logo
                                                  .toString(),
                                              widget
                                                  ._resposneServiceProviderProfile
                                                  .phone
                                                  .toString())));
                                } else {
                                  showToast(
                                      "Please Invite User First then Call",
                                      context: context,
                                      backgroundColor: Colors.blue);
                                }
                              } else {
                                showToast("Please Invite User First then Chat",
                                    context: context,
                                    backgroundColor: Colors.blue);
                              }
                            } else {
                              showToast("Please Try Again Later",
                                  context: context,
                                  backgroundColor: Colors.blue);
                            }
                          },
                          child: Container(
                            height: 20,
                            width: 50,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromRGBO(255, 118, 87, 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'str_chat'.tr,
                                style: Styles.simpletextStyleGig,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (widget._resposneServiceProviderProfile
                                    .allowMobileCall ==
                                1) {
                              print("CallAvaialbleCheck1");
                              await _appController.checkJobServiceProvider(
                                  QueryPostJobVsServiceProvider(
                                      consumerId: responseLoginUser
                                          .user.consumer.userId
                                          .toString(),
                                      serviceId: widget
                                          ._resposneServiceProviderProfile.id
                                          .toString()),
                                  apiKey.toString());
                              print("CallAvaialbleCheck2");
                              if (_appController
                                      .responsePostJobVsServiceProvider !=
                                  null) {
                                if (_appController
                                        .responsePostJobVsServiceProvider
                                        .status ==
                                    "success") {
                                  if (_appController
                                          .responsePostJobVsServiceProvider
                                          .isHired ==
                                      1) {
                                    Uri url = Uri(
                                        scheme: "tel",
                                        path: widget
                                            ._resposneServiceProviderProfile
                                            .phone);
                                    await launchUrl(url);
                                  } else {
                                    showToast(
                                        "Please Invite User First then Call",
                                        context: context,
                                        backgroundColor: Colors.blue);
                                  }
                                } else {
                                  showToast(
                                      "Please Invite User First then Call",
                                      context: context,
                                      backgroundColor: Colors.blue);
                                }
                              } else {
                                showToast("Please Try Again Later",
                                    context: context,
                                    backgroundColor: Colors.blue);
                              }
                            } else {
                              showToast(
                                  "This Person is not directly available on call",
                                  context: context,
                                  backgroundColor: Colors.blue);
                            }
                          },
                          child: Container(
                            height: 20,
                            width: 50,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromRGBO(255, 118, 87, 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'str_call'.tr,
                                style: Styles.simpletextStyleGig,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showBottomSheetMyJobsSummary(
      BuildContext context,
      ResposneServiceProviderProfile serviceProviders,
      BuildContext mainContext) {
    _appController.getCustomerJobsSummary(
        QueryMyJobsSummary(
            consumerId: responseLoginUser.user.consumer.userId.toString(),
            spId: serviceProviders.id.toString()),
        apiKey.toString());
    print("OpenSheet");
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
          return StatefulBuilder(builder: ((context, setState) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Image.asset(
                      "assets/ic_edit_screen_line.png",
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 2,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: AppElevatedButton(
                        width: double.infinity,
                        onPressed: () {
                          Navigator.of(mainContext).push(MaterialPageRoute(
                              builder: (context) =>
                                  DirectHirePage(serviceProviders)));
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Text('str_direct_hire'.tr +
                            ' ${serviceProviders.firstName}'),
                      )),
                  Expanded(
                    child: Obx(() {
                      if (_appController.responseMyJobsSummaryValue.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        child: _appController
                                .responseMyJobsSummary.jobsSummary.isEmpty
                            ? const Text("No Jobs Found",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))
                            : ListView.builder(
                                itemCount: _appController
                                    .responseMyJobsSummary.jobsSummary.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {},
                                      child: Stack(
                                        children: [
                                          Card(
                                            elevation: 5,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            )),
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  _appController
                                                                      .responseMyJobsSummary
                                                                      .jobsSummary[
                                                                          index]
                                                                      .title
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  'str_date_d_hire'
                                                                      .tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: Text("",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.normal)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  'str_skills_d_hire'
                                                                      .tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                    maxLines: 1,
                                                                    serviceProviders.skills !=
                                                                            null
                                                                        ? getSkillName(serviceProviders.skills)
                                                                            .substring(
                                                                                1)
                                                                        : "",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.normal)),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 10,
                                              top: 30,
                                              child: Container(
                                                child: _appController
                                                            .responseMyJobsSummary
                                                            .jobsSummary[index]
                                                            .inviteStatus ==
                                                        1
                                                    ? Container(
                                                        height: 20,
                                                        width: 50,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    151,
                                                                    151,
                                                                    151)),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'str_invited'.tr,
                                                            style: Styles
                                                                .simpletextStyleGig,
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          String chatMessageOther = sprintf(
                                                              GetChatMessageJob()
                                                                  .getChatMessage(
                                                                      FireBaseConstants
                                                                          .CU_INVITE_ON_JOB_OTHER_USER_MESSAGE),
                                                              [
                                                                responseLoginUser
                                                                    .user
                                                                    .firstName,
                                                                _appController
                                                                    .responseMyJobsSummary
                                                                    .jobsSummary[
                                                                        index]
                                                                    .title
                                                              ]);
                                                          String chatMessageCurrent = sprintf(
                                                              GetChatMessageJob()
                                                                  .getChatMessage(
                                                                      FireBaseConstants
                                                                          .CU_INVITE_ON_JOB_CURRENT_USER_MESSAGE),
                                                              [
                                                                serviceProviders
                                                                    .firstName,
                                                                _appController
                                                                    .responseMyJobsSummary
                                                                    .jobsSummary[
                                                                        index]
                                                                    .title
                                                              ]);
                                                          print("PreIvite");

                                                          await _appController.inviteSpOnJob(
                                                              QueryInviteOnJob(
                                                                  jobId: _appController
                                                                      .responseMyJobsSummary
                                                                      .jobsSummary[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  jobStatus: JobConstants.INVITED_FOR_JOB
                                                                      .toString(),
                                                                  userId: serviceProviders
                                                                      .id
                                                                      .toString()),
                                                              apiKey.toString(),
                                                              responseLoginUser
                                                                  .user
                                                                  .firebaseUid
                                                                  .toString(),
                                                              serviceProviders
                                                                  .firebaseUid
                                                                  .toString(),
                                                              chatMessageCurrent,
                                                              responseLoginUser
                                                                  .user
                                                                  .firstName
                                                                  .toString(),
                                                              FireBaseConstants
                                                                  .applyJobReward,
                                                              chatMessageOther,
                                                              context);
                                                          print("PostInvite");
                                                          _appController
                                                              .responseMyJobsSummaryValue
                                                              .value = true;
                                                          _appController
                                                              .responseMyJobsSummary
                                                              .jobsSummary[
                                                                  index]
                                                              .inviteStatus = 1;
                                                          _appController
                                                              .responseMyJobsSummaryValue
                                                              .value = false;
                                                          ;
                                                        },
                                                        child: Container(
                                                          height: 20,
                                                          width: 50,
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      118,
                                                                      87,
                                                                      1)),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'str_invite'.tr,
                                                              style: Styles
                                                                  .simpletextStyleGig,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ))
                                        ],
                                      ));
                                }),
                      );
                    }),
                  )
                ],
              ),
            );
          }));
        });
  }

  String getSkillName(List<MySkill>? mySkills) {
    String skillName = "";
    for (var skill in mySkills!) {
      skillName = skillName + "," + skill.skillName.toString();
    }
    return skillName;
  }

  _bottomSheetUpdateAddress(BuildContext context) async {
    await autoFillLocationFilter();
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
          return StatefulBuilder(builder: ((context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                  child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
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
                    Text('please_update_address'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                color: Color.fromRGBO(255, 118, 87, 1),
                                fontSize: 17,
                                fontWeight: FontWeight.normal))),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(left: 10),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 230),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/ic_search_grey.png",
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: TextField(
                                        readOnly: true,
                                        onTap: () async {
                                          Prediction? p =
                                              await PlacesAutocomplete.show(
                                            context: context,
                                            apiKey: apiKeyAutoCompleteSearch,
                                            offset: 0,
                                            radius: 1000,
                                            types: [],
                                            strictbounds: false,
                                            mode: Mode.overlay,
                                            language: "en",
                                            components: [
                                              new Component(
                                                  Component.country, "pk"),
                                              new Component(
                                                  Component.country, "fi")
                                            ],
                                          );
                                          if (p != null) {
                                            if (p.placeId
                                                .toString()
                                                .isNotEmpty) {
                                              PlacesDetailsResponse response =
                                                  await _places
                                                      .getDetailsByPlaceId(
                                                          p.placeId.toString());
                                              var location = response
                                                  .result.geometry!.location;
                                              print(
                                                  "AddressSelected${location}");
                                              filterSearchLatitude =
                                                  location.lat;
                                              filtersearchLongitude =
                                                  location.lng;
                                              try {
                                                List<geocoding.Placemark>
                                                    placemarks = await geocoding
                                                        .placemarkFromCoordinates(
                                                            filterSearchLatitude,
                                                            filtersearchLongitude);
                                                geocoding.Placemark placeMark =
                                                    placemarks.first;
                                                String? name = placeMark.name;
                                                String? subLocality =
                                                    placeMark.subLocality;
                                                String? locality =
                                                    placeMark.locality;
                                                String? administrativeArea =
                                                    placeMark
                                                        .administrativeArea;
                                                String? postalCode =
                                                    placeMark.postalCode;
                                                String? country =
                                                    placeMark.country;
                                                String? street =
                                                    placeMark.street;
                                                String? address; 
                                                if(appRegion==2){
address=
                                                    GenericAppFunctions
                                                        .removeDuplicateAddress(
                                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
                                                }
                                                else{
                                                address=
                                                    GenericAppFunctions
                                                        .removeDuplicateAddress(
                                                            "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                                }
                                                print("Lora");
                                                print(address);
                                                filterAddress.text =
                                                    address.toString();
                                                for (var i = 0;
                                                    i <
                                                        skillCitiesProfessions
                                                            .city.length;
                                                    i++) {
                                                  String city_name =
                                                      skillCitiesProfessions
                                                          .city[i].cityTitle
                                                          .toString();
                                                          String city_name1 =
                                                      skillCitiesProfessions
                                                          .city[i].cityTitle2
                                                          .toString();
                                                  if (city_name == locality ||
                                                      city_name ==
                                                          placeMark
                                                              .subAdministrativeArea) {
                                                    filterCityId =
                                                        skillCitiesProfessions
                                                            .city[i].cityId;
                                                    print(
                                                        "CityId$filterCityId");
                                                    filterCityName = city_name;
                                                  }
                                                 else if (city_name1 == locality ||
                                                      city_name1 ==
                                                          placeMark
                                                              .subAdministrativeArea) {
                                                    filterCityId =
                                                        skillCitiesProfessions
                                                            .city[i].cityId;
                                                    print(
                                                        "CityId$filterCityId");
                                                    filterCityName = city_name1;
                                                  }
                                                  print("CityName$city_name");
                                                }
                                                setState(() {
                                                  filterAddress.text = address!;
                                                });
                                              } catch (e) {
                                                showToast("Exception$e",
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.blue);
                                              }
                                            } else {
                                              showToast("No Address Selected",
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.lightBlue);
                                            }
                                          }
                                        },
                                        controller: filterAddress,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          filled: false,
                                          hintText: 'select_address'.tr,
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                  onTap: () async {
                                    print("PermissionGrandted");
                                    bool locationAgree = false;
                                    if (await Permission
                                        .locationWhenInUse.isGranted) {
                                      // Use location.
                                      locationAgree = true;
                                    } else {
                                      await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return LocationPrompt(
                                                () async {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  locationAgree = true;
                                                },
                                              );
                                            });
                                          });
                                    }
                                    print("PostAwait");
                                    if (locationAgree) {
                                      userCurrentLocation.Location location =
                                          userCurrentLocation.Location();

                                      // Check if location service is enable
                                      _serviceEnabled =
                                          await location.serviceEnabled();
                                      if (!_serviceEnabled) {
                                        _serviceEnabled =
                                            await location.requestService();
                                        if (!_serviceEnabled) {
                                          return;
                                        }
                                      }

                                      // Check if permission is granted
                                      _permissionGranted =
                                          await location.hasPermission();
                                      if (_permissionGranted ==
                                          userCurrentLocation
                                              .PermissionStatus.denied) {
                                        _permissionGranted =
                                            await location.requestPermission();
                                        if (_permissionGranted !=
                                            userCurrentLocation
                                                .PermissionStatus.granted) {
                                          return;
                                        }
                                      }

                                      final _locationData =
                                          await location.getLocation();
                                      // setState(() async {

                                      filterSearchLatitude =
                                          _locationData.latitude as double;
                                      filtersearchLongitude =
                                          _locationData.longitude as double;

                                      List<geocoding.Placemark> placemarks =
                                          await geocoding
                                              .placemarkFromCoordinates(
                                                  filterSearchLatitude,
                                                  filtersearchLongitude);
                                      geocoding.Placemark placeMark =
                                          placemarks.first;

                                      String? subLocality =
                                          placeMark.subLocality;
                                      String? locality = placeMark.locality;
                                      String? administrativeArea =
                                          placeMark.administrativeArea;
                                      String? postalCode = placeMark.postalCode;
                                      String? country = placeMark.country;
                                      String? street = placeMark.street;
                                      String? address; 
                                      if(appRegion==2){
address= GenericAppFunctions
                                          .removeDuplicateAddress(
                                              "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${country}");
                                      }
                                      else{
                                      address= GenericAppFunctions
                                          .removeDuplicateAddress(
                                              "${street} ${placeMark.thoroughfare!.trim()} ${placeMark.subThoroughfare!.trim()} ${placeMark.subLocality!.trim()} ${locality} ${placeMark.subAdministrativeArea} ${country}");
                                      }
                                      print("Fucked");
                                      print(address);
                                      String city_name;
                                      String city_name1;

                                      for (var i = 0;
                                          i <
                                              skillCitiesProfessions
                                                  .city.length;
                                          i++) {
                                        city_name = skillCitiesProfessions
                                            .city[i].cityTitle
                                            .toString();
                                            city_name1 = skillCitiesProfessions
                                            .city[i].cityTitle2
                                            .toString();
                                        if (city_name == locality) {
                                          filterCityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          filterCityName = city_name;
                                          print("CityId$filterCityId");
                                        }
                                        else if (city_name1 == locality) {
                                          filterCityId = skillCitiesProfessions
                                              .city[i].cityId;
                                          filterCityName = city_name1;
                                          print("CityId$filterCityId");
                                        }
                                        print("CityName$city_name");
                                      }
                                      setState(() {
                                        filterAddress.text = address!;
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: Image.asset(
                                      "assets/ic_pickmylocation.png",
                                      fit: BoxFit.fill,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        SelectDialog.showModal<City>(
                          context,
                          label: "Select City",
                          items: skillCitiesProfessions.city,
                          onChange: (City selectedCity) {
                            setState(() {
                              print("SelectCityId${selectedCity.cityId}");
                              print("SelectCityName${selectedCity.cityTitle}");
                              filterCityId = selectedCity.cityId;
                              filterCityName =
                                  selectedCity.cityTitle.toString();
                            });
                          },
                        );
                      },
                      child: Container(
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
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Image.asset(
                                              "assets/ic_address_grey.png",
                                              fit: BoxFit.contain,
                                              width: 20,
                                              height: 20,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        filterCityName,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('note_address'.tr,
                            style: Styles.noteTextColorAddress),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: AppElevatedButton(
                              borderRadius: BorderRadius.circular(20),
                              onPressed: () async {
                                print("SelectCityId${filterCityId}");
                                print("SelectCityName${filterCityName}");
                                print("PreUpdateAddress");
                                await _appController.updateAddress(
                                    QueryUpdateAddress(
                                        cityId: filterCityId,
                                        fullAddress:
                                            filterAddress.text.toString(),
                                        isServiceProvider: 0,
                                        id: responseLoginUser
                                            .user.serviceProviders.userId,
                                        latitude:
                                            filterSearchLatitude.toString(),
                                        longitude:
                                            filtersearchLongitude.toString()),
                                    apiKey.toString());
                                print("PostUpdateAddress");
                                await _appController.updateProfile(
                                    responseLoginUser.user.id.toString(),
                                    responseLoginUser.user.language,
                                    apiKey.toString());
                                Navigator.pop(context);
                              },
                              child: const Text('Update'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
            );
          }));
        });
  }

  Future autoFillLocationFilter() async {
    if (AutoFillAddress.autoLocationAvaviable) {
      filterAddress.text = AutoFillAddress.autoLocationAddress;
      filterSearchLatitude = AutoFillAddress.autoLocationLat;
      filtersearchLongitude = AutoFillAddress.autoLocationLong;
      CityIdName cityIdName = await AutoFillAddress.getCityIdName(
          AutoFillAddress.autoLocationLocality,
          AutoFillAddress.autoLocationSubAdmin,
          skillCitiesProfessions);
      filterCityId = cityIdName.cityId;
      filterCityName = cityIdName.cityName;
    }
  }
}
