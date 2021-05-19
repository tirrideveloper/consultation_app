import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/tools/error_exception.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn, resetPassword }

class EmailAndPassword extends StatefulWidget {
  @override
  _EmailAndPasswordState createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool _isHidden = true;
  String _email, _password;
  String _buttonText, _linkText;
  var _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();
  bool _showForgetPassword = true;
  String _appBarText;

  Future<void> _formSubmit() async {
    _formKey.currentState.save();
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      try {
        await _userViewModel.signInEmailAndPassword(_email, _password);
        //if (_signedUser != null)
        //print("signed user id:" + _signedUser.userId.toString());
      } on FirebaseAuthException catch (e) {
        return PlatformAlertDialog(
          title: AppLocalizations.of(context).translate("login_error"),
          content: Errors.showError(e.code, context),
          buttonText: AppLocalizations.of(context).translate("okay_text"),
        ).show(context);
      }
    } else if (_formType == FormType.resetPassword) {
      try {
        await _userViewModel.resetUserPassword(_email);
        setState(() {
          _formType = FormType.LogIn;
        });
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Resetleme maili gönderildi",
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
      }catch (e) {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppLocalizations.of(context).translate("user_not_found_error"),
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
      }
    } else {
      try {
        await _userViewModel.createEmailAndPassword(_email, _password);
        //if (_createdUser != null)
        //print("created user id:" + _createdUser.userId.toString());
      } on FirebaseAuthException catch (e) {
        return PlatformAlertDialog(
          title: AppLocalizations.of(context).translate("signup_error"),
          content: Errors.showError(e.code, context),
          buttonText: AppLocalizations.of(context).translate("okay_text"),
        ).show(context);
      }
    }
  }

  void _change() {
    setState(() {
      if (_formType == FormType.LogIn) {
        _formType = FormType.Register;
      } else if (_formType == FormType.Register) {
        _formType = FormType.LogIn;
      } else {
        _formType = FormType.LogIn;
      }
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_formType == FormType.LogIn) {
      _showForgetPassword = true;
      _buttonText = AppLocalizations.of(context).translate("login_text");
      _linkText =
          AppLocalizations.of(context).translate("account_question_sign_in");
      _appBarText = "Giriş yap";
    } else if (_formType == FormType.Register) {
      _showForgetPassword = false;
      _buttonText = AppLocalizations.of(context).translate("sign_up_text");
      _linkText =
          AppLocalizations.of(context).translate("account_question_login");
      _appBarText = "Hesap oluştur";
    } else {
      _showForgetPassword = false;
      _buttonText = "sıfırla";
      _linkText = "girişe geri dön";
      _appBarText = "Şifre sıfırla";
    }

    final _userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel.user != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarText),
      ),
      body: _userViewModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _userViewModel.emailError != null
                              ? _userViewModel.emailError
                              : null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Email",
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String inputEmail) {
                          _email = inputEmail;
                        },
                      ),
                      SizedBox(height: 8),
                      _formType == FormType.resetPassword
                          ? SizedBox(
                              height: 0,
                            )
                          : TextFormField(
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                errorText: _userViewModel.passwordError != null
                                    ? _userViewModel.passwordError
                                    : null,
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                hintText: AppLocalizations.of(context)
                                    .translate("sign_in_password"),
                                labelText: AppLocalizations.of(context)
                                    .translate("sign_in_password"),
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (String inputPassword) {
                                _password = inputPassword;
                              },
                            ),
                      SizedBox(height: 8),
                      BasicButton(
                        buttonText: _buttonText,
                        buttonColor: Theme.of(context).primaryColor,
                        buttonOnPressed: () => _formSubmit(),
                        buttonHeight: 40,
                        buttonTextSize: 16,
                        buttonRadius: 15,
                      ),
                      TextButton(
                        onPressed: () => _change(),
                        child: Text(_linkText),
                      ),
                      showForgotPassword(_showForgetPassword),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: TextButton(
        onPressed: () {
          setState(() {
            _formType = FormType.resetPassword;
          });
        },
        child: Text(
          "Parolanızı unuttunuz mu?",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
      visible: visible,
    );
  }
}
