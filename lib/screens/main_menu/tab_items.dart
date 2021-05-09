import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { AnaSayfa, Arama, Profil }

class TabItemData {
  final IconData icon;

  TabItemData(this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.AnaSayfa: TabItemData(Icons.home),
    TabItem.Arama: TabItemData(Icons.search),
    TabItem.Profil: TabItemData(Icons.person),
  };
}
