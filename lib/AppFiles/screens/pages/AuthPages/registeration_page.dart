import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/auth_controller.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/AppFiles/screens/widgets/Header.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
  final String phone_number;
  final String uuid;

  RegistrationPage(this.phone_number, this.uuid);
}

class RegistrationPageState extends State<RegistrationPage> {
  AuthController authController = Get.put(AuthController());
  TextEditingController fName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  late String deviceToken;
  String phone = "", uuid = "";
  String dropdownValue = 'Male';
  List<String> spinnerItems = ['Male', 'Female', 'Any'];
  @override
  void initState() {
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print("token is $token");
      deviceToken = token.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    phone = widget.phone_number;
    uuid = widget.uuid;
    print("PhoneNumber$phone" + uuid);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/img_login_header.png"),
          fit: BoxFit.fill,
        )),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 200,
            ),
            Header(),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg_enter_phone.png"),
                      fit: BoxFit.cover),
                  color: Color.fromARGB(255, 233, 238, 243),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      height: 35,
                      child: TextField(
                        controller: fName,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Full Name",
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 0.5),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 0.7),
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      height: 35,
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter your email",
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 0.5),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 0.7),
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                   Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Container(
                        width: double.infinity,
                        height: 35,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 0.30),
                        ),
                        child: DropdownButton<String>(
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value.toString();
                            });
                          },
                          value: dropdownValue,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          items: spinnerItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                      ),
                  
                  
                 
                  Container(
                    height: 35,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: AppElevatedButton(
                      width: double.infinity,
                      onPressed: () {
                        if (fName.text.isEmpty) {
                          showToast("Name should not be empty",
                              context: context, backgroundColor: Colors.red);
                        } else if (email.text.isEmpty) {
                          showToast("Email should not be empty",
                              context: context, backgroundColor: Colors.red);
                        } else if (!EmailValidator.validate(email.text)) {
                          showToast("Enter Valid Email",
                              context: context, backgroundColor: Colors.red);
                        } else {
                          authController.registerUser(email.text, fName.text,
                              phone, uuid, deviceToken, dropdownValue, context);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: const Text('Sign UP'),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Image.asset(
                        "assets/launcher_icon.png",
                        fit: BoxFit.contain,
                        width: 80,
                        height: 80,
                      ))
                ],
              ),
            )
            )
          ],
        ),
      ),
    );
  }
}
