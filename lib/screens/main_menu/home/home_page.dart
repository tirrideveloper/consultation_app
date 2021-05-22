import 'dart:io';

import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/screens/main_menu/home/konu_giris.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/case_view_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate("tab_item_home_page")),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) =>
                            CaseViewModel(currentUser: _viewModel.user),
                        child: EnterNewCase(),
                      ),
                    ),
                  );
                } else if (Platform.isIOS) {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) =>
                            CaseViewModel(currentUser: _viewModel.user),
                        child: EnterNewCase(),
                      ),
                    ),
                  );;
                }
              },
              child: Text("NAABER"),
            )
          ],
        ),
      ),
    );
  }
}
