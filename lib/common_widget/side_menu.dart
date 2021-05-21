import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:consultation_app/screens/main_menu/profile/profile_page.dart';
import 'package:consultation_app/screens/main_menu/settings/profile_settings.dart';
import 'package:consultation_app/screens/main_menu/settings/verify_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff689f38),
                    Color(0xff99ca00),
                  ]),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_viewModel.user.profileURL),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: _viewModel.user.nameSurname,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            children: [
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: _viewModel.user.userName,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Color(0xff689f38),
            ),
            title: Text(
                AppLocalizations.of(context).translate("tab_item_settings")),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user_outlined, color: Color(0xff689f38)),
            title: Text('Onaylama'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(builder: (context) => VerifyUser()));
            },
          ),
          ListTile(
            leading: Icon(Icons.security_outlined, color: Color(0xff689f38)),
            title: Text('Şifre ve kullanıcı adı değiştirme'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.feedback_outlined, color: Color(0xff689f38)),
            title: Text('Geri Bildirim gönder'),
          ),
          ListTile(
            leading: Icon(
              Icons.contact_support_outlined,
              color: Color(0xff689f38),
              size: 26,
            ),
            title: Text('Bize Ulaşın'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Color(0xff689f38)),
            title: Text('Hakkında'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Color(0xff689f38)),
            title: Text('Logout'),
            onTap: () => _signOutConfirmation(context),
          ),
        ],
      ),
    );
  }

  Future _signOutConfirmation(BuildContext context) async {
    final result = await PlatformAlertDialog(
      title: "exit",
      content: "sure?",
      buttonText: "okay",
      button2Text: "cancel",
    ).show(context);
    if (result == true) {
      _signOut(context);
    }
  }

  Future<bool> _signOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
}
