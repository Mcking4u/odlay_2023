import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_query.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/_customer_job_manger_tabs.dart';
import 'package:odlay_services/Styles/styles.dart';

class CustomerJobManager extends StatefulWidget {
  const CustomerJobManager({Key? key}) : super(key: key);

  @override
  State<CustomerJobManager> createState() => _CustomerJobManagerState();
}

class _CustomerJobManagerState extends State<CustomerJobManager> {
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
    print("SavedKey${apiKey}");
    _appController.getCustomerJobs(
        QueryCustomersShowJobs(
            apiKey: apiKey.toString(),
            userId: responseLoginUser.user.serviceProviders.userId.toString(),
            language: responseLoginUser.user.language,
            callFrom: "intials"),
        apiKey.toString(),
        true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("JobShowApiCalled");

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text("Job Manager"),
          backgroundColor: Color.fromRGBO(255, 118, 87, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )),
        ),
        body: Obx(() {
          if (_appController.responseCustomersShowJobsLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _appController.responseCustomersShowJobs.isEmpty
              ? Center(
                  child: Text(
                    "No Jobs Posted Yet",
                    style: Styles.headingTextColor,
                  ),
                )
              : CustomerJobMangerTabs(context);
        }));
  }
}
