import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/tools/error_exception.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNamePassword extends StatefulWidget {
  @override
  _UserNamePasswordState createState() => _UserNamePasswordState();
}

class _UserNamePasswordState extends State<UserNamePassword> {
  var _controllerUserName = TextEditingController();
  var _passwordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool checkPasswordValid = true;
  bool _isHidden1 = true;
  bool _isHidden2 = true;

  @override
  void dispose() {
    _controllerUserName.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controllerUserName = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text:
                AppLocalizations.of(context).translate("change_username_pass"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            children: [
              TextSpan(
                text: "\n@" + _userViewModel.user.userName,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 3),
                child: Text(
                  AppLocalizations.of(context).translate("username_text"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _controllerUserName,
                decoration: InputDecoration(
                  hintText: _userViewModel.user.userName,
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: Text(
                  AppLocalizations.of(context)
                      .translate("update_username_warning"),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Container(
                width: 150,
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
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 3),
                child: Text(
                  "Password Değiştir",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isHidden1,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isHidden1 = !_isHidden1;
                            });
                          },
                          child: Icon(
                            _isHidden1 ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        hintText: "Şifreniz",
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
                      height: 10,
                    ),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _isHidden2,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isHidden2 = !_isHidden2;
                            });
                          },
                          child: Icon(
                            _isHidden2 ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        hintText: "Yeni şifre",
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
                      height: 10,
                    ),
                    TextFormField(
                      controller: _repeatPasswordController,
                      obscureText: _isHidden2,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isHidden2 = !_isHidden2;
                            });
                          },
                          child: Icon(
                            _isHidden2 ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        hintText: "Yeni şifre tekrar",
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      validator: (value) {
                        return _newPasswordController.text == value
                            ? null
                            : "şifreler aynı olsun";
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          child: BasicButton(
                            buttonText: "Şifre değiştir",
                            buttonOnPressed: () async {
                              try {
                                checkPasswordValid = await _userViewModel
                                    .checkPassword(_passwordController.text);
                              } on FirebaseAuthException catch (e) {
                                return PlatformAlertDialog(
                                  title: "Şifre hatası",
                                  content: Errors.showError(e.code, context),
                                  buttonText: AppLocalizations.of(context)
                                      .translate("okay_text"),
                                ).show(context);
                              }
                              if (_formKey.currentState.validate() &&
                                  checkPasswordValid) {
                                var result =
                                    await _userViewModel.updateUserPassword(
                                        _newPasswordController.text);
                                if (result) {
                                  final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      "Şifre güncellendi",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    backgroundColor: Theme.of(context).primaryColor,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  await Future.delayed(Duration(seconds: 2));
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                } else {
                                  PlatformAlertDialog(
                                    title: "HATA",
                                    content: Errors.showError("", context),
                                    buttonText: AppLocalizations.of(context)
                                        .translate("okay_text"),
                                  ).show(context);
                                }
                              } else {
                                print("SIKINTI");
                              }
                            },
                            buttonMargin: 0,
                            buttonColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _userViewModel
                                .resetUserPassword(_userViewModel.user.email);
                            final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                AppLocalizations.of(context)
                                    .translate("reset_password_mail"),
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            await Future.delayed(Duration(seconds: 2));
                            await _userViewModel.signOut();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Veya şifrenizi sıfırlayın",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ],
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
    } else {
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
