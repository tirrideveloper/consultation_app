import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {

  final UserModel user;

  MainPage({Key key, @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signOut(context), child: Text("Sign out"),
        ),
      ),
    );
  }
}

Future<bool> _signOut(BuildContext context) async {
  final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
  bool result = await _userViewModel.signOut();
  return result;
}
