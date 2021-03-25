import 'package:consultation_app/screens/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "This application will be amazing",
              body: "Doctors will use this application everyday",
              image: null, //buildImage("assets/..."),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "This application will be amazing2",
              body: "Doctors will use this application everyday2",
              image: null, //buildImage("assets/..."),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "This application will be amazing3",
              body: "Doctors will use this application everyday3",
              image: null, //buildImage("assets/..."),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "This application will be amazing4",
              body: "Doctors will use this application everyday4",
              image: null, //buildImage("assets/..."),
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
        MaterialPageRoute(builder: (_) => SignUpPage()),
      );
}
