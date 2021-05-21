import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/screens/main_menu/home/konu_giris.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate("tab_item_home_page")),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Column(
          children: [
            Text("AM"),
            FloatingActionButton(
              onPressed: () => Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(fullscreenDialog: true, builder: (context) => KonuGir())),
            )
          ],
        ),
      ),
    );
  }
}
