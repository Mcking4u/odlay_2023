import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/Utility/privacy_policy_agreement_in_app.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/PhoneModels/_query_change_language.dart';
import 'package:odlay_services/AppFiles/model/UserSettings/_query_disable_user.dart';
import 'package:odlay_services/AppFiles/screens/pages/AuthPages/enter_phone.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/Wallet/_wallet_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/Wallet/_wallet_page_sp.dart';
import 'package:odlay_services/AppFiles/screens/widgets/AppElevatedButton.dart';
import 'package:odlay_services/Styles/styles.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
class MyAccount extends StatefulWidget {
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  bool isSwitched = false;
  RxBool isShowEnableDisableAccount = false.obs;
  AppController _appController = Get.find();
  int? appRegion;
  int? languageIntials;
  @override
  void initState() {
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    appRegion =
        Constants.sharedPreferences.getInt(SharePrefrencesValues.APP_REGION);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    languageIntials = Constants.sharedPreferences
        .getInt(SharePrefrencesValues.LANGUAGE_INTIALS);
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 102, 102, 1),
                        Color.fromRGBO(255, 133, 76, 1)
                      ]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          print("phoneCLiked");
                          Uri url =
                              Uri(scheme: "tel", path: AppConstants.APP_NUMBER);
                          await launchUrl(url);
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Image.asset(
                            "assets/ic_phone_app.png",
                            fit: BoxFit.contain,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchWhatsapp();
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Image.asset(
                            "assets/ic_whatsapp.png",
                            fit: BoxFit.contain,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("FaceBookCLiked");
                          var url =
                              'fb://facewebmodal/f?href=https://www.facebook.com/odlay.superdeals';
                          await launch(
                            url,
                            universalLinksOnly: true,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Image.asset(
                            "assets/facebook.png",
                            fit: BoxFit.contain,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Image.asset(
                            "assets/twitter.png",
                            fit: BoxFit.contain,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, bottom: 30, top: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'title_my_acount_info'.tr,
                        style: Styles.textStyleHeadingMyAccount,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("EnableAccount${isShowEnableDisableAccount.value}");
                      if (isShowEnableDisableAccount.value == false) {
                        isShowEnableDisableAccount(true);
                      } else {
                        isShowEnableDisableAccount(false);
                      }
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'nav_my_account'.tr,
                          style: Styles.textStyleJobSheetbudget,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  isShowEnableDisableAccount.value
                      ? Container(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  print("PreDisAble");
                                  showAlertDialoueDisableAndDelete(
                                      context,
                                      AppConstants.DISABLEMYACCOUNT,
                                      "Are u sure you want to disable you account",
                                      "Disable Account");
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'disable_my_account'.tr,
                                      style: Styles.textStyleMyAccount,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showAlertDialoueDisableAndDelete(
                                      context,
                                      AppConstants.DISABLEMYACCOUNT,
                                      "Are u sure you want to Delete you account",
                                      "Delete Account");
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'delete_my_account'.tr,
                                      style: Styles.textStyleMyAccount,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.only(top: 5, left: 0, right: 10),
                    child: const Divider(
                      thickness: 2,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'general'.tr,
                      style: Styles.textStyleJobSheetbudget,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 0, top: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'change_language'.tr,
                          style: Styles.textStyleMyAccount,
                        ),
                        Container(
                          // padding: EdgeInsets.all(1),
                          margin: EdgeInsets.only(top: 10, right: 0),
                          height: 40,
    
                          child: Container(
                            // padding: EdgeInsets.all(1),
                            margin: EdgeInsets.only(top: 10, right: 10),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: Color.fromRGBO(255, 118, 87, 1))),
                            child: appRegion == 2
                                ? ToggleSwitch(
                                    minWidth: 60.0,
                                    minHeight: 90.0,
                                    fontSize: 10.0,
                                    initialLabelIndex:
                                        languageIntials == 1 ? 1 : 0,
                                    activeBgColor: [
                                      Color.fromRGBO(255, 118, 87, 1)
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.white,
                                    inactiveFgColor: Colors.grey[900],
                                    totalSwitches: 2,
                                    labels: ['English', 'Suomi'],
                                    onToggle: (index) async {
                                      if (index == 0) {
                                        print("SetLangEnglish");
                                        await _appController.changeLanguage(
                                            QueryChangeLanguage(
                                                id: responseLoginUser.user.id
                                                    .toString(),
                                                language: AppConstants
                                                    .LANGUAGE_ENGLISH
                                                    .toString()),
                                            apiKey.toString());
    
                                        await _appController.updateProfile(
                                            responseLoginUser.user.id.toString(),
                                            AppConstants.LANGUAGE_ENGLISH,
                                            apiKey.toString());
                                        _appController.readSkillCities(
                                            AppConstants.LANGUAGE_ENGLISH,
                                            apiKey.toString());
                                        Constants.sharedPreferences.setInt(
                                            SharePrefrencesValues
                                                .LANGUAGE_INTIALS,
                                            0);
                                        var locale = Locale('en');
                                        Get.updateLocale(locale);
                                      } else {
                                        print("SetLangSuomi");
                                        await _appController.changeLanguage(
                                            QueryChangeLanguage(
                                                id: responseLoginUser.user.id
                                                    .toString(),
                                                language: AppConstants
                                                    .LANGUAGE_SUOMI
                                                    .toString()),
                                            apiKey.toString());
                                        await _appController.updateProfile(
                                            responseLoginUser.user.id.toString(),
                                            AppConstants.LANGUAGE_SUOMI,
                                            apiKey.toString());
                                        _appController.readSkillCities(
                                            AppConstants.LANGUAGE_SUOMI,
                                            apiKey.toString());
                                        Constants.sharedPreferences.setInt(
                                            SharePrefrencesValues
                                                .LANGUAGE_INTIALS,
                                            1);
                                        var locale = Locale('fi');
                                        Get.updateLocale(locale);
                                      }
                                    },
                                  )
                                : ToggleSwitch(
                                    minWidth: 60.0,
                                    minHeight: 90.0,
                                    fontSize: 10.0,
                                    initialLabelIndex:
                                        languageIntials == 1 ? 1 : 0,
                                    activeBgColor: [
                                      Color.fromRGBO(255, 118, 87, 1)
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.white,
                                    inactiveFgColor: Colors.grey[900],
                                    totalSwitches: 2,
                                    labels: ['English', 'Urdu'],
                                    onToggle: (index) async {
                                      if (index == 0) {
                                        print("SetLangEnglish");
                                        Constants.sharedPreferences.setInt(
                                            SharePrefrencesValues
                                                .LANGUAGE_INTIALS,
                                            0);
                                        var locale = Locale('en');
                                        Get.updateLocale(locale);
                                      } else {
                                        print("SetLangUrdu");
                                        Constants.sharedPreferences.setInt(
                                            SharePrefrencesValues
                                                .LANGUAGE_INTIALS,
                                            1);
                                        var locale = Locale('ur');
                                        Get.updateLocale(locale);
                                      }
                                    },
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 0, top: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'notification'.tr,
                          style: Styles.textStyleMyAccount,
                        ),
                        SizedBox(
                          height: 20,
                          child: Switch(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: isSwitched,
                            onChanged: (value) async {
                              setState(() {
                                isSwitched = value;
                                print("IsSwitched${isSwitched.toString()}");
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogueAboutTermEtc();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'about_odlay_service'.tr,
                            style: Styles.textStyleMyAccount,
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.red)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogueAboutTermEtc();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'privacy_policy'.tr,
                            style: Styles.textStyleMyAccount,
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.red)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogueAboutTermEtc();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'help_support'.tr,
                            style: Styles.textStyleMyAccount,
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.red)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'rate_odlay'.tr,
                          style: Styles.textStyleMyAccount,
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 20, color: Colors.red)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 0, right: 10),
                    child: const Divider(
                      thickness: 2,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'payment'.tr,
                      style: Styles.textStyleJobSheetbudget,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print(
                          "SelectModeIsCustomer${AppConstants.isSlectedUserCustomer}");
                      if (AppConstants.isSlectedUserCustomer) {
                        print("LoadCustPage");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WalletPageCustomer()));
                      } else {
                        print("LoadSpWalletPage");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WalletPageSp()));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'wallet'.tr,
                            style: Styles.textStyleMyAccount,
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.red)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'wallet_method'.tr,
                          style: Styles.textStyleMyAccount,
                        ),
                        Text(
                          "coming soon",
                          style: Styles.textStyleStatusColor,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 0, right: 10),
                    child: const Divider(
                      thickness: 2,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showLogoutUser(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 5, left: 10,bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'signout'.tr,
                            style: Styles.textStyleSignOutAccount,
                          ),
                          const Icon(Icons.logout, size: 20, color: Colors.red)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _launchWhatsapp() async {
    var whatsapp = AppConstants.APP_NUMBER;
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");

    await launchUrl(whatsappAndroid);
  }

  showLogoutUser(BuildContext context) async {
    Widget okButton = TextButton(
      child: Text("yes"),
      onPressed: () {
        HeaderFilterConstant.isFilterApplied = true;
        _appController
            .signOutFromRdb(responseLoginUser.user.firebaseUid.toString());
        Constants.sharedPreferences.setBool("isLoggedIn", false);
        Constants.sharedPreferences.clear();
        
        Navigator.pushAndRemoveUntil(
          AppConstants.baseContext,
          MaterialPageRoute(builder: (context) => EnterPhone()),
          (Route<dynamic> route) => false,
        );
        showToast("User Logout Successfully",
            context: context, backgroundColor: Colors.green);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Signout"),
      content: Text("Are u user u want to logout??"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialoueDisableAndDelete(BuildContext context, int alertType,
      String alertMesage, String alertTitle) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(alertTitle),
              content: Text(alertMesage),
              actions: <Widget>[
                AppElevatedButton(
                    borderRadius: BorderRadius.circular(20),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('NO')),
                AppElevatedButton(
                    borderRadius: BorderRadius.circular(20),
                    onPressed: () async {
                      await _appController.disableMyAccount(
                          QuerDiableUser(
                              userId: responseLoginUser.user.id.toString(),
                              requestType: AppConstants.DISABLEMYACCOUNT),
                          apiKey.toString());
                      print(
                          "PostDisAble${responseLoginUser.user.firebaseUid.toString()}");
                      if (_appController.responseDiableUser.status ==
                          "success") {
                        _appController.signOutFromRdb(
                            responseLoginUser.user.firebaseUid.toString());
                        Constants.sharedPreferences
                            .setBool("isLoggedIn", false);
                        showToast("User Logout Successfully",
                            context: context, backgroundColor: Colors.green);
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          AppConstants.baseContext,
                          MaterialPageRoute(builder: (context) => EnterPhone()),
                          (Route<dynamic> route) => false,
                        );
                      } else if (_appController.responseDiableUser.status ==
                          "cust") {
                        showToast(
                            responseLoginUser.user.custMessages
                                .disableCustJobsInprogress.message,
                            context: context,
                            backgroundColor: Colors.blue);
                      } else {
                        Navigator.of(context).pop(false);
                        showToast(
                            responseLoginUser.user.spMessages
                                .disableSpJobsInprogress.message,
                            context: context,
                            backgroundColor: Colors.blue);
                      }
                    }, //  We can return any object from here
                    child: Text('YES'))
              ],
            )).then(
        (value) => print('Selected Alert Option: ' + value.toString()));
  }

  void showDialogueAboutTermEtc() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return PrivacyPolicyAgreementInApp();
          });
        });
  }
}
