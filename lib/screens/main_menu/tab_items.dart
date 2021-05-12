import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { HomePage, Search, Profile }

class TabItemData {
  final IconData icon;

  TabItemData(this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.HomePage: TabItemData(Icons.home),
    TabItem.Search: TabItemData(Icons.search),
    TabItem.Profile: TabItemData(Icons.person),
  };
}
