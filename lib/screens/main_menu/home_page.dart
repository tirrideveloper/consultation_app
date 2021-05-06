import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/screens/main_menu/search/arama.dart';
import 'package:consultation_app/screens/main_menu/settings/ayarlar.dart';
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
  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Profil: ProfilePage(),
      TabItem.Ayarlar: SettingsPage(),
      TabItem.Arama: Aramapage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          setState(() {
            _currentTab = secilenTab;
          });
          print("Secilen tab item?" + secilenTab.toString());
        },
      ),
    );
  }
}
