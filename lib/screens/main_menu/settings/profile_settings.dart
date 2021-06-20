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
      _controllerAboutUser, _controllerProfession;

  @override
  void initState() {
    super.initState();
    _controllerNameSurname = TextEditingController();
    _controllerAboutUser = TextEditingController();
    _controllerProfession = TextEditingController();
  }

  @override
  void dispose() {
    _controllerNameSurname.dispose();
    _controllerAboutUser.dispose();
    _controllerProfession.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);

    _controllerNameSurname.text = _viewModel.user.nameSurname;
    _controllerAboutUser.text = _viewModel.user.aboutUser;
    _controllerProfession.text = _viewModel.user.userProfession;

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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                maxLines: 3,
                maxLength: 250,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15, 15, 20, 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context).translate("profession_txt"),
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
                controller: _controllerProfession,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }

  void _userUpdate(BuildContext context) async {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    var updateResult = await _viewModel.updateUser(_viewModel.user.userId,
        _controllerNameSurname.text.trim(), _controllerAboutUser.text.trim(), _controllerProfession.text.trim());
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
