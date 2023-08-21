import 'dart:io';

import 'package:chip_list/chip_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/CameraPromt.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/CreateGigModel/_query_create_gig.dart';
import 'package:odlay_services/AppFiles/model/GigsModel/_edit_gig.dart';

import 'package:odlay_services/AppFiles/model/ProfileModel/_response_single_provider_profile.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/VisitProfilePages/_user_gig_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

class BodyCreateGig extends StatefulWidget {
  bool isUpdateGig;
  SpGig? myGig;
  BodyCreateGig(this.isUpdateGig, this.myGig);
  @override
  State<BodyCreateGig> createState() => _BodyCreateGigState();
}

class _BodyCreateGigState extends State<BodyCreateGig> {
  AppController _appController = Get.put(AppController());
  TextEditingController serviceTitle = TextEditingController();
  TextEditingController serviceDescription = TextEditingController();
  TextEditingController serviceAmount = TextEditingController();
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  final List<Skill> _selectedSkill = [];
  final ImagePicker imagePicker = ImagePicker();

  File? image;
  String odlayFee = "";
  String reciableAmount = "";
  List<String> deletedImages = [];
  List<String> gigImages = [];

  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];

//Profile SKilll
  List<Skill> profileSkills = [];
//get app region
  int? appRegion;

  @override
  void initState() {
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    poulateUserSkillFromProfile();
    if (widget.isUpdateGig) {
      poulateGigData(widget.myGig);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 40),
          child: Column(
            children: [
              Container(
                height: 40,
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/ic_job_title.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Center(
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: serviceTitle,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  filled: false,
                                  hintText: 'service_title'.tr,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                        top: 5,
                        right: 10,
                        child: Text(
                          "*",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                margin: const EdgeInsets.only(top: 20),
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
                              controller: serviceDescription,
                              maxLines: 5,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                filled: false,
                                hintText: 'service_desc'.tr,
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                        top: 5,
                        right: 10,
                        child: Text(
                          "*",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          appRegion == 2
                              ? "assets/ic_euro.png"
                              : "assets/ic_pkr_grey.png",
                          fit: BoxFit.contain,
                          width: 20,
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Center(
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (String value) async {
                                  double enter_amount = double.parse(value);
                                  double fee_amount = enter_amount *
                                      double.parse(responseLoginUser.user.spfee
                                          .toString());
                                  odlayFee = fee_amount.ceil().toString();
                                  reciableAmount = (enter_amount - fee_amount)
                                      .floor()
                                      .toString();
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: serviceAmount,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  filled: false,
                                  hintText: 'enter_service_price'.tr,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sprintf(
                      responseLoginUser.user.spMessages.sp_gig_info.message,
                      [(double.parse(responseLoginUser.user.spfee.toString())*100).toString()+" %"]),
                      style: Styles.sp_note_style),
                ],
              ),
            ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('receibal_amount_whill_applying'.tr,
                        style: Styles.headingText),
                    Text(
                        responseLoginUser.user.currencySymbol.toString() +
                            reciableAmount,
                        style: Styles.headingTextColor)
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  SelectDialog.showModal<Skill>(
                    context,
                    label: 'select_skills'.tr,
                    items: profileSkills,
                    onChange: (Skill skill) {
                      setState(() {
                        if (_selectedSkill.contains(skill)) {
                          print("This skill is already present");
                        } else {
                          if (_selectedSkill.length < 5) {
                            _selectedSkill.add(skill);
                          } else {
                            showSnackBar("You can not add more then 5 skills");
                          }
                        }
                      });
                    },
                  );
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 230, 230, 230),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/ic_skill_grey.png",
                            fit: BoxFit.contain,
                            width: 20,
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0),
                                  filled: false,
                                  hintText: 'select_skills'.tr,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
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
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: <Widget>[
                  for (var skill in _selectedSkill)
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text(skill.skillName[0].toUpperCase()),
                      ),
                      label: Text(
                        skill.skillName,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 15, 3, 0),
                        ),
                      ),
                      deleteIcon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onDeleted: () {
                        setState(() {
                          _selectedSkill.remove(skill);
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 189, 188, 188),
                      elevation: 6.0,
                      shadowColor: Colors.grey[60],
                    )
                ],
              ),
              GestureDetector(
                onTap: () {
                  print("OpenImagePicker");
                  _showBottomSheetImageSelction();
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                  margin: const EdgeInsets.only(top: 20),
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
                  margin: const EdgeInsets.only(top: 10),
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
                                      fit: BoxFit.fill),
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
                child: gigImages.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        itemCount: gigImages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(gigImages[index],
                                    fit: BoxFit.fill),
                              ),
                              Positioned(
                                  right: 20,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("Delete this image");
                                      String deleteImageName = gigImages[index]
                                          .replaceAll(
                                              AppConstants.GIGIMAGESURLS, "");
                                      print(
                                          "DeleteImageName:${deleteImageName}");
                                      deletedImages.add(deleteImageName);
                                      gigImages.remove(gigImages[index]);
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
                    : Container(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(35, 0, 10, 20),
        child: Obx(() => AppElevatedButton(
              width: double.infinity,
              onPressed: () async {
                if (serviceTitle.text.isEmpty) {
                  showSnackBar("Please enter service title");
                } else if (serviceDescription.text.isEmpty) {
                  showSnackBar("Please enter service Detail");
                } else if (_selectedSkill.isEmpty) {
                  showSnackBar("Please add at least one skill");
                } else if (compressedImages.isNotEmpty &&
                    compressedImages.length > 5) {
                  showSnackBar("You can not add more then 5 images");
                } else if (serviceAmount.text.isEmpty) {
                  showSnackBar("Please enter service amount");
                } else if (int.parse(serviceAmount.text.toString()) <
                    int.parse(responseLoginUser.user.min_amount.toString())) {
                  showSnackBar(
                      "minimum service amount is ${responseLoginUser.user.min_amount}");
                } else if (int.parse(serviceAmount.text.toString()) >
                    int.parse(responseLoginUser.user.max_amount.toString())) {
                  showSnackBar(
                      "maximum service amount is ${responseLoginUser.user.max_amount}");
                } else {
                  if (widget.isUpdateGig) {
                    print("UpdatePreGig${getSelectedSkillIds()}");
                    await _appController.editGig(
                        QueryEditGig(
                            apiKey: apiKey.toString(),
                            gigId: widget.myGig!.gigId.toString(),
                            editType: "edit",
                            status: 0,
                            title: serviceTitle.text.toString(),
                            price: int.parse(serviceAmount.text),
                            skill_id: getSelectedSkillIds(),
                            city_id: widget.myGig!.cityId.toString(),
                            detail: serviceDescription.text),
                        apiKey.toString());
                    print("UpdatePostGig");
                    if (_appController.responseEditGig != null) {
                      if (_appController.responseEditGig.status == "success") {
                        if (compressedImages.isNotEmpty ||
                            deletedImages.isNotEmpty) {
                          await _appController.uploadImages(
                              _appController.responseEditGig.gigId.toString(),
                              AppConstants.IMAGETYPEGIG,
                              deletedImages.toString(),
                              apiKey.toString(),
                              compressedImages);
                          print("ReadToGONextScree");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserGigDetailPage(
                                  _appController.responseEditGig.gigId
                                      .toString(),
                                  responseLoginUser.user.serviceProviders.userId
                                      .toString(),
                                  true,
                                  int.parse(serviceAmount.text))));
                        } else {
                          print("ReadToGONextScree");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserGigDetailPage(
                                  _appController.responseEditGig.gigId
                                      .toString(),
                                  responseLoginUser.user.serviceProviders.userId
                                      .toString(),
                                  true,
                                  int.parse(serviceAmount.text))));
                        }
                      }
                    }
                  } else {
                    await _appController.createNewGig(
                        QueryCreateGig(
                            apiKey: apiKey.toString(),
                            cityId: responseLoginUser
                                .user.serviceProviders.cityId
                                .toString(),
                            detail: serviceDescription.text.toString(),
                            language:
                                responseLoginUser.user.language.toString(),
                            price: serviceAmount.text.toString(),
                            serviceId: responseLoginUser
                                .user.serviceProviders.userId
                                .toString(),
                            skillId: getSelectedSkillIds(),
                            skillTitle: [],
                            title: serviceTitle.text.toString()),
                        apiKey.toString());
                    print("PotCreateGig${_appController.responseCreateGig}");
                    if (_appController.responseCreateGig != null) {
                      print(
                          "GIGNUll${_appController.responseCreateGig!.status}");
                      if (_appController.responseCreateGig!.status ==
                          "success") {
                        if (compressedImages.isNotEmpty) {
                          await _appController.uploadImages(
                              _appController.responseCreateGig!.gigId
                                  .toString(),
                              AppConstants.IMAGETYPEGIG,
                              "[]",
                              apiKey.toString(),
                              compressedImages);
                          print("ReadToGONextScree");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserGigDetailPage(
                                  _appController.responseCreateGig!.gigId
                                      .toString(),
                                  responseLoginUser.user.serviceProviders.userId
                                      .toString(),
                                  true,
                                  int.parse(serviceAmount.text))));
                        } else {
                          print("ReadToGONextScree");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserGigDetailPage(
                                  _appController.responseCreateGig!.gigId
                                      .toString(),
                                  responseLoginUser.user.serviceProviders.userId
                                      .toString(),
                                  true,
                                  int.parse(serviceAmount.text))));
                        }
                      }
                    }
                  }
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Text(
                _appController.isLoadingResponseCreateGig.value
                    ? 'posting'.tr
                    : 'post_service_btn'.tr,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            )),
      ),
    );
  }

  String getSelectedSkillIds() {
    String skillIds = "";
    List<int> skillIdList = [];
    for (var selectedSkill in _selectedSkill) {
      skillIdList.add(selectedSkill.skillId);
    }
    print("SelectedSkillId${skillIdList.toString()}");
    skillIds = skillIdList.toString();
    return skillIds;
  }

  _showBottomSheetImageSelction() {
    showModalBottomSheet<void>(
        context: context,
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

  void launchCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return;
      } else {
        final imageTemp = File(image.path);
        compressedImages.add(imageTemp);
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void showSnackBar(String snackMsg) {
    final snackBar = SnackBar(
      content: Text(snackMsg),
      backgroundColor: (Colors.red),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void poulateGigData(SpGig? spGig) {
    serviceTitle.text = spGig!.gigTitle.toString();
    if (spGig.gigDetail != null) {
      serviceDescription.text = spGig.gigDetail.toString();
    }
    if (spGig.gigPrice != null) {
      serviceAmount.text = spGig.gigPrice.toString();
      double enter_amount = double.parse(spGig.gigPrice.toString());
      double fee_amount =
          enter_amount * double.parse(responseLoginUser.user.spfee.toString());
      odlayFee = fee_amount.ceil().toString();
      reciableAmount = (enter_amount - fee_amount).floor().toString();
    }
    if (spGig.gigSkills != null) {
      print("GigSkill${spGig.gigSkills}");
      for (var spSkill in spGig.gigSkills!) {
        _selectedSkill.add(Skill(
          skillId: spSkill.skillId!,
          skillName: spSkill.title!,
        ));
      }
    }

    print("GigImage${spGig.gigImages}");
    if (spGig.gigImages != null) {
      gigImages = GenericAppFunctions.getGigListFromString(spGig.gigImages);
    }
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
        .catchError((e) => debugPrint(e));
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

        Future.delayed(
            const Duration(seconds: 1), () => temporaryImages.clear());
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void poulateUserSkillFromProfile() {
    for (var sId in responseLoginUser.user.skills!) {
      int skillIndex = skillCitiesProfessions.skills
          .indexWhere((skill) => skill.skillId == sId);
      profileSkills.add(skillCitiesProfessions.skills[skillIndex]);
    }
  }
}
