// ignore_for_file: unnecessary_const

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Controller/auth_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/privacy_policy_agreement.dart';
import 'package:odlay_services/AppFiles/model/VerifyPhoneModel/_query_verify_phone.dart';
import 'package:odlay_services/AppFiles/screens/pages/AuthPages/Otp.dart';

import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/AppFiles/screens/widgets/Header.dart';

class EnterPhone extends StatefulWidget {
  @override
  EnterPhoneState createState() => EnterPhoneState();
}

class EnterPhoneState extends State<EnterPhone> {
  AuthController authController = Get.put(AuthController());
  // ignore: non_constant_identifier_names
  TextEditingController phone_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  String country_code = "+358";
  FirebaseAuth auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationID = "";
  @override
  Widget build(BuildContext context) {
    AppConstants.base_api_url = AppConstants.BaseUrlDevPk;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.red,
            image: new DecorationImage(
              image: AssetImage("assets/img_login_header.png"),
              fit: BoxFit.fill,
            )),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 300,
            ),
            Header(),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg_enter_phone.png"),
                      fit: BoxFit.cover),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Welcome!",
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Login with an account",
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 129, 128, 128),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                bottomLeft: const Radius.circular(25.0),
                                bottomRight: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0))),
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: CountryCodePicker(
                                  padding: EdgeInsets.zero,
                                  onChanged: (value) {
                                    country_code = value.dialCode!;
                                    print("CountryCode$country_code");
                                  },
                                  initialSelection: 'fi',
                                  favorite: const ['+358', 'pk'],
                                  showCountryOnly: true,
                                  showFlag: true,
                                  flagWidth: 15,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: true,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: phone_controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  hintText: "Enter phone number",
                                  hintStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: AppElevatedButton(
                          width: double.infinity,
                          onPressed: () async {
                            await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return PrivacyPolicyAgreement(
                                      () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        String full_number = country_code +
                                            phone_controller.text;
                                        debugPrint(
                                            'phoneNumber:' + full_number);
                                        //Get.to(OtpPage(phone_number: full_number));
                                        authController.verifyPhone(
                                            QueryVerifyPhone(
                                                phone: full_number,
                                                verificationId: "0",
                                                message: "",
                                                appVersion: 234,
                                                countryCode:
                                                    country_code.substring(1)),
                                            context);
                                      },
                                    );
                                  });
                                });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: const Text('Verify'),
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "By Continuing you may receive an SMS for verificaion. Message and data rate may apply.",
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/launcher_icon.png",
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                          ))
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
