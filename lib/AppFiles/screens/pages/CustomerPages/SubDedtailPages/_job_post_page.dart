import 'package:flutter/material.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/PostJobsPages/_page1_post_job.dart';
import 'package:get/get.dart';

class JobPostPage extends StatelessWidget {
  ResponseCustomersShowJobs? responseCustomersShowJobs;
  bool isEditMode;
  JobPostPage(this.responseCustomersShowJobs, this.isEditMode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('post_job'.tr),
        backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: PageOnePostJob(responseCustomersShowJobs, isEditMode),
    );
  }
}
