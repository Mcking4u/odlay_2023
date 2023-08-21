import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';
import 'package:odlay_services/AppFiles/model/ChatModels/_chat_message.dart';
import 'package:odlay_services/AppFiles/model/ChatModels/_chat_user.dart';

class FirebaseRealtimeDatabaseController extends GetxController {
  final databaseReference = FirebaseDatabase.instance.ref();
//chat headers
  List<ChatUsers> chatUsers = [];
  var isLoadingChatUsers = true.obs;
//chat messages
  RxList chatMessages = [].obs;
  List<String> chatNode = [];
  var isLoadingChatChatMessages = true.obs;

  void readChatHeaders(String uUid) {
    print("ReadChatHeaders");
    chatUsers = [];
    isLoadingChatUsers(true);
    int totalUsers = 0, currentUserIndex = 0;
    databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(uUid)
        .once()
        .then((value) {
      //print("DataSnapshot${value.snapshot.value}");
      final messagesNodes = value.snapshot.value as Map<dynamic, dynamic>;
      totalUsers = messagesNodes.length;
      print("TotalUser${totalUsers}");
      messagesNodes.forEach((key, value) async {
        print("KeyMessageChat${key}");
        await databaseReference
            .child(FireBaseConstants.userDbRoot)
            .child(key)
            .once()
            .then((userInfo) {
          // print("userValue${userInfo.snapshot.value}");
          var userObject = userInfo.snapshot.value as Map<dynamic, dynamic>;
          print(
              "SingleUserName${AppConstants.PROFILEIMAGESURLS + userObject[FireBaseConstants.userImage]}");

          chatUsers.add(ChatUsers(
              name: userObject[FireBaseConstants.userName],
              skillText: "",
              imageURL: userObject[FireBaseConstants.userImage],
              time: "Now",
              uuid: key,
              phone: userObject[FireBaseConstants.userNumber]));
        }).whenComplete(() {
          print("CurrentIndexCompleted${currentUserIndex}");
          currentUserIndex++;
          if (currentUserIndex == totalUsers) {
            print("DataComplated${chatUsers.length}");

            isLoadingChatUsers(false);
          }
        });
      });
      print("ChatUsersLoaded");
      isLoadingChatUsers(true);
    });
  }

  void readChatMessageContinues(String currentUserId, String otherUserId) {
    // isLoadingChatChatMessages(true);
    databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(currentUserId)
        .child(otherUserId)
        .onChildAdded
        .listen((event) {
      print("ChanegdValue");
      final messagesNodes = event.snapshot.value as Map<dynamic, dynamic>;
      print("MeeagesNode$messagesNodes");
      String msgType = "";
      if (messagesNodes[FireBaseConstants.messageFrom] == otherUserId) {
        msgType = FireBaseConstants.receiverText;
      } else {
        msgType = FireBaseConstants.senderText;
      }
      DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(
          messagesNodes[FireBaseConstants.messageTimeStamp]);
      if (chatMessages.contains(ChatMessage(
          messageContent: messagesNodes[FireBaseConstants.messageText],
          messageType: msgType,
          msgTimeStamp: messageTime))) {
        print("MessageExist");
      } else {
        print("MessageNotExist");
      }
      // print("NodeKey${event.snapshot.key}");
      // if (chatNode.contains(event.snapshot.key.toString())) {
      // } else {
      chatNode.add(event.snapshot.key.toString());
      chatMessages.add(ChatMessage(
          messageContent: messagesNodes[FireBaseConstants.messageText],
          messageType: msgType,
          msgTimeStamp: messageTime));
      chatMessages.sort((a, b) => a.msgTimeStamp.compareTo(b.msgTimeStamp));
      isLoadingChatChatMessages(false);
      //  }
    });
  }

  void readChatMessageOnce(String currentUuserId, String otherUserId) {
    isLoadingChatChatMessages(true);
    databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(currentUuserId)
        .child(otherUserId)
        .orderByValue()
        .once()
        .then((snapShotValue) {
      final messagesNodes =
          snapShotValue.snapshot.value as Map<dynamic, dynamic>;
      print("MeeagesNode$messagesNodes");
      messagesNodes.forEach((key, valueMessage) {
        String msgType = "";
        if (valueMessage[FireBaseConstants.messageFrom] == otherUserId) {
          msgType = FireBaseConstants.receiverText;
        } else {
          msgType = FireBaseConstants.senderText;
        }
        DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(
            valueMessage[FireBaseConstants.messageTimeStamp]);
        print("MsgTimeStamp$messageTime");
        // chatMessages.add(ChatMessage(
        //     messageContent: valueMessage[FireBaseConstants.messageText],
        //     messageType: msgType,
        //     msgTimeStamp: messageTime));
        // chatMessages.sort((a, b) => a.msgTimeStamp.compareTo(b.msgTimeStamp));
      });
    }).whenComplete(() => {isLoadingChatChatMessages(false)});
  }

