import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/screens/main_menu/navigation_bar/home_page.dart';
import 'package:consultation_app/screens/main_menu/navigation_bar/my_custom_bottom_navi.dart';
import 'package:consultation_app/screens/main_menu/profile/profile_page.dart';
import 'package:consultation_app/screens/main_menu/search/search_page.dart';
import 'package:consultation_app/screens/main_menu/navigation_bar/tab_items.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final UserModel user;

  MainPage({Key key, @required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TabItem _currentTab = TabItem.HomePage;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.HomePage: GlobalKey<NavigatorState>(),
    TabItem.Search : GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.HomePage: HomePage(),
      TabItem.Profile: ProfilePage(),
      TabItem.Search: SearchPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        pageBuilder: allPages(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (chosenTab) {
          if (chosenTab == _currentTab) {
            navigatorKeys[chosenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = chosenTab;
            });
          }
        },
      ),
    );
  }
}
