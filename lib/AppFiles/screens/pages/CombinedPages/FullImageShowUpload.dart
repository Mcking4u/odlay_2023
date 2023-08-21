import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:photo_view/photo_view.dart';

class SimplePhotoViewPageViewUpload extends StatefulWidget {
  File fileImage;
  SimplePhotoViewPageViewUpload(this.fileImage);

  @override
  State<SimplePhotoViewPageViewUpload> createState() =>
      _SimplePhotoViewPageViewUploadState();
}

class _SimplePhotoViewPageViewUploadState
    extends State<SimplePhotoViewPageViewUpload> {
  AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () async {
              // await _appController.uploadImages(responseLoginUser.user.serviceProviders.userId.toString(),
              // AppConstants.IMAGETYPEIDENTITY, delImages, apiKey, imageFileList)
              print("PreProfileImageUpdate");
              await _appController.uploadProfilImages(
                  responseLoginUser.user.serviceProviders.userId.toString(),
                  AppConstants.IMAGETYPEPROFILE,
                  apiKey.toString(),
                  widget.fileImage);
              print("PostProfileImageUpdate");
              await _appController.updateProfile(
                  responseLoginUser.user.serviceProviders.userId.toString(),
                  responseLoginUser.user.language,
                  apiKey.toString());
              showToast("Profile Image Updated",
                  context: context, backgroundColor: Colors.green);
              Navigator.pop(context);
            },
          )
        ],
        automaticallyImplyLeading: false,
        title: const Text("Upload Image"),
        backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: PhotoView(
        imageProvider: FileImage(
          widget.fileImage,
        ),
        // Contained = the smallest possible size to fit one dimension of the screen
        minScale: PhotoViewComputedScale.contained * 0.8,
        // Covered = the smallest possible size to fit the whole screen
        maxScale: PhotoViewComputedScale.covered * 2,
        enableRotation: true,
        // Set the background color to the "classic white"
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
