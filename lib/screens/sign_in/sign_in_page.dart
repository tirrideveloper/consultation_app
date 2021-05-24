import 'dart:io';

import 'package:consultation_app/common_widget/basic_appbar.dart';
import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/tools/error_exception.dart';
import 'package:consultation_app/tools/tablet_detector.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:consultation_app/screens/sign_in/email_and_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

FirebaseAuthException myError;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (myError != null) {
          PlatformAlertDialog(
            title: "Facebook giriş hatası",
            content: Errors.showError(myError.code, context),
            buttonText: "Tamam",
          ).show(context);
        }
      },
    );
  }

  void _signInFacebook(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    try {
      await _userViewModel.signInFacebook();
    } on FirebaseAuthException catch (e) {
      myError = e;
    }
  }


  Widget buildImage(String path, double height) => Image.asset(path,
      fit: BoxFit.cover,
      height: TabletDetector.isTablet() != true ? height : height / 0.56);

  void _signInGoogle(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userViewModel.signInGoogle();
    if (_user != null) {
      print("ID USER ID USER: " + _user.userId.toString());
    }
  }

  void _emailAndPassword(BuildContext context) {
    if (Platform.isIOS) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => EmailAndPassword(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => EmailAndPassword(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BasicAppBar(),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BasicButton(
              buttonText:
                  AppLocalizations.of(context).translate("login_google"),
              buttonColor: Colors.white,
              buttonTextColor: Colors.black,
              buttonIcon: buildImage("assets/images/google_logo.png", 30),
              buttonOnPressed: () => _signInGoogle(context),
              buttonHeight: 45,
              buttonTextSize: 16,
              buttonRadius: 15,
              buttonMargin: 10,
            ),
            BasicButton(
              buttonText:
                  AppLocalizations.of(context).translate("login_facebook"),
              buttonColor: Color(0xff3b5998),
              buttonTextColor: Colors.white,
              buttonIcon: buildImage("assets/images/facebook_logo.png", 30),
              buttonOnPressed: () => _signInFacebook(context),
              buttonHeight: 45,
              buttonTextSize: 16,
              buttonRadius: 15,
              buttonMargin: 10,
            ),
            BasicButton(
              buttonText:
                  AppLocalizations.of(context).translate("login_mail_or_phone"),
              buttonColor: Theme.of(context).primaryColor,
              buttonTextColor: Colors.white,
              buttonIcon:
                  buildImage("assets/images/mail_or_phone_icon.png", 30),
              buttonOnPressed: () => _emailAndPassword(context),
              buttonHeight: 45,
              buttonTextSize: 16,
              buttonRadius: 15,
              buttonMargin: 10,
            ),
          ],
        ),
      ),
    );
  }
}
