import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/error_exception.dart';
import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

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

  Future<void> _formSubmit() async {
    _formKey.currentState.save();
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      try {
        UserModel _signedUser =
            await _userViewModel.signInEmailAndPassword(_email, _password);
        //if (_signedUser != null)
        //print("Oturum açan user id:" + _signedUser.userId.toString());
      } on FirebaseAuthException catch (e) {}
    } else {
      try {
        UserModel _createdUser =
            await _userViewModel.createEmailAndPassword(_email, _password);
        //if (_createdUser != null)
        //print("Oturum açan user id:" + _createdUser.userId.toString());
      } on FirebaseAuthException catch (e) {
        return PlatformAlertDialog(
                title: "Kullanıcı oluşturma hatası",
                content:Errors.showError(e.code),
                buttonText: "Tamam")
            .show(context);
      }
    }
  }

  void _change() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LogIn
        ? AppLocalizations.of(context).translate("login_text")
        : AppLocalizations.of(context).translate("sign_up_text");
    _linkText = _formType == FormType.LogIn
        ? AppLocalizations.of(context).translate("account_question_sign_in")
        : AppLocalizations.of(context).translate("account_question_login");

    final _userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel.user != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: _userViewModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
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
                      TextFormField(
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
                        buttonHeight: 45,
                        buttonTextSize: 16,
                        buttonRadius: 15,
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => _change(),
                        child: Text(_linkText),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
