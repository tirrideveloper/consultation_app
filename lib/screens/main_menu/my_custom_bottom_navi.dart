import 'package:consultation_app/screens/main_menu/tab_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;

  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.sayfaOlusturucu})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlustur(TabItem.Kullanicilar),
          _navItemOlustur(TabItem.Profil),
          _navItemOlustur(TabItem.Arama),
          _navItemOlustur(TabItem.Ayarlar),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final gosterilecekItem = TabItem.values[index];
        return CupertinoTabView(builder: (context) {
          return sayfaOlusturucu[gosterilecekItem];
        });
      },
    );
  }
}

BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
  final olusturulacakTab = TabItemData.tumTablar[tabItem];
  String bottomLabel = olusturulacakTab.title;
  return BottomNavigationBarItem(
    icon: Icon(olusturulacakTab.icon),
    label: bottomLabel,
  );
}
