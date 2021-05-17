import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { HomePage, Search, Messages ,Profile}

class TabItemData {
  final IconData icon;

  TabItemData(this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.HomePage: TabItemData(Icons.home_outlined),
    TabItem.Search: TabItemData(Icons.search_outlined),
    TabItem.Messages: TabItemData(Icons.chat_bubble_outline),
    TabItem.Profile: TabItemData(Icons.person_outline),
  };
}