  void sendChat(String current_user_Id, String other_user_id,
      bool isMsgTypeImage, String msgTitle, String uri, String userName) {
    DatabaseReference currentUserNodes = databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(current_user_Id)
        .child(other_user_id)
        .push();
    String? pushId = currentUserNodes.key;
    print("NewPushId$pushId");
    if (isMsgTypeImage) {
    } else {
//setting msg in current user node
      databaseReference
          .child(FireBaseConstants.messageDbRoot)
          .child(current_user_Id)
          .child(other_user_id)
          .child(pushId.toString())
          .set({
        FireBaseConstants.messageText: msgTitle,
        FireBaseConstants.messageSeen: "false",
        FireBaseConstants.messageType: FireBaseConstants.messageTypeText,
        FireBaseConstants.messageTimeStamp: ServerValue.timestamp,
        FireBaseConstants.messageFrom: current_user_Id,
        FireBaseConstants.messageStatus: '1'
      });
//setting msg in other user node
      databaseReference
          .child(FireBaseConstants.messageDbRoot)
          .child(other_user_id)
          .child(current_user_Id)
          .child(pushId.toString())
          .set({
        FireBaseConstants.messageText: msgTitle,
        FireBaseConstants.messageSeen: "false",
        FireBaseConstants.messageType: FireBaseConstants.messageTypeText,
        FireBaseConstants.messageTimeStamp: ServerValue.timestamp,
        FireBaseConstants.messageFrom: current_user_Id,
        FireBaseConstants.messageStatus: '1'
      });
// setting notfication for server
      DatabaseReference notficationRef = databaseReference
          .child(FireBaseConstants.notificationDbRoot)
          .child(other_user_id)
          .push();
      String? pushIdNotification = notficationRef.key;
//write on notification
      databaseReference
          .child(FireBaseConstants.notificationDbRoot)
          .child(other_user_id)
          .child(pushIdNotification.toString())
          .set({
        FireBaseConstants.notificationBody: msgTitle,
        FireBaseConstants.notificationFrom: current_user_Id,
        FireBaseConstants.notificationTitle: userName,
        FireBaseConstants.notificationType: "Chat",
      });
    }
  }

  void sendJobMessage(
      String current_user_Id,
      String other_user_id,
      String msgTitleCurrent,
      String notficationType,
      String notification_title,
      String msgTitleOther) {
/////////////////////////////////////////////.....get push id for current user......////////////////////////////
    DatabaseReference currentUserNodes = databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(current_user_Id)
        .child(other_user_id)
        .push();
    String? pushId = currentUserNodes.key;
    print("NewPushId$pushId");

/////////////////////////////////////////////.....setting msg in current user node......////////////////////////////
    databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(current_user_Id)
        .child(other_user_id)
        .child(pushId.toString())
        .set({
      FireBaseConstants.messageText: msgTitleCurrent,
      FireBaseConstants.messageSeen: "false",
      FireBaseConstants.messageType: FireBaseConstants.messageTypeText,
      FireBaseConstants.messageTimeStamp: ServerValue.timestamp,
      FireBaseConstants.messageFrom: current_user_Id,
      FireBaseConstants.messageStatus: '1'
    });

    /////////////////////////////////////////////.....setting msg in other user node......////////////////////////////

/////////////////////////////////////////////.....get New push id for second user......////////////////////////////
    DatabaseReference OtherUserNodes = databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(current_user_Id)
        .child(other_user_id)
        .push();
    String? pushIdOther = OtherUserNodes.key;
/////////////////////////////////////////////.....write message on other pushId......////////////////////////////
    databaseReference
        .child(FireBaseConstants.messageDbRoot)
        .child(other_user_id)
        .child(current_user_Id)
        .child(pushIdOther.toString())
        .set({
      FireBaseConstants.messageText: msgTitleOther,
      FireBaseConstants.messageSeen: "false",
      FireBaseConstants.messageType: FireBaseConstants.messageTypeText,
      FireBaseConstants.messageTimeStamp: ServerValue.timestamp,
      FireBaseConstants.messageFrom: current_user_Id,
      FireBaseConstants.messageStatus: '1'
    });
    /////////////////////////////////////////////.....setting notfication for server......////////////////////////////
    DatabaseReference notficationRef = databaseReference
        .child(FireBaseConstants.notificationDbRoot)
        .child(other_user_id)
        .push();
    String? pushIdNotification = notficationRef.key;
/////////////////////////////////////////////.....write on notification......////////////////////////////
    databaseReference
        .child(FireBaseConstants.notificationDbRoot)
        .child(other_user_id)
        .child(pushIdNotification.toString())
        .set({
      FireBaseConstants.notificationBody: msgTitleOther,
      FireBaseConstants.notificationFrom: current_user_Id,
      FireBaseConstants.notificationTitle: notification_title,
      FireBaseConstants.notificationType: notficationType,
    });
  }
}
