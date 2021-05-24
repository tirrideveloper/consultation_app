import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNamePassword extends StatefulWidget {
  @override
  _UserNamePasswordState createState() => _UserNamePasswordState();
}

class _UserNamePasswordState extends State<UserNamePassword> {

  TextEditingController _controllerUserName;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Güvenlik"),
      ),
      body: Center(
        child: Column(
          children: [
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
}
