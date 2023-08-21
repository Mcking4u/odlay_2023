import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/JobConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/model/CombinedModels/skill_city_professions.dart';
import 'package:odlay_services/AppFiles/model/WalletModel/_query_wallet.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/Wallet/Item_wallet_card.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/Wallet/_wallet_header.dart';
import 'package:odlay_services/Styles/styles.dart';

class WalletPageCustomer extends StatefulWidget {
  @override
  State<WalletPageCustomer> createState() => _WalletPageStateCustomer();
}

class _WalletPageStateCustomer extends State<WalletPageCustomer> {
  late SkillCitiesProfessions skillCitiesProfessions;
  late ResponseLoginUser responseLoginUser;
  late String? apiKey;
  final AppController _appController = Get.put(AppController());
  @override
  void initState() {
    String? skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    skillCitiesProfessions = skillCitiesProfessionsFromJson(skill_data!);
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    responseLoginUser = responseLoginUserFromJson(user_data!);
    _appController.getWalletInfoCustomer(
        QueryWallet(
            userId: responseLoginUser.user.consumer.userId.toString(),
            key: "customer"),
        apiKey.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_appController.walletResponseValueCust.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          child: Column(
            children: [
              WalletHeaderCustomer(
                  _appController.walletResponseCust, responseLoginUser),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child:
                      _appController.walletResponseCust.paymentInfo != null &&
                              _appController
                                  .walletResponseCust.paymentInfo.isNotEmpty
                          ? ListView.builder(
                              itemCount: _appController
                                  .walletResponseCust.paymentInfo.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {},
                                    child: ItemWalletCard(
                                        _appController.walletResponseCust
                                            .paymentInfo[index],
                                        responseLoginUser));
                              })
                          : Container(
                              child: Text(
                                "No Data Found",
                                style: Styles.headingText,
                              ),
                            ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
