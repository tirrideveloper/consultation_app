import 'package:consultation_app/screens/main_menu/navigation_bar/tab_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.pageBuilder,
      @required this.navigatorKeys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Theme.of(context).primaryColor,
        items: [
          _createNavItem(TabItem.HomePage),
          _createNavItem(TabItem.Search),
          _createNavItem(TabItem.Profile),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final shownItem = TabItem.values[index];
        return CupertinoTabView(
            navigatorKey: navigatorKeys[shownItem],
            builder: (context) {
              return pageBuilder[shownItem];
            });
      },
    );
  }
}

BottomNavigationBarItem _createNavItem(TabItem tabItem) {
  final createdTab = TabItemData.allTabs[tabItem];
  return BottomNavigationBarItem(icon: Icon(createdTab.icon));
}
