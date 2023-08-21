import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/chatHeaderWidgets/_chat_header_body.dart';

class ConversionHeader extends StatefulWidget {
  @override
  State<ConversionHeader> createState() => _ConversionHeaderState();
}

class _ConversionHeaderState extends State<ConversionHeader> {
  late ResponseLoginUser responseLoginUser;
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Conversions"),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: const Color.fromRGBO(255, 118, 87, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: ChatHeaderBody(),
    );
  }
}
