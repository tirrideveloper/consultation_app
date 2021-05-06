import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Profil, Arama, Ayarlar }

class TabItemData {
  final IconData icon;

  TabItemData(this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Kullanicilar: TabItemData(Icons.home),
    TabItem.Profil: TabItemData(Icons.person),
    TabItem.Arama: TabItemData(Icons.search),
    TabItem.Ayarlar: TabItemData(Icons.settings)
  };
}
