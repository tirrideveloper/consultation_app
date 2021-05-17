import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/models/app_localizations.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate("tab_item_home_page")),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
