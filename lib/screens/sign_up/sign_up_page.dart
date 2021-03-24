import 'package:consultation_app/common_widget/basic_appbar.dart';
import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/common_widget/login_anon_widget.dart';
import 'package:consultation_app/models/app_localizations.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BasicAppBar(),
      ),
      body: SignUpBody(),
      persistentFooterButtons: [
        LoginAnonWidget(),
      ],
    );
  }
}

class SignUpBody extends StatelessWidget {
  const SignUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BasicButton(
            buttonText: AppLocalizations.of(context).translate("login_google"),
            buttonColor: Colors.white,
            buttonTextColor: Colors.black,
            buttonIcon: FlutterLogo(),
            buttonOnPressed: () {},
            buttonHeight: 45,
          ),
          BasicButton(
            buttonText:
                AppLocalizations.of(context).translate("login_facebook"),
            buttonColor: Color(0xff3b5998),
            buttonTextColor: Colors.white,
            buttonIcon: FlutterLogo(),
            buttonOnPressed: () {},
            buttonHeight: 45,
          ),
          BasicButton(
            buttonText:
                AppLocalizations.of(context).translate("login_mail_phone"),
            buttonColor: Colors.red.shade500,
            buttonTextColor: Colors.white,
            buttonIcon: FlutterLogo(),
            buttonOnPressed: () {},
            buttonHeight: 45,
          ),
        ],
      ),
    );
  }
}