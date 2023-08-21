import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_chat_detail_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/SubDedtailPages/_job_post_page.dart';

class ConversationList extends StatefulWidget {
  String name;
  String userSkill;
  String imageUrl;
  String time;
  bool isMessageRead;
  String otherUuId;
  String otherUserPhone;
  ConversationList(
      {required this.name,
      required this.userSkill,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.otherUuId,
      required this.otherUserPhone});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(AppConstants.baseContext).push(MaterialPageRoute(
            builder: (context) => ChatDetailPage(widget.name, widget.otherUuId,
                widget.imageUrl, widget.otherUserPhone)));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        AppConstants.PROFILEIMAGESURLS + widget.imageUrl),
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.userSkill,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
