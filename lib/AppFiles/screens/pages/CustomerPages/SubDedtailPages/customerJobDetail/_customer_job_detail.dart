import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/GetChatMessagesJob.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/JobDetailModels/ResponseJobDetail.dart';
import 'package:odlay_services/AppFiles/model/JobDetailModels/_query_job_detail.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_invite_on_job.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_chat_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/customerJobDetail/_bottom_sheet_job_detail.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import '../VisitProfilePages/_profile_page.dart';

class CustomerJobDetail extends StatefulWidget {
  bool viewTypeSp;
  String jobId;
  CustomerJobDetail(this.jobId, this.viewTypeSp);
  @override
  State<CustomerJobDetail> createState() => _CustomerJobDetailState(jobId);
}

class _CustomerJobDetailState extends State<CustomerJobDetail> {
  String jobId;
  _CustomerJobDetailState(this.jobId);
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  AppController _appController = Get.put(AppController());
  late String? apiKey;
  int? appRegion;
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    print("ServiceId${responseLoginUser.user.serviceProviders.userId}");
    String? user_skills = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(user_skills!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    print("APiKEYJibDetail${apiKey}");
    print("ReceivedJobId${jobId}");
    _appController.getJobDetail(
        QueryJobDetail(jobId: jobId), apiKey.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('job_detail_app_bar'.tr),
          backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          )),
        ),
        body: Obx(() {
          if (_appController.isJobDetailLoading.value) {
            return Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: const CircularProgressIndicator()),
            );
          }

          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .62,
                    width: double.infinity,
                    color: Colors.blue,
                    child: GoogleMap(
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              double.parse(_appController
                                  .responseJobDetail!.jobdetail.latitude
                                  .toString()),
                              double.parse(_appController
                                  .responseJobDetail!.jobdetail.longitude
                                  .toString())),
                          zoom: 15.5),
                      markers: Set<Marker>.of(addMarkerJobMarker(
                          double.parse(_appController
                              .responseJobDetail!.jobdetail.latitude
                              .toString()),
                          double.parse(_appController
                              .responseJobDetail!.jobdetail.longitude
                              .toString()))),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .38,
                    right: 0.0,
                    left: 0.0),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      BottomSheetJobDetail(_appController.responseJobDetail,
                          responseLoginUser, skillCitiesProfessions),
                      Positioned(
                          right: 20,
                          child: AppConstants.isSlectedUserCustomer
                              ? Container(
                                  child: Row(children: [
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: const ShapeDecoration(
                                          shape: CircleBorder(),
                                          color:
                                              Color.fromRGBO(255, 118, 87, 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Image.asset(
                                            "assets/ic_cross_flutter_white.png",
                                            fit: BoxFit.contain,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      width: 35,
                                      height: 35,
                                      decoration: const ShapeDecoration(
                                          shape: CircleBorder(),
                                          color:
                                              Color.fromRGBO(255, 118, 87, 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Image.asset(
                                          "assets/ic_share_flutter_white.png",
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showBottomSheetRecomendedServiceProvider(
                                            context,
                                            _appController.responseJobDetail);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        width: 35,
                                        height: 35,
                                        decoration: const ShapeDecoration(
                                            shape: CircleBorder(),
                                            color: Color.fromRGBO(
                                                255, 118, 87, 1)),
                                        child: Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Image.asset(
                                            "assets/ic_recommended_flutter_white.png",
                                            fit: BoxFit.contain,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                )
                              : Container())
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }

  showBottomSheetRecomendedServiceProvider(
      BuildContext context, ResponseJobDetail? responseJobDetail) {
    _appController.getSkillRecomendedJob(
        responseJobDetail!.jobdetail.cityId.toString(),
        jobId,
        "customer",
        responseLoginUser.user.language.toString(),
        responseJobDetail.jobdetail.latitude.toString(),
        responseJobDetail.jobdetail.longitude.toString(),
        "1",
        "1",
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
                  Expanded(
                    child: Obx(() {
                      if (_appController.isLoadingRecomServiceProvider.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        child:
                            _appController.SpRecomdedtopRatedServiceProviders!
                                    .serviceproviders.data.isEmpty
                                ? const Text("No Recomended Providers Found",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))
                                : ListView.builder(
                                    itemCount: _appController
                                        .SpRecomdedtopRatedServiceProviders!
                                        .serviceproviders
                                        .data
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () {
                                            print("OpenRecomedPage${_appController
                                                .SpRecomdedtopRatedServiceProviders!
                                                .serviceproviders
                                                .data[
                                            index].id}");
                                            Datum serviceProvider = Datum(
                                                id: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].id,
                                                firebaseUid:
                                                _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].firebaseUid.toString(),
                                                deviceToken: "",
                                                serviceId: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].id,
                                                address: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].address,
                                                cityId: 3,
                                                streetNo: "",
                                                latitude: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].latitude,
                                                longitude: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].longitude,
                                                defaultView: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].logo.toString(),
                                                title: "",
                                                companyId: 1,
                                                email: "",
                                                firstName: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].firstName,
                                                lastName: "",
                                                logo: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].logo,
                                                phone: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].phone,
                                                roleId: 1,
                                                status: 1,
                                                idCardStatus: _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].idCardStatus,
                                                addressProofStatus:
                                                _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].addressProofStatus,
                                                profilePicStatus:
                                                _appController
                                                    .SpRecomdedtopRatedServiceProviders!
                                                    .serviceproviders
                                                    .data[
                                                index].profilePicStatus,
                                                portfolioImages: "",
                                                allowMobileCall: 1,
                                                rating: "3",
                                                distance: 1000,
                                                reviewsCount: 3,
                                                spcount: 1);

                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileLandingVisitPage(
                                                            serviceProvider)));
                                          },
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 80,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 30,
                                                                backgroundImage: NetworkImage(AppConstants
                                                                        .PROFILEIMAGESURLS +
                                                                    _appController
                                                                        .SpRecomdedtopRatedServiceProviders!
                                                                        .serviceproviders
                                                                        .data[
                                                                            index]
                                                                        .logo
                                                                        .toString()),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  RatingBarIndicator(
                                                                rating: _appController
                                                                    .SpRecomdedtopRatedServiceProviders!
                                                                    .serviceproviders
                                                                    .data[
                                                                index].rating!=null?
                                                                double.parse(_appController
                                                                    .SpRecomdedtopRatedServiceProviders!
                                                                    .serviceproviders
                                                                    .data[
                                                                index].rating.toString()):
                                                                0,
                                                                itemBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                          .orange[
                                                                      900],
                                                                ),
                                                                itemCount: 5,
                                                                itemSize: 12.0,
                                                                direction: Axis
                                                                    .horizontal,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          height: 130,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    _appController
                                                                        .SpRecomdedtopRatedServiceProviders!
                                                                        .serviceproviders
                                                                        .data[
                                                                            index]
                                                                        .firstName
                                                                        .toString(),
                                                                    style: GoogleFonts.roboto(
                                                                        textStyle: TextStyle(
                                                                            color: Colors.orange[
                                                                                900],
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold))),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].skills != null && _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].skills!.isNotEmpty
                                                                          ? GenericAppFunctions.getSkillNameFromSkillListRec(_appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].skills).substring(
                                                                              1)
                                                                          : "",
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                              textStyle: const TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            12,
                                                                      ))),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5,
                                                                        right:
                                                                            5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        GenericAppFunctions.getCityNameFromCityId(
                                                                            skillCitiesProfessions,
                                                                            _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].cityId),
                                                                        style: GoogleFonts.roboto(
                                                                            textStyle: const TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontSize:
                                                                              12,
                                                                        ))),
                                                                    Text(
                                                                        "${_appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].distance}km",
                                                                        style: GoogleFonts.roboto(
                                                                            textStyle: const TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold)),
                                                                        textAlign: TextAlign.end)
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        String
                                                                            chatMessageOther =
                                                                            sprintf(
                                                                                GetChatMessageJob().getChatMessage(FireBaseConstants.CU_INVITE_ON_JOB_OTHER_USER_MESSAGE),
                                                                                [
                                                                              responseLoginUser.user.firstName,
                                                                              responseJobDetail.jobdetail.title
                                                                            ]);
                                                                        String
                                                                            chatMessageCurrent =
                                                                            sprintf(
                                                                                GetChatMessageJob().getChatMessage(FireBaseConstants.CU_INVITE_ON_JOB_CURRENT_USER_MESSAGE),
                                                                                [
                                                                              _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].firstName,
                                                                              responseJobDetail.jobdetail.title
                                                                            ]);
                                                                        print(
                                                                            "PreInvite");
                                                                        await _appController.inviteSpOnJob(
                                                                            QueryInviteOnJob(
                                                                                jobId: jobId,
                                                                                jobStatus: JobConstants.INVITED_FOR_JOB.toString(),
                                                                                userId: _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].id.toString()),
                                                                            apiKey.toString(),
                                                                            responseLoginUser.user.firebaseUid.toString(),
                                                                            _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].firebaseUid.toString(),
                                                                            chatMessageCurrent,
                                                                            responseLoginUser.user.firstName.toString(),
                                                                            FireBaseConstants.applyJobReward,
                                                                            chatMessageOther,
                                                                            context);
                                                                        print(
                                                                            "PostInvite");
                                                                        _appController
                                                                            .SpRecomdedtopRatedServiceProviders!
                                                                            .serviceproviders
                                                                            .data[index]
                                                                            .appliedtojob = 1;
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].appliedtojob ==
                                                                              1
                                                                          ? Container(
                                                                              height: 20,
                                                                              width: 50,
                                                                              padding: const EdgeInsets.all(5),
                                                                              margin: const EdgeInsets.only(left: 10),
                                                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Color.fromARGB(255, 133, 131, 131)),
                                                                              child:  Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  'str_invited'.tr,
                                                                                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.normal),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              height: 20,
                                                                              width: 50,
                                                                              padding: const EdgeInsets.all(5),
                                                                              margin: const EdgeInsets.only(left: 10),
                                                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Color.fromRGBO(255, 118, 87, 1)),
                                                                              child: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  'str_invite'.tr,
                                                                                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.normal),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (_appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].appliedtojob ==
                                                                            1) {
                                                                          Navigator.of(AppConstants.baseContext)
                                                                              .push(MaterialPageRoute(builder: (context) => ChatDetailPage(_appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].firstName.toString(), _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].firebaseUid.toString(), _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].logo.toString(), _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].phone.toString())));
                                                                        } else {
                                                                          showToast(
                                                                              "Please invite User then Chat",
                                                                              context: context,
                                                                              backgroundColor: Colors.blue);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            50,
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        decoration: const BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                10)),
                                                                            color: Color.fromRGBO(
                                                                                255,
                                                                                118,
                                                                                87,
                                                                                1)),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Text(
                                                                            'chat'.tr,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 8,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        print(
                                                                            "Make a call");
                                                                        if (_appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].allowMobileCall ==
                                                                            1) {
                                                                          print(
                                                                              "CallAvaiable");
                                                                          if (_appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].appliedtojob ==
                                                                              1) {
                                                                            print("Make A call here");
                                                                            Uri url =
                                                                                Uri(scheme: "tel", path: AppConstants.APP_NUMBER);
                                                                            await launchUrl(url);
                                                                          } else {
                                                                            showToast("Please Invite User First",
                                                                                context: context,
                                                                                backgroundColor: Colors.blue);
                                                                          }
                                                                        } else {
                                                                          showToast(
                                                                              "Call is not avaible",
                                                                              context: context,
                                                                              backgroundColor: Colors.blue);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            50,
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        decoration: const BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                10)),
                                                                            color: Color.fromRGBO(
                                                                                255,
                                                                                118,
                                                                                87,
                                                                                1)),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Text(
                                                                            'call'.tr,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 8,
                                                                                fontWeight: FontWeight.normal),
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                appRegion == 2
                                                    ? Container()
                                                    : Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: isUserCerfified(
                                                                _appController
                                                                    .SpRecomdedtopRatedServiceProviders!
                                                                    .serviceproviders
                                                                    .data[index]
                                                                    .idCardStatus,
                                                                _appController
                                                                    .SpRecomdedtopRatedServiceProviders!
                                                                    .serviceproviders
                                                                    .data[index]
                                                                    .addressProofStatus,
                                                                _appController
                                                                    .SpRecomdedtopRatedServiceProviders!
                                                                    .serviceproviders
                                                                    .data[index]
                                                                    .profilePicStatus)
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                    "fully Verfied",
                                                                    style: GoogleFonts.roboto(
                                                                        textStyle: const TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                  Image.asset(
                                                                    "assets/ic_fully_varified.PNG",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 30,
                                                                    height: 30,
                                                                  )
                                                                ],
                                                              )
                                                            : Row(
                                                                children: [
                                                                  Text(
                                                                    "partially Verfied",
                                                                    style: GoogleFonts.roboto(
                                                                        textStyle: const TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                  Image.asset(
                                                                    "assets/ic_partical_varified.PNG",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 30,
                                                                    height: 30,
                                                                  )
                                                                ],
                                                              ))
                                              ],
                                            ),
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

  bool isUserCerfified(
      int? idCardStatus, int? addressStatus, int? profileStatus) {
    bool userCertified = false;
    if (idCardStatus == 1 && addressStatus == 1 && profileStatus == 1) {
      userCertified = true;
    } else {
      userCertified = false;
    }
    return userCertified;
  }

  List<Marker> addMarkerJobMarker(double jobLat, double jobLng) {
    List<Marker> _markers = <Marker>[];
    print("AddMarker");
    _markers.add(Marker(
      onTap: (() => {}),
      markerId: MarkerId('JobLocation'),
      position: LatLng(jobLat, jobLng),
      icon: BitmapDescriptor.defaultMarkerWithHue(10.0),
    ));

    return _markers;
  }
}
