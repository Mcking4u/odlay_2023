import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';

import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_my_account_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/conversion_header_cover.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/_home_page_cover.dart';

import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/_job_manger_cover.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/ProfilePage/_customer_profile_page_cover.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:get/get.dart';

class CustomerLandingPage extends StatefulWidget {
  int initialIndex;
  CustomerLandingPage(this.initialIndex);
  @override
  State<CustomerLandingPage> createState() => _CustomerLandingPageState();

}

class _CustomerLandingPageState extends State<CustomerLandingPage> {
  static late PersistentTabController _controller;
  AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  String? skill_data;
  List<Widget> _buildScreens() {
    print("AllScreenReBuild");
    return [
      HomePageCover(),
      ProfilePageCover(),
      JobPageCover(),
      ConversationCover(),
      MyAccount()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Image.asset(
            "assets/ic_home _nav.png",
            color: Colors.white,
          ),
          title: ('nav_home'.tr),
          onSelectedTabPressWhenNoScreensPushed: () {
            print("onSelectedTabPressWhenNoScreensPushed");
          },
          activeColorPrimary: const Color.fromRGBO(255, 118, 87, 1),
          inactiveColorPrimary: CupertinoColors.white,
          activeColorSecondary: Colors.white),
      PersistentBottomNavBarItem(
        
        icon: const Icon(CupertinoIcons.person_fill),
        title: ('nav_Profile'.tr),
        activeColorPrimary: const Color.fromRGBO(255, 118, 87, 1),
        inactiveColorPrimary: CupertinoColors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/ic_job_manager_nav.png",
          color: Colors.white,
        ),
        title: ("nav_job_manager".tr),
        activeColorPrimary: const Color.fromRGBO(255, 118, 87, 1),
        inactiveColorPrimary: CupertinoColors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/ic_conversation _nav.png",
          color: Colors.white,
        ),
        title: ('nav_job_conversatin'.tr),
        activeColorPrimary: const Color.fromRGBO(255, 118, 87, 1),
        inactiveColorPrimary: CupertinoColors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/ic_account _nav.png",
          color: Colors.white,
        ),
        title: ('nav_my_account'.tr),
        activeColorPrimary: const Color.fromRGBO(255, 118, 87, 1),
        inactiveColorPrimary: CupertinoColors.white,
        activeColorSecondary: Colors.white,
      ),
    ];
  }

  @override
  void initState() {
    //fetch saved user detail
    print("KeySavedUser${SharePrefrencesValues.SAVEDUSERDATA}");
    String? user_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SAVEDUSERDATA);
    String? apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    print("SavedKey${apiKey}");
    responseLoginUser = responseLoginUserFromJson(user_data!);
    print("PlaneApiKey${responseLoginUser.user.apiPlanText}");
    print("ConsumerId${responseLoginUser.user.consumer.userId}");
    _appController.updateProfile(responseLoginUser.user.id.toString(),
        responseLoginUser.user.language, apiKey.toString());
    skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
    print("PreSkillDta${skill_data}");

    _appController.readSkillCities(
        responseLoginUser.user.language, apiKey.toString());
    AppConstants.baseContext = context;
    print("PostSkillDta");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = PersistentTabController(initialIndex: widget.initialIndex);
    print("CustomerLandingPageBuild${skill_data}");
    return skill_data != null
        ? PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor:
                Color.fromARGB(255, 182, 181, 181), // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement:
                _controller.index == 0 ? false : true, // Default is true.
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style7, // Choose the nav bar style with this property.
          )
        : Container(child: Obx(() {
            if (_appController.skillCitiesProfessionsValue.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Color.fromARGB(
                  255, 182, 181, 181), // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset:
                  true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true, // Default is true.
              hideNavigationBarWhenKeyboardShows:
                  true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: const ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle
                  .style7, // Choose the nav bar style with this property.
            );
          }));

    ;
  }
  
}
