import 'package:consultation_app/screens/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Alanında uzman hekimler burada",
              body:
              "Doktorlarımızın konsultasyon çalışmalarını kolaylaştırıyoruz",
              image: buildImage("assets/images/doktor.jpg"),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "Zorlu süreçlerde riski azaltıyoruz",
              body: "Mekandan bağımsız bir vaka çalışması sunuyoruz",
              image: buildImage("assets/images/hastahane.png"),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "Tıp öğrencilerinin yanındayız",
              body:

              "Zorlu okul sürecinde bilinçli ve verimli vakalar gösteriyoruz",
              image: buildImage("assets/images/öğrenci.jpg"),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "Haydi başlayalım",
              body: "",
              image:  buildImage("assets/images/docpat.jpg"),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text("Done"),
          onDone: () => goToSignInPage(context),
          showSkipButton: true,
          skip: Text("Skip"),
          next: Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          animationDuration: 1000,
        ),
      );

  Widget buildImage(String path) => Center(
        child: Image.asset(path, width: 350),
      );

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xffbdbdbd),
        activeColor: Colors.deepOrange,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );

  void goToSignInPage(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SignInPage()),
      );
}
