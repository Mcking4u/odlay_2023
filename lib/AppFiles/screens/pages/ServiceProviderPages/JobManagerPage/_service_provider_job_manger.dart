import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ServiceProviderJobMangerModel/_serviceprovider_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/_service_provider_job_manger_tabs.dart';
import 'package:odlay_services/Styles/styles.dart';

class ServiceProviderJobManager extends StatefulWidget {
  const ServiceProviderJobManager({Key? key}) : super(key: key);

  @override
  State<ServiceProviderJobManager> createState() =>
      _ServiceProviderJobManagerState();
}

class _ServiceProviderJobManagerState extends State<ServiceProviderJobManager> {
  AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    print("ServiceProviderJobMangerCalled");
    _appController.getSpAppliedJobs(
        ServiceproviderJobsShowQuery(
            apiKey: apiKey.toString(),
            language: responseLoginUser.user.language,
            userId: responseLoginUser.user.serviceProviders.userId.toString(),
            callFrom: "intial"),
        apiKey.toString(),
        true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("JobMangerSp");

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          automaticallyImplyLeading: false,
          title: const Text("Job Manager"),
          backgroundColor: Color.fromRGBO(255, 118, 87, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )),
        ),
        body: Obx(() {
          if (_appController.serviceproviderJobsShowResponseLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _appController.serviceproviderJobsShowResponse!.applied.isEmpty
              ? Center(
                  child: Text(
                    "No Jobs Applied Yet",
                    style: Styles.headingTextColor,
                  ),
                )
              : ServiceProviderJobMangerTabs();
        }));
  }
}
