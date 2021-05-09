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
  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);

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
                initialValue: _viewModel.user.nameSurname,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15,5,15,5),
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
                initialValue: _viewModel.user.userName,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15,5,15,5),
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
                initialValue: _viewModel.user.aboutUser == "null" ? "" : _viewModel.user.aboutUser,
                maxLines: 2,
                maxLength: 250,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20,10,20,10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
