import 'package:blurry/blurry.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/GetChatMessagesJob.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/ApplyJob/_change_job_status.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/PostJobModel/_query_delete_job.dart';
import 'package:odlay_services/AppFiles/model/ProfileModel/_query_invite_on_job.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_chat_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/_job_post_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/customerJobDetail/_customer_job_detail.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:sprintf/sprintf.dart';
import 'package:odlay_services/AppFiles/model/TopRatedServiceProvider/_topRatedServiceProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';

class CustomerOpenJobs extends StatefulWidget {
  BuildContext mainContext;
  CustomerOpenJobs(this.mainContext);
  @override
  State<CustomerOpenJobs> createState() => _CustomerOpenJobsState();
}

class _CustomerOpenJobsState extends State<CustomerOpenJobs> {
  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  late String? apiKey;
  int? appRegion;

  AppController _appController = Get.put(AppController());
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    String? skillData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skillData!);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    print("CustomerOpenJobSize${JobConstants.list_cus_open_jobs.length}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 1), () async {
          print("RefreshViewCalled");
          await _appController.getCustomerJobs(
              QueryCustomersShowJobs(
                  apiKey: apiKey.toString(),
                  userId:
                      responseLoginUser.user.serviceProviders.userId.toString(),
                  language: responseLoginUser.user.language,
                  callFrom: "refresh"),
              apiKey.toString(),
              false);
          setState(() {});
        });
      },
      child: ListView.builder(
        itemCount: JobConstants.list_cus_open_jobs.length,
        itemBuilder: (context, index) {
          return ExpansionTileCard(
            expandedColor: Colors.grey[200],
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: circleRadius / 12.0),
                    child: Container(
                      margin: const EdgeInsets.only(left: 0, right: 0),
                      child: Card(
                        child: Container(
                          margin: const EdgeInsets.only(top: 5, left: 5),
                          width: double.infinity,
                          height: 100,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerJobDetail(
                                                    JobConstants
                                                        .list_cus_open_jobs[
                                                            index]
                                                        .id
                                                        .toString(),
                                                    false)));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      size: 18,
                                                      color: Color.fromRGBO(
                                                          255, 118, 87, 1),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                    text: JobConstants
                                                        .list_cus_open_jobs[
                                                            index]
                                                        .title,
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 2, child: Container())
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 20,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  'created_at'.tr,
                                                  style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey)),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                JobConstants
                                                            .list_cus_open_jobs[
                                                                index]
                                                            .createdAt !=
                                                        null
                                                    ? "${GenericAppFunctions.getFormattedDate(JobConstants.list_cus_open_jobs[index].createdAt.toString())}"
                                                    : "",
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'job_deadline'.tr,
                                              style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              JobConstants
                                                          .list_cus_open_jobs[
                                                              index]
                                                          .deadline !=
                                                      null
                                                  ? GenericAppFunctions
                                                      .getFormattedDate(
                                                          JobConstants
                                                              .list_cus_open_jobs[
                                                                  index]
                                                              .deadline
                                                              .toString())
                                                  : "",
                                              style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ),
                                          )
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  'budget'.tr,
                                                  style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey)),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                responseLoginUser
                                                        .user.currencySymbol
                                                        .toString() +
                                                    JobConstants
                                                        .list_cus_open_jobs[
                                                            index]
                                                        .budget
                                                        .toString(),
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 20,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'applicant_list'.tr,
                                                style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                JobConstants
                                                        .list_cus_open_jobs[
                                                            index]
                                                        .jobApplicants!
                                                        .isEmpty
                                                    ? ""
                                                    : JobConstants
                                                        .list_cus_open_jobs[
                                                            index]
                                                        .jobApplicants!
                                                        .length
                                                        .toString(),
                                                style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .orange[900])),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print("OpenTopRatedServiceProviders");
                                        showBottomSheetRecomendedServiceProvider(
                                            context,
                                            JobConstants
                                                .list_cus_open_jobs[index]);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color:
                                                Color.fromRGBO(255, 118, 87, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        child: Text(
                                          'str_btn_invit_top_rated'.tr,
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10)),
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down_sharp,
                                        size: 20, color: Colors.red)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delet Job"),
                                content: const Text(
                                    "Are you sure you want Delete this Job!"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                      print("PreDelete");
                                      await _appController.deleteJob(
                                          QueryDeleteJob(
                                              apiKey: apiKey,
                                              id: JobConstants
                                                  .list_cus_open_jobs[index].id
                                                  .toString(),
                                              language: responseLoginUser
                                                  .user.language),
                                          apiKey.toString());
                                      setState(() {
                                        JobConstants.list_cus_open_jobs.remove(
                                            JobConstants
                                                .list_cus_open_jobs[index]);
                                      });
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

                            print("PostDelete");
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                                color: Color.fromRGBO(255, 118, 87, 1)),
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Image.asset(
                                "assets/ic_job_delete.png",
                                color: Colors.white,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("OpenjobEditMode");
                            Navigator.of(widget.mainContext).push(
                                MaterialPageRoute(
                                    builder: (context) => JobPostPage(
                                        JobConstants.list_cus_open_jobs[index],
                                        true)));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 30,
                            height: 30,
                            decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                                color: Color.fromRGBO(255, 118, 87, 1)),
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Image.asset(
                                "assets/ic_job_edit.png",
                                color: Colors.white,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
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
            trailing: const SizedBox.shrink(),
            children: <Widget>[
              Column(
                children: _buildExpandableContent(
                    context, JobConstants.list_cus_open_jobs[index], index),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildExpandableContent(BuildContext context,
      ResponseCustomersShowJobs responseCustomersShowJobs, int jobIndex) {
    List<Widget> columnContent = [];

    for (var i = 0; i < responseCustomersShowJobs.jobApplicants!.length; i++) {
      if (responseCustomersShowJobs.jobApplicants![i].sp_job_status ==
          JobConstants.APPLICANT_WITHDRAW_REQUEST) {
        print(
            "User${responseCustomersShowJobs.jobApplicants![i].firstName} with draw his job");
      } else {
        columnContent.add(
          GestureDetector(
            onTap: () {
              print("OpenDetailSheet");
              showBottomSheetApplicantDetail(context, responseCustomersShowJobs,
                  responseCustomersShowJobs.jobApplicants![i], jobIndex);
            },
            child: Card(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    AppConstants.PROFILEIMAGESURLS +
                                        responseCustomersShowJobs
                                            .jobApplicants![i].logo
                                            .toString()),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        responseCustomersShowJobs
                                            .jobApplicants![i].firstName
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.orange[900],
                                                fontWeight: FontWeight.bold)),
                                      )),
                                  const Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_right_outlined,
                                        size: 20, color: Colors.red),
                                  )
                                ],
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          'bid_amount'.tr,
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 119, 118, 118),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          responseCustomersShowJobs
                                                      .jobApplicants![i]
                                                      .bidAmount !=
                                                  null
                                              ? responseLoginUser
                                                      .user.currencySymbol! +
                                                  responseCustomersShowJobs
                                                      .jobApplicants![i]
                                                      .bidAmount
                                                      .toString()
                                              : "",
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ))
                                  ],
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          'total_payable_amount'.tr,
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          responseCustomersShowJobs
                                                      .jobApplicants![i]
                                                      .totalCharged !=
                                                  null
                                              ? responseLoginUser
                                                      .user.currencySymbol! +
                                                  responseCustomersShowJobs
                                                      .jobApplicants![i]
                                                      .totalCharged
                                                      .toString()
                                              : "",
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'no_of_days'.tr,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 119, 118, 118),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          responseCustomersShowJobs
                                              .jobApplicants![i].duration
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
          ),
        );
      }
    }

    return columnContent;
  }

  showBottomSheetRecomendedServiceProvider(BuildContext context,
      ResponseCustomersShowJobs responseCustomersShowJobs) {
    _appController.getSkillRecomendedJob(
        responseCustomersShowJobs.cityId.toString(),
        responseCustomersShowJobs.id.toString(),
        "customer",
        responseLoginUser.user.language.toString(),
        responseCustomersShowJobs.latitude.toString(),
        responseCustomersShowJobs.longitude.toString(),
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

                                            Navigator.of(widget.mainContext).push(
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
                                                                rating:  _appController
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
                                                                        print(
                                                                            "PreInvite");
                                                                        String
                                                                            chatMessageOther =
                                                                            sprintf(
                                                                                GetChatMessageJob().getChatMessage(FireBaseConstants.CU_INVITE_ON_JOB_OTHER_USER_MESSAGE),
                                                                                [
                                                                              responseLoginUser.user.firstName,
                                                                              responseCustomersShowJobs.title
                                                                            ]);
                                                                        String
                                                                            chatMessageCurrent =
                                                                            sprintf(
                                                                                GetChatMessageJob().getChatMessage(FireBaseConstants.CU_INVITE_ON_JOB_CURRENT_USER_MESSAGE),
                                                                                [
                                                                              _appController.SpRecomdedtopRatedServiceProviders!.serviceproviders.data[index].firstName,
                                                                              responseCustomersShowJobs.title
                                                                            ]);

                                                                        await _appController.inviteSpOnJob(
                                                                            QueryInviteOnJob(
                                                                                jobId: responseCustomersShowJobs.id.toString(),
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
                                                                              child: Align(
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
                                                                            'str_chat'.tr,
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
                                                                              "Call is not avaialble",
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
                                                                            'str_call'.tr,
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

  showBottomSheetApplicantDetail(
      BuildContext context,
      ResponseCustomersShowJobs responseCustomersShowJobs,
      JobApplicant jobApplicant,
      int jobIndex) {
    print("OpenSheet");
    print("JobObject${responseCustomersShowJobs.toString()}");
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
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
                  width: 50,
                  height: 5,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Image.asset(
                    "assets/ic_edit_screen_line.png",
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 2,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      responseCustomersShowJobs.title.toString(),
                      style: Styles.textStyleJobTitle,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      jobApplicant.proposalDesc!=null?
                      jobApplicant.proposalDesc.toString():
                      "",
                      style: Styles.textdescriptionStyle,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("Go to profile");
                                Datum serviceProvider = Datum(
                                    id: jobApplicant.id,
                                    firebaseUid:
                                        jobApplicant.firebaseUid.toString(),
                                    deviceToken: "",
                                    serviceId: jobApplicant.userId,
                                    address: jobApplicant.address,
                                    cityId: 3,
                                    streetNo: "",
                                    latitude: jobApplicant.latitude,
                                    longitude: jobApplicant.longitude,
                                    defaultView: jobApplicant.logo.toString(),
                                    title: "",
                                    companyId: 1,
                                    email: "",
                                    firstName: jobApplicant.firstName,
                                    lastName: "",
                                    logo: jobApplicant.logo,
                                    phone: jobApplicant.phone,
                                    roleId: 1,
                                    status: 1,
                                    idCardStatus: jobApplicant.idCardStatus,
                                    addressProofStatus:
                                        jobApplicant.addressProofStatus,
                                    profilePicStatus:
                                        jobApplicant.profilePicStatus,
                                    portfolioImages: "",
                                    allowMobileCall: 1,
                                    rating: "3",
                                    distance: 1000,
                                    reviewsCount: 3,
                                    spcount: 1);

                                Navigator.of(widget.mainContext).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileLandingVisitPage(
                                                serviceProvider)));
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    AppConstants.PROFILEIMAGESURLS +
                                        jobApplicant.logo.toString(),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: RatingBarIndicator(
                                rating: jobApplicant.rating != null
                                    ? double.parse(
                                        jobApplicant.rating.toString())
                                    : 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 218, 81, 7),
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                            )
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
                                  'expert'.tr,
                                  style: Styles.textProfileStyle,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(jobApplicant.firstName.toString(),
                                      style: Styles.textProfileStyle1),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('skills'.tr,
                                        style: Styles.textProfileStyle)),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    jobApplicant.skills != null &&
                                            jobApplicant.skills!.isNotEmpty
                                        ? populateSkills(jobApplicant.skills)
                                            .substring(1)
                                        : "",
                                    style: Styles.textProfileStyle1,
                                  ),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'location'.tr,
                      style: Styles.simpleText,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      responseCustomersShowJobs.address.toString(),
                      style: Styles.headingText,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'bid_amount'.tr,
                                  style: Styles.simpleText,
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'total_payable_amount'.tr,
                                  style: Styles.simpleText,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  jobApplicant.bidAmount != null
                                      ? responseLoginUser.user.currencySymbol
                                      .toString() +
                                      jobApplicant.bidAmount.toString()
                                      : "",
                                  style: Styles.textStyleJobSheetbudgetCustomer,
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  jobApplicant.totalCharged != null
                                      ? responseLoginUser.user.currencySymbol! +
                                      jobApplicant.totalCharged.toString()
                                      : "",
                                  style: Styles
                                      .textStyleJobSheetbudgetColoredCustomer,
                                ))
                          ],
                        ),
                      ),


                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(sprintf(
                                  responseLoginUser.user.custMessages.cust_payment_info.message,
                                  [(double.parse(responseLoginUser.user.custfee.toString())*100).toString()+" %"])+"",
                                  style: Styles.sp_note_style),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                            jobStatusMessage(
                                jobApplicant.sp_job_status, jobApplicant),
                            style: Styles.textStyleStatusColor),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(() => _appController.responseChangeJobStatus ==
                                    true
                                ? Container(
                                    child: Text(
                                      "Updating",
                                      style: Styles.headingTextColor,
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      child: manageAPiReposne()
                                          ? Container()
                                          : ElevatedButton(
                                              style: jobStatusButtonState(
                                                      jobApplicant
                                                          .sp_job_status)
                                                  ? Styles
                                                      .appElevatedJobStatusButtonStyle
                                                  : Styles
                                                      .appElevatedJobStatusButtonStyleDisable,
                                              onPressed: () {
                                                if (jobStatusButtonState(
                                                    jobApplicant
                                                        .sp_job_status)) {
                                                  Navigator.pop(context);
                                                  print("Award");
                                                  showDisclaimerDialog(
                                                      context,
                                                      responseLoginUser
                                                          .user
                                                          .custMessages
                                                          .custJobAward
                                                          .message,
                                                      responseCustomersShowJobs,
                                                      jobApplicant,
                                                      jobIndex);
                                                } else {}
                                              },
                                              child: Text('str_btn_award'.tr,
                                                  style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                            ),
                                    ),
                                  )),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: ElevatedButton(
                                    style:
                                        Styles.appElevatedJobStatusButtonStyle,
                                    onPressed: () {
                                      Navigator.of(AppConstants.baseContext)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatDetailPage(
                                                      jobApplicant.firstName
                                                          .toString(),
                                                      jobApplicant.firebaseUid
                                                          .toString(),
                                                      jobApplicant.logo
                                                          .toString(),
                                                      jobApplicant.phone
                                                          .toString())));
                                    },
                                    child: Text('chat'.tr,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  String jobStatusMessage(int? status, JobApplicant jobApplicant) {
    String statusMessage = "";
    if (status! < JobConstants.SHORTLISTED_STATUS) {
      statusMessage =
          responseLoginUser.user.custMessages.awardAction.message.toString();
    }
    if (status >= JobConstants.SHORTLISTED_STATUS) {
      if (status == JobConstants.INVITED_FOR_JOB) {
        statusMessage = sprintf(
            responseLoginUser.user.custMessages.invitedforjob.message
                .toString(),
            [jobApplicant.firstName]);
      } else {
        if (status == JobConstants.USER_APPLIED_AFTER_INVITATION) {
          statusMessage = responseLoginUser
              .user.custMessages.awardAction.message
              .toString();
        } else {
          statusMessage = sprintf(
              responseLoginUser.user.custMessages.custJobAwardedInfo.message
                  .toString(),
              [jobApplicant.firstName]);
        }
      }
    }

    if (status > JobConstants.REJECTED_STATUS &&
        status >= JobConstants.HIRED_STATUS &&
        status != JobConstants.USER_APPLIED_AFTER_INVITATION) {
      if (status == JobConstants.INVITED_FOR_JOB) {
        statusMessage = sprintf(
            responseLoginUser.user.custMessages.invitedforjob.message
                .toString(),
            [jobApplicant.firstName]);
      } else if (status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {
        statusMessage =
            responseLoginUser.user.custMessages.awardAction.message.toString();
      } else {
        statusMessage = sprintf(
            responseLoginUser.user.custMessages.custJobAwardedInfo.message
                .toString(),
            [jobApplicant.firstName]);
      }
    }
    return statusMessage;
  }

  bool jobStatusButtonState(int? status) {
    bool btn_state = false;
    if (status! < JobConstants.SHORTLISTED_STATUS) {
      btn_state = true;
    }
    if (status >= JobConstants.SHORTLISTED_STATUS) {
      if (status == JobConstants.INVITED_FOR_JOB) {
        btn_state = false;
      } else {
        if (status == JobConstants.USER_APPLIED_AFTER_INVITATION) {
          btn_state = true;
        } else {
          btn_state = false;
        }
      }
    }

    if (status > JobConstants.REJECTED_STATUS &&
        status >= JobConstants.HIRED_STATUS &&
        status != JobConstants.USER_APPLIED_AFTER_INVITATION) {
      if (status == JobConstants.INVITED_FOR_JOB) {
        btn_state = false;
      } else if (status == JobConstants.USER_APPLIED_TO_OPEN_JOB) {
        btn_state = true;
      } else {
        btn_state = false;
      }
    }

    return btn_state;
  }

  bool manageAPiReposne() {
    bool reponse = false;
    if (_appController.generalResponse != null) {
      if (_appController.generalResponse!.status == "success") {
        setState(() {});
      } else {}
    }
    return reponse;
  }

  String populateSkills(List<ApplicantSkill>? applicantSkills) {
    String skillName = "";

    for (var uSkill in applicantSkills!) {
      skillName = skillName + "," + uSkill.skillName.toString();
    }
    return skillName;
  }

  void showDisclaimerDialog(
      BuildContext context,
      String disclaimerMessgae,
      ResponseCustomersShowJobs responseCustomersShowJobs,
      JobApplicant jobApplicant,
      int jobIndex) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (BuildContext dialogueContext, __, ___) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
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
                        Center(
                          child: Text(
                            'title_disclaimer'.tr,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(dialogueContext);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Html(data: disclaimerMessgae, style: {

                          'li': Style(
                              color: Colors.black,
                              fontSize: FontSize(10.0),
                            padding:HtmlPaddings.zero,

                              ),
                          'h4': Style(color: Color.fromARGB(255, 53, 52, 52),
                              fontSize: FontSize(13.0))
                        }),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogueContext);
                              },
                              style: Styles.appElevatedJobStatusButtonStyle,
                              child: Text('decline'.tr)),
                        ),
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogueContext);
                                print("AcceptButtonClicked");
                                updateStatus(responseCustomersShowJobs,
                                    jobApplicant, jobIndex);
                              },
                              style: Styles.appElevatedJobStatusButtonStyle,
                              child: Text('accept'.tr)),
                        )
                      ],
                    ),
                  )
                ],
              ),
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

  void updateStatus(ResponseCustomersShowJobs responseCustomersShowJobs,
      JobApplicant jobApplicant, int jobIndex) async {
    String chatMessageCurrent;
    String chatMessageOther;

    chatMessageCurrent = sprintf(
        GetChatMessageJob()
            .getChatMessage(FireBaseConstants.rewardJobCurrentUserMessage),
        [jobApplicant.firstName, responseCustomersShowJobs.title]);

    chatMessageOther = sprintf(
        GetChatMessageJob()
            .getChatMessage(FireBaseConstants.rewardJobOtherUserMessage),
        [responseLoginUser.user.firstName, responseCustomersShowJobs.title]);

    print("PreAwardStatus${jobApplicant.firstName}");

    await _appController.changeJobStatus(
        QueryChangeJobStatus(
            jobId: responseCustomersShowJobs.id.toString(),
            status: JobConstants.HIRED_STATUS.toString(),
            userId: jobApplicant.userId.toString()),
        apiKey.toString(),
        responseLoginUser.user.firebaseUid.toString(),
        jobApplicant.firebaseUid.toString(),
        chatMessageCurrent,
        FireBaseConstants.applyJobReward,
        responseLoginUser.user.firstName.toString(),
        chatMessageOther,
        context);
    print("ApplicantIndex${getApplicantIndex(jobApplicant, jobIndex)}");
    if (_appController.generalResponse != null) {
      if (_appController.generalResponse!.status == "success") {
        JobConstants
            .list_cus_open_jobs[jobIndex]
            .jobApplicants![getApplicantIndex(jobApplicant, jobIndex)]
            .sp_job_status = JobConstants.HIRED_STATUS;
        JobConstants.list_cus_open_jobs[jobIndex].status =
            JobConstants.HIRED_STATUS;
        JobConstants.list_cus_started_jobs
            .add(JobConstants.list_cus_open_jobs[jobIndex]);
        JobConstants.list_cus_open_jobs
            .remove(JobConstants.list_cus_open_jobs[jobIndex]);
        setState(() {});
        showToast("User is hired successfully",
            context: context, backgroundColor: Colors.green);
      } else {
        showToast(_appController.generalResponse!.message,
            context: context, backgroundColor: Colors.red);
      }
    } else {
      showToast("Please try again later",
          context: context, backgroundColor: Colors.red);
    }

    print("PostAwardStatus");
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

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }

  int getApplicantIndex(JobApplicant jobApplicant, int jobIndex) {
    print("JobTitleClicked${JobConstants.list_cus_open_jobs[jobIndex].title}");
    int updateIndex = -1;
    int applicantIndex = JobConstants
        .list_cus_open_jobs[jobIndex].jobApplicants!
        .indexWhere((user) => user == jobApplicant);
    updateIndex = applicantIndex;
    return updateIndex;
  }
}
