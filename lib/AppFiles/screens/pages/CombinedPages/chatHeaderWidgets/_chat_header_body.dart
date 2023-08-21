import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/firebase_realtime_database.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ChatModels/_chat_user.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/chatHeaderWidgets/_header_item.dart';

class ChatHeaderBody extends StatefulWidget {
  @override
  State<ChatHeaderBody> createState() => _ChatHeaderBodyState();
}

class _ChatHeaderBodyState extends State<ChatHeaderBody> {
  late ResponseLoginUser responseLoginUser;
  FirebaseRealtimeDatabaseController _firebaseRealtimeDatabaseController =
      Get.put(FirebaseRealtimeDatabaseController());
  @override
  void initState() {
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
    print("UserFireBaseUuid${responseLoginUser.user.firebaseUid}");
    _firebaseRealtimeDatabaseController
        .readChatHeaders(responseLoginUser.user.firebaseUid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_firebaseRealtimeDatabaseController.isLoadingChatUsers.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListView.builder(
        itemCount: _firebaseRealtimeDatabaseController.chatUsers.length,
        padding: const EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          return ConversationList(
            name: _firebaseRealtimeDatabaseController.chatUsers[index].name,
            userSkill:
                _firebaseRealtimeDatabaseController.chatUsers[index].skillText,
            imageUrl:
                _firebaseRealtimeDatabaseController.chatUsers[index].imageURL,
            time: _firebaseRealtimeDatabaseController.chatUsers[index].time,
            isMessageRead: (index == 0 || index == 3) ? true : false,
            otherUuId:
                _firebaseRealtimeDatabaseController.chatUsers[index].uuid,
            otherUserPhone:
                _firebaseRealtimeDatabaseController.chatUsers[index].phone,
          );
        },
      );
    });
  }
}
