import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/screens/main_menu/search/arama.dart';
import 'package:consultation_app/screens/main_menu/kullanicilar.dart';
import 'package:consultation_app/screens/main_menu/my_custom_bottom_navi.dart';
import 'package:consultation_app/screens/main_menu/profile/profile_page.dart';
import 'package:consultation_app/screens/main_menu/tab_items.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  HomePage({Key key, @required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.AnaSayfa;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.AnaSayfa: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.AnaSayfa: KullanicilarPage(),
      TabItem.Profil: ProfilePage(),
      TabItem.Arama: Aramapage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
