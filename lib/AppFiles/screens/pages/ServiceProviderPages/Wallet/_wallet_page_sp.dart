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
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/Wallet/Item_wallet_card_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/Wallet/_wallet_header_sp.dart';

class WalletPageSp extends StatefulWidget {
  @override
  State<WalletPageSp> createState() => _WalletPageStateSp();
}

class _WalletPageStateSp extends State<WalletPageSp> {
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
    _appController.getWalletInfoSp(
        QueryWallet(
            userId: responseLoginUser.user.consumer.userId.toString(),
            key: "service provider"),
        apiKey.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_appController.walletResponseValueSp.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          child: Column(
            children: [
              WalletHeaderSp(
                  _appController.walletResponseSp, responseLoginUser),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount:
                          _appController.walletResponseSp.paymentInfo!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {},
                            child: ItemWalletCardSp(
                                _appController
                                    .walletResponseSp.paymentInfo![index],
                                responseLoginUser));
                      }),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
