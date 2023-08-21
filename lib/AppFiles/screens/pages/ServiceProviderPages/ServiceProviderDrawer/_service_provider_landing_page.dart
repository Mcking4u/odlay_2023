import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:odlay_services/AppFiles/Controller/app_controller.dart';
import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:odlay_services/AppFiles/model/AuthModels/response_login_user.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_conversion_header.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/_my_account_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CombinedPages/conversion_header_cover.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/HomePage/home_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/JobManagerPage/_customer_job_manger.dart';
import 'package:odlay_services/AppFiles/screens/pages/CustomerPages/ProfilePage/profil_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/HomePage/_service_privovider_home_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/HomePage/home_page_sp.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/_service_provider_job_manger.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/JobManagerPage/_service_provider_page_cover.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_profile_page.dart';
import 'package:odlay_services/AppFiles/screens/pages/ServiceProviderPages/ProfilePage/_sp_profile_page_landing.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:get/get.dart';

class ServiceProviderLandingPage extends StatefulWidget {
  int iniialPage;
  ServiceProviderLandingPage(this.iniialPage);
  @override
  State<ServiceProviderLandingPage> createState() =>
      _ServiceProviderLandingPageState();
}

class _ServiceProviderLandingPageState
    extends State<ServiceProviderLandingPage> {
  late PersistentTabController _controller;
  AppController _appController = Get.put(AppController());
  late ResponseLoginUser responseLoginUser;
  String? skill_data;

  List<Widget> _buildScreens() {
    return [
      SpHomePageCover(context),
      SpProfilePageCover(),
      SpJobManagerPageCover(),
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
        title: ('nav_job_manager'.tr),
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
    responseLoginUser = responseLoginUserFromJson(user_data!);
    print("PlaneApiKey${responseLoginUser.user.apiPlanText}");
    print("EncryApiKey${responseLoginUser.user.apiKey}");
    print("ConsumerId${responseLoginUser.user.consumer.userId}");
    skill_data = Constants.sharedPreferences
        .getString(SharePrefrencesValues.SKILLCITIESCATGORIES);
//getting saved apiKey
    String? apiKey =
        Constants.sharedPreferences.getString(SharePrefrencesValues.API_KEY);
    print("SavedKey${apiKey}");
    _appController.updateProfile(responseLoginUser.user.id.toString(),
        responseLoginUser.user.language, apiKey.toString());
    _appController.readSkillCities(
        responseLoginUser.user.language, apiKey.toString());
//set base context
    AppConstants.baseContext = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = PersistentTabController(initialIndex:widget.iniialPage);
    return skill_data != null
        ? PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.grey, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: false, // Default is true.
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
              stateManagement: false, // Default is true.
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
  }
}
