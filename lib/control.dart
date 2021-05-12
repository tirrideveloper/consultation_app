import 'package:consultation_app/models/user_view_model.dart';
import 'package:consultation_app/screens/main_menu/main_page.dart';
import 'package:consultation_app/screens/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.state == ViewState.Idle) {
      if (_userViewModel.user == null) {
        return SignInPage();
      } else {
        return MainPage(user: _userViewModel.user);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
