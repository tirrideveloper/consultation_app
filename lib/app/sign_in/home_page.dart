import 'package:consultation_app/app/sign_in/kullanicilar.dart';
import 'package:consultation_app/app/sign_in/my_custom_bottom_navi.dart';
import 'package:consultation_app/app/sign_in/profil.dart';
import 'package:consultation_app/app/sign_in/tab_items.dart';
import 'package:consultation_app/models/user_model.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key,@required this.user})
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 TabItem _currentTab = TabItem.Kullanicilar;
 Map<TabItem,Widget> tumSayfalar (){
   return {
     TabItem.Kullanicilar:KullanicilarPage(),
     TabItem.Profil:ProfilPage(),
   };
 }
  @override
  Widget build(BuildContext context) {
    return
      Container(
        child: MyCustomBottomNavigation(
          sayfaOlusturucu:tumSayfalar(),
          currentTab: _currentTab,
          onSelectedTab: (secilenTab){
          setState(() {
            _currentTab=secilenTab;
          });
          print("Secilen tab item?"+secilenTab.toString());
        },

        ),
      );

  }

}

