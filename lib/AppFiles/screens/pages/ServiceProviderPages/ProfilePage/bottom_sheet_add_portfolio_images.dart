import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:get/get.dart';

class BodyBottomSheetAddPortfolio extends StatefulWidget {
  @override
  State<BodyBottomSheetAddPortfolio> createState() =>
      _BodyBottomSheetAddPortfolioState();
}

class _BodyBottomSheetAddPortfolioState
    extends State<BodyBottomSheetAddPortfolio> {
  AppController _appController = Get.put(AppController());
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  final ImagePicker imagePicker = ImagePicker();

  File? image;
  List<String> portfolioImages = [];
  late String? apiKey;
  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];

  List<String> deletedImages = [];
  List<String> gigImages = [];
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
    if (responseLoginUser.user.serviceProviders.portfolioImages != null &&
        responseLoginUser.user.serviceProviders.portfolioImages.isNotEmpty) {
      gigImages = GenericAppFunctions.getPortfolioImagesFromString(
          responseLoginUser.user.serviceProviders.portfolioImages);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 60,
                color: Colors.grey,
                margin: const EdgeInsets.only(bottom: 10),
                child: Image.asset(
                  "assets/ic_edit_screen_line.png",
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 2,
                ),
              ),
              Text(
                'add_portfolio_images_title_sheet'.tr,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
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
              Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: compressedImages.length > 0
                          ? GridView.builder(
                              shrinkWrap: true,
                              itemCount: compressedImages.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(compressedImages[index],
                                        fit: BoxFit.cover),
                                  ),
                                );
                              })
                          : Container())),
              Container(
                child: gigImages != null && gigImages.isNotEmpty
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
                                              AppConstants.PORTFOLIOIMAGESURLS,
                                              "");
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
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 40,
                width: double.infinity,
                child: AppElevatedButton(
                  borderRadius: BorderRadius.circular(20),
                  onPressed: () async {
                    print("UploadPOrtfolioPre");
                    await _appController.uploadImages(
                        responseLoginUser.user.serviceProviders.userId
                            .toString(),
                        AppConstants.IMAGETYPEPORTFOLIO,
                        deletedImages.toString(),
                        apiKey.toString(),
                        compressedImages);
                    print("UploadPOrtfolioPost");
                    await _appController.updateProfile(
                        responseLoginUser.user.serviceProviders.userId
                            .toString(),
                        responseLoginUser.user.language,
                        apiKey.toString());
                    print("UploadUpdate");
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileLandingPage()),
                      (Route<dynamic> route) => true,
                    );
                  },
                  child: Text('update'.tr),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
                    child: ListTile(
                      title: Text("Gallery"),
                      leading: Icon(Icons.image),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void pickCameraImage() async {
    final XFile? xFile =
        await imagePicker.pickImage(source: ImageSource.camera);
    image = File(xFile!.path);
    setState(() {});
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
        setState(() {});
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
