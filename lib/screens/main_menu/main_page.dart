import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {

  final UserModel user;

  MainPage({Key key, @required this.user})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

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



class MyHomePage  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyHomePage> {

  int secilenMenuItem=0;
  List<Widget> tumSayfalar;
  AnaSayfa sayfaAna;
  AramaSayfasi sayfaArama;
  @override
  void initState() {
    // TODO: implement initState
    sayfaAna=AnaSayfa();
    sayfaArama=AramaSayfasi();
    super.initState();
    tumSayfalar=[sayfaAna,sayfaArama];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:tumSayfalar[secilenMenuItem],
      bottomNavigationBar: bottomNavMenu(),


    );
  }

  Theme bottomNavMenu() {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.cyan,
        primaryColor: Colors.orangeAccent,
      ),
      child: BottomNavigationBar(items:<BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("Anasayfa"),backgroundColor: Colors.amber),
        BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("Ara"),backgroundColor: Colors.red),
        BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("Ekle"),backgroundColor: Colors.cyan),
      ],
        type: BottomNavigationBarType.fixed,
        currentIndex: secilenMenuItem,
        onTap: (index){
          setState(() {
            secilenMenuItem=index;
          });
        },
      ),
    );
  }
}
