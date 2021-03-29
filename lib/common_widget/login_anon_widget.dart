import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginAnonWidget extends StatelessWidget {
  void _guestLogin(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userViewModel.signInAnon();
    print("ID USER ID USER: " + _user.userId.toString());
  }

  //Her anon giriş denemesinde firebase üzerinde yeni bir hesap açılıyor.
  //Bunun yerine kullanıcı id'si cihaza özel sabit kalsa daha iyi.

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _guestLogin(context),
            child: Text(
              AppLocalizations.of(context).translate("without_sign_up"),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
