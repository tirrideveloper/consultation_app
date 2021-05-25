import 'dart:io';

import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
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
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: "ConsulApp'ten çıkılsın mı?",
        content: "Oturumunuz kapanmayacaktır",
        buttonText: "Evet",
        button2Text: "Hayır",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).translate("tab_item_home_page")),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.only(right: 7, bottom: 50),
          child: FloatingActionButton(
            onPressed: () {
              if (_viewModel.user.verifiedUser) {
                _addNewCase();
              }
              PlatformAlertDialog(title: "Onaylama hatası", content: "Vaka girmeden önce lütfen hesabınızı onaylayın.", buttonText: "Tamam").show(context);
            },
            elevation: 2,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text("+\nCase", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
          ),
        ),
        drawer: NavDrawer(),
        body: Center(
          child: Column(
            children: [
            ],
          ),
        ),
      ),
    );
  }
  void _addNewCase(){
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
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
      );
    }
  }
}
