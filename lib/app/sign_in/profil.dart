import 'package:consultation_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil"),actions: <Widget>[
        FlatButton(onPressed:()=> _cikisYap(context), child:Text("Cikis",
            style: TextStyle(color:Colors.white,fontSize: 18)
        ),
        )
      ],),
      body: Center(child: Text("Profil Sayfasi"),),
    )
    ;
  }
}

Future<bool> _cikisYap(BuildContext context) async{
  final _userModel = Provider.of<UserModel>(context);
  bool sonuc= await _userModel.signOut();
  return sonuc;
}
