import 'package:consultation_app/models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => _signOut(context),
            child: Text("Cikis",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
      body: Center(
        child: Text("Profil Sayfasi"),
      ),
    );
  }
}

Future<bool> _signOut(BuildContext context) async {
  final _userModel = Provider.of<UserViewModel>(context, listen: false);
  bool result = await _userModel.signOut();
  return result;
}
