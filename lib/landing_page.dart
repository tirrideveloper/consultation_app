import 'package:consultation_app/screens/on_boarding/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'control.dart';

//Bu sınıf uygulamayı ilk açıldığında on boarding ekranını göstermek için var.
//Tek başına düzgün çalışıyor. Ancak kullanıcı girişini kontrol ettiğimiz zaman
//uygulamanın ilk açılışında sorunlu çalışıyor.
//Sonrasında main.dart'da controlPage yerine yazdığımızda ise düzgün çalışıyor.

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with AfterLayoutMixin {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => ControlPage()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
