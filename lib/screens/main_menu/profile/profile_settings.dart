import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/models/user_view_model.dart';
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
                "İsim Soyisim",
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
                "Kullanıcı Adı",
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Hakkında",
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
              SizedBox(
                height: 10,
              ),
              BasicButton(
                buttonText: "Kaydet",
                buttonOnPressed: () {
                  _userNameUpdate(context);
                },
                buttonColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _userNameUpdate(BuildContext context) async {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_viewModel.user.userName != _controllerUserName.text) {
      var updateResult = await _viewModel.updateUserName(
          _viewModel.user.userId, _controllerUserName.text);

      if (updateResult == true) {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Güncelleme Başarılı", style: TextStyle(fontSize: 14),),
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            label: "Tamam",
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        _controllerUserName.text = _viewModel.user.userName;
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Username Kullanılmakta", style: TextStyle(fontSize: 14),),
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            label: "Tamam",
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Kullanıcı adı değiştirilmedi", style: TextStyle(fontSize: 14),),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
          label: "Tamam",
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
