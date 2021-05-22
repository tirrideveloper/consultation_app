import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controllerNameSurname,
      _controllerUserName,
      _controllerAboutUser;

  @override
  void initState() {
    super.initState();
    _controllerNameSurname = TextEditingController();
    _controllerUserName = TextEditingController();
    _controllerAboutUser = TextEditingController();
  }

  @override
  void dispose() {
    _controllerNameSurname.dispose();
    _controllerUserName.dispose();
    _controllerAboutUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);

    _controllerNameSurname.text = _viewModel.user.nameSurname;
    _controllerUserName.text = _viewModel.user.userName;
    _controllerAboutUser.text = _viewModel.user.aboutUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("tab_item_settings"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).translate("name_surname_text"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerNameSurname,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context).translate("about_text"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerAboutUser,
                maxLines: 2,
                maxLength: 250,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Container(
                width: 160,
                child: BasicButton(
                  buttonText: AppLocalizations.of(context)
                      .translate("update_information_text"),
                  buttonOnPressed: () {
                    _userUpdate(context);
                  },
                  buttonColor: Theme.of(context).primaryColor,
                  buttonMargin: 0,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                AppLocalizations.of(context).translate("username_text"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerUserName,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  AppLocalizations.of(context)
                      .translate("update_username_warning"),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Container(
                width: 165,
                child: BasicButton(
                  buttonText: AppLocalizations.of(context)
                      .translate("update_username_text"),
                  buttonOnPressed: () {
                    _userNameUpdate(context);
                  },
                  buttonMargin: 0,
                  buttonColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _userNameUpdate(BuildContext context) async {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    bool usernameValid = RegExp(r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$')
        .hasMatch(_controllerUserName.text);

    if (usernameValid) {
      if (_viewModel.user.userName != _controllerUserName.text) {
        var updateResult = await _viewModel.updateUserName(
            _viewModel.user.userId, _controllerUserName.text);

        if (updateResult == true) {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              AppLocalizations.of(context).translate("successful_update"),
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            action: SnackBarAction(
              textColor: Colors.white,
              label: AppLocalizations.of(context).translate("okay_text"),
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          _controllerUserName.text = _viewModel.user.userName;
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              AppLocalizations.of(context).translate("username_already_taken"),
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              textColor: Colors.white,
              label: AppLocalizations.of(context).translate("okay_text"),
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppLocalizations.of(context).translate("error_occurred_text"),
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            textColor: Colors.white,
            label: AppLocalizations.of(context).translate("okay_text"),
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    else{
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "geçerli bir kullanıcı adı girin",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          textColor: Colors.white,
          label: AppLocalizations.of(context).translate("okay_text"),
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _userUpdate(BuildContext context) async {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    var updateResult = await _viewModel.updateUser(_viewModel.user.userId,
        _controllerNameSurname.text.trim(), _controllerAboutUser.text.trim());
    if (updateResult == true) {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          AppLocalizations.of(context).translate("successful_update"),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
          textColor: Colors.white,
          label: AppLocalizations.of(context).translate("okay_text"),
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          AppLocalizations.of(context).translate("error_occurred_text"),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          textColor: Colors.white,
          label: AppLocalizations.of(context).translate("okay_text"),
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
