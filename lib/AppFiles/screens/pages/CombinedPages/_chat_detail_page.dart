import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Controller/firebase_realtime_database.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/GenericsAppFunctions.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/ChatModels/_chat_message.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/query_check_phone_status.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatDetailPage extends StatefulWidget {
  String OtherUserid, OtherUserName, Image;
  String phoneNumber;
  ChatDetailPage(
      this.OtherUserName, this.OtherUserid, this.Image, this.phoneNumber);
  @override
  _ChatDetailPageState createState() =>
      _ChatDetailPageState(OtherUserName, OtherUserid);
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  AppController _appController = Get.find();
  String OtherUserid, OtherUserName;
  _ChatDetailPageState(this.OtherUserName, this.OtherUserid);
  FirebaseRealtimeDatabaseController _firebaseRealtimeDatabaseController =
      Get.put(FirebaseRealtimeDatabaseController());
  TextEditingController msgEdit = TextEditingController();
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  final ScrollController _scrollController = ScrollController();
  FocusNode chatFiedNode = FocusNode();
  @override
  void initState() {
    print("OtherUserName${OtherUserName}");
    print("OtherUserUId${OtherUserid}");
    print("OtherUserPhone${widget.phoneNumber}");
    String? userData = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(userData!);
    print("UserFireBaseUuid${responseLoginUser.user.firebaseUid}");
    _firebaseRealtimeDatabaseController.chatMessages.clear();
    // _firebaseRealtimeDatabaseController.readChatMessageOnce(
    //     responseLoginUser.user.firebaseUid.toString(), OtherUserid);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    _firebaseRealtimeDatabaseController.readChatMessageContinues(
        responseLoginUser.user.firebaseUid.toString(), OtherUserid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )),
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //       AppConstants.PROFESSIONIMAGESURLS + widget.Image),
                  //   maxRadius: 20,
                  // ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          OtherUserName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          "",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _appController.checkPhonePermission(
                          QueryIsPhoneStatus(phone: widget.phoneNumber),
                          apiKey.toString());
                      if (_appController.responseCheckPermission != null) {
                        if (_appController.responseCheckPermission ==
                            "Success") {
                          if (_appController
                                  .responseCheckPermission.allowMobileCall !=
                              null) {
                            if (_appController
                                    .responseCheckPermission.allowMobileCall ==
                                1) {
                              print("phoneCLiked");
                              Uri url =
                                  Uri(scheme: "tel", path: widget.phoneNumber);
                              await launchUrl(url);
                            } else {
                              showToast("This user is not avaible on call",
                                  context: context,
                                  backgroundColor: Colors.blue);
                            }
                          } else {
                            showToast("This user is not avaible on call",
                                context: context, backgroundColor: Colors.blue);
                          }
                        } else {
                          showToast("This user is not avaible on call",
                              context: context, backgroundColor: Colors.blue);
                        }
                      }
                    },
                    child: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Stack(
            children: <Widget>[
              Obx(() {
                if (_firebaseRealtimeDatabaseController.chatMessages.isEmpty) {
                  // return Center(child: CircularProgressIndicator());
                }
                autoScollToBotto();
                return Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: ListView.builder(
                    itemCount:
                        _firebaseRealtimeDatabaseController.chatMessages.length,
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (_firebaseRealtimeDatabaseController
                                      .chatMessages[index].messageType ==
                                  "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (_firebaseRealtimeDatabaseController
                                          .chatMessages[index].messageType ==
                                      "receiver"
                                  ? const Color.fromRGBO(255, 118, 87, 1)
                                  : Colors.white),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _firebaseRealtimeDatabaseController
                                      .chatMessages[index].messageContent,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  GenericAppFunctions.getTimeFromDate(
                                      _firebaseRealtimeDatabaseController
                                          .chatMessages[index].msgTimeStamp
                                          .toString()),
                                  style: const TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: chatFiedNode,
                            controller: msgEdit,
                            decoration: const InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            chatFiedNode.unfocus();
                            _firebaseRealtimeDatabaseController.sendChat(
                                responseLoginUser.user.firebaseUid.toString(),
                                OtherUserid,
                                false,
                                msgEdit.text.toString(),
                                "",
                                widget.OtherUserName);
                            msgEdit.text = "";
                          },
                          // ignore: sort_child_properties_last
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void autoScollToBotto() async {
    await Future.delayed(const Duration(milliseconds: 100));
    print("");
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
