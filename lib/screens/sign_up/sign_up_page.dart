import 'package:consultation_app/common_widget/basic_appbar.dart';
import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/common_widget/login_anon_widget.dart';
import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            buttonIcon: buildImage("assets/images/google_logo.png", 28),
            buttonOnPressed: () => _signInGoogle(context),
            buttonHeight: 45,
          ),
          BasicButton(
            buttonText:
                AppLocalizations.of(context).translate("login_facebook"),
            buttonColor: Color(0xff3b5998),
            buttonTextColor: Colors.white,
            buttonIcon: buildImage("assets/images/facebook_logo.png", 28),
            buttonOnPressed: () {},
            buttonHeight: 45,
          ),
          BasicButton(
            buttonText:
                AppLocalizations.of(context).translate("login_mail_or_phone"),
            buttonColor: Theme.of(context).primaryColor,
            buttonTextColor: Colors.white,
            buttonIcon: buildImage("assets/images/mail_or_phone_icon.png", 34),
            buttonOnPressed: () {},
            buttonHeight: 45,
          ),
        ],
      ),
    );
  }

  Widget buildImage(String path, double height) =>
      Image.asset(path, fit: BoxFit.cover, height: height);
  
  void _signInGoogle(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userViewModel.signInGoogle();
    if(_user != null){
      print("ID USER ID USER: " + _user.userId.toString());
    }
  }
}
