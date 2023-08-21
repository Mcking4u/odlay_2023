import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';

class BodyBottomSheetVerifyIdentity extends StatefulWidget {
  @override
  State<BodyBottomSheetVerifyIdentity> createState() =>
      _BodyBottomSheetVerifyIdentityState();
}

class _BodyBottomSheetVerifyIdentityState
    extends State<BodyBottomSheetVerifyIdentity> {
  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];
  AppController _appController = Get.put(AppController());
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  final ImagePicker imagePicker = ImagePicker();
  late String? apiKey;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '#####-#######-#',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
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
                const Text(
                  "Add Verification Images",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [maskFormatter],
                                  textAlignVertical: TextAlignVertical.center,
                                  // controller: jobTitle,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    filled: false,
                                    hintText: "Enter CNIC",
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
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("ImageSlecterOpen");
                          _showBottomSheetImageSelction(context);
                        },
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 120,
                              height: 120,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Image.asset(
                                      "assets/ic_cnic_icon.png",
                                      fit: BoxFit.contain,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Upload Cnic Picture",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                  )
                                ],
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          showToast("Coming Soon",
                              context: context, backgroundColor: Colors.blue);
                        },
                        child: Card(
                            color: Color.fromARGB(255, 221, 219, 219),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 120,
                              height: 120,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Image.asset(
                                      "assets/ic_bill_icon.png",
                                      fit: BoxFit.contain,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Upload Utility Billl Picture",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                  )
                                ],
                              ),
                            )),
                      )
                    ],
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
                                      child: Image.file(
                                          File(compressedImages[index].path),
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                })
                            : Container())),
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
                          AppConstants.IMAGETYPEIDENTITY,
                          "[]",
                          apiKey.toString(),
                          compressedImages);
                      print("UploadPOrtfolioPost");
                      _appController.updateProfile(
                          responseLoginUser.user.serviceProviders.userId
                              .toString(),
                          responseLoginUser.user.language,
                          apiKey.toString());
                      print("UploadUpdate");
                      Navigator.pop(context);
                    },
                    child: Text('Update'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showBottomSheetImageSelction(BuildContext baseContext) {
    showModalBottomSheet<void>(
        context: baseContext,
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
