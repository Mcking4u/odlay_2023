import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/CameraPromt.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CustomerJobManagerModels/_customer_jobs_show_response.dart';
import 'package:odlay_services/AppFiles/model/Review/_query_post_review.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';

class ReviewBottomSheetBody extends StatefulWidget {
  ResponseCustomersShowJobs job;
  JobApplicant jobApplicant;
   ReviewBottomSheetBody(this.job, this.jobApplicant);
  @override
  State<ReviewBottomSheetBody> createState() => _ReviewBottomSheetBodyState();
}

class _ReviewBottomSheetBodyState extends State<ReviewBottomSheetBody> {
  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];
  double userRating = 1;
//api keys and data
  late ResponseLoginUser responseLoginUser;
  late SkillCitiesProfessions skillCitiesProfessions;
  AppController _appController = Get.put(AppController());
  TextEditingController jobDescription = TextEditingController();
  late String? apiKey;

  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    // appRegion =
    //     Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
      
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
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
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    'review_sheet_title'.tr,
                    style: Styles.reviewTextStyle,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 60,
                width: 60,
                child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        AppConstants.PROFILEIMAGESURLS +
                            widget.jobApplicant.logo.toString())),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.jobApplicant.firstName.toString(),
                    style: Styles.nameReview,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color.fromRGBO(255, 118, 87, 1),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      userRating = rating;
                    },
                  )),
              Container(
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Image.asset(
                            "assets/ic_description.png",
                            fit: BoxFit.contain,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: jobDescription,
                              maxLines: 5,
                              decoration:  InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                filled: false,
                                hintText: 'review_desc'.tr,
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  print("OpenImagePicker");
                  // Navigator.pop(context);

                  print("PreSelection");
                  await _showBottomSheetImageSelction(context);
                  print("PpstSelection");
                  setState(() {});
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 230, 230, 230),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/ic_attach_img.png",
                            fit: BoxFit.contain,
                            width: 20,
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                'attach_images'.tr,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Positioned(
                          top: 5,
                          right: 10,
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: compressedImages.length > 0
                      ? GridView.builder(
                          shrinkWrap: true,
                          itemCount: compressedImages.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.file(compressedImages[index],
                                      fit: BoxFit.cover),
                                ),
                                Positioned(
                                    right: 20,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        print("Delete this image");
                                        compressedImages
                                            .remove(compressedImages[index]);
                                        setState(() {});
                                      },
                                      child: Image.asset(
                                        "assets/ic_cross_flutter_white.png",
                                        fit: BoxFit.contain,
                                        width: 30,
                                        height: 30,
                                        color: Colors.red,
                                      ),
                                    ))
                              ],
                            );
                          })
                      : Container()),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Obx(() => AppElevatedButton(
                      width: double.infinity,
                      onPressed: () async {
                        print("BeforePostReview");
                        if (jobDescription.text.isEmpty) {
                          showToast("Please enter review description",
                              context: context, backgroundColor: Colors.green);
                        } else {
                          await _appController.postReview(
                              QuerypostReview(
                                  rating: userRating.toString(),
                                  feedback: jobDescription.text,
                                  consumerId: responseLoginUser
                                      .user.consumer.userId
                                      .toString(),
                                  serviceId:
                                      widget.jobApplicant.userId.toString(),
                                  jobId: widget.job.id.toString(),
                                  skills: [
                                    reviewJobSkill(
                                        widget.job, widget.jobApplicant)
                                  ]),
                              apiKey.toString());
                          print("AfterPostReview");
                          if (_appController.responsePostReview != null) {
                            if (_appController.responsePostReview.status ==
                                "success") {
                              print("reviewnotposted0");
                              getReviewJobIndex(widget.job);
                              Navigator.pop(context);
                              showToast(
                                  _appController.responsePostReview.message,
                                  context: context,
                                  backgroundColor: Colors.green);
                              if (compressedImages != null &&
                                  compressedImages.isNotEmpty) {
                                _appController.uploadImages(
                                    _appController.responsePostReview.reviewId
                                        .toString(),
                                    AppConstants.IMAGETYPEPORTREVIEWS,
                                    "[]",
                                    apiKey.toString(),
                                    compressedImages);
                              }
                            } else {
                              print("reviewnotposted1");
                              Navigator.pop(context);
                              showToast(
                                  _appController.responsePostReview.message,
                                  context: context,
                                  backgroundColor: Colors.red);
                            }
                          } else {
                            print("reviewnotposted2");
                            Navigator.pop(context);
                            showToast("Unable to post reviews",
                                context: context, backgroundColor: Colors.red);
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Text(_appController.responsePostReviewValue.value
                          ? 'review_btn_submitting'.tr
                          : 'review_btn_submitt'.tr),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheetImageSelction(BuildContext otherPageContext) {
    showModalBottomSheet<void>(
        context: otherPageContext,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // selectImages();
                      pickImages();
                    },
                    child: const ListTile(
                      title: Text("Gallery"),
                      leading: Icon(Icons.image),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () async {
                      bool cameraAgree = false;
                      await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return CameraPrompt(
                                () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  cameraAgree = true;
                                },
                                "To update your Superdeals profile with your photo, please allow Superdeals to use your camera to take your latest photo.Superdeals will use your profile photo for identity verification.",
                              );
                            });
                          });
                      if (cameraAgree) {
                        Navigator.pop(context);
                        launchCamera();
                      }
                    },
                    child: ListTile(
                      title: Text("Camera"),
                      leading: Icon(Icons.camera),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  compressImage(path) async {
    if (selectedImages.isEmpty) return;
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(path);
    await FlutterNativeImage.compressImage(path,
            quality: 50,
            targetWidth: 600,
            targetHeight:
                (properties.height! * 600 / (properties.width)!).round())
        .then((response) => setState(() => compressedImages.add(response)))
        .catchError((e) => debugPrint("ExceptioonCompresson"));
  }

  pickImages() async {
    print("ShowMeGallery");
    try {
      final pickedImages = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (pickedImages != null && pickedImages.files.isNotEmpty) {
        final image = pickedImages.files.map((e) => e.path!);
        selectedImages.addAll(image);
        temporaryImages.addAll(image);

        for (int i = 0; i < temporaryImages.length; i++) {
          compressImage(temporaryImages[i]);
        }

        Future.delayed(const Duration(seconds: 1), () {
          temporaryImages.clear();
          setState(() {});
        });
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void launchCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return;
      } else {
        print("ImagesSlected");
        final imageTemp = File(image.path);
        // compressImage(image.path);
        compressedImages.add(imageTemp);
        setState(() {});
      }
    } on PlatformException catch (e) {
      print('Failedto pick image: $e');
    }
  }

  int? reviewJobSkill(
      ResponseCustomersShowJobs job, JobApplicant jobApplicant) {
    int? skillId = 1;
    if (job.skillId != null && job.skillId!.isNotEmpty) {
      skillId = job.skillId![0];
    } else {
      if (jobApplicant.skills != null && jobApplicant.skills!.isNotEmpty) {
        skillId = jobApplicant.skills![0].skillId;
      }
    }
    return skillId;
  }
  void getReviewJobIndex(ResponseCustomersShowJobs currentJob){
    int jobIndex = JobConstants.list_cus_closed_jobs
        .indexWhere((job) => job.id == currentJob.id);
int applicantIndex = currentJob.jobApplicants!
        .indexWhere((jobApplicant) => jobApplicant.sp_job_status == JobConstants.COMPLETED_STATUS);
 JobConstants.list_cus_closed_jobs[jobIndex].status=JobConstants.COMPLETED_Job_REVIEWE_DONE; 
 JobConstants.list_cus_closed_jobs[jobIndex].jobApplicants![applicantIndex].sp_job_status=JobConstants.COMPLETED_Job_REVIEWE_DONE;
  }
}
