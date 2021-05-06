import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/screens/main_menu/profile/numbers_widget.dart';
import 'package:consultation_app/models/tablet_detector.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_image_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("tab_item_profile")),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath:
                  "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80",
              onClicked: () {},
            ),
            const SizedBox(height: 24),
            buildName(),
            const SizedBox(height: 24),
            Center(
              child: Container(
                height: 45,
                width: 200,
                child: ElevatedButton(
                  onPressed: () => _signOut(context),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          TabletDetector.isTablet() != true ? 30 : 30 * 2),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).translate("tab_item_settings"),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            NumbersWidget(),
            const SizedBox(height: 48),
            buildAbout(),
          ],
        ),
      ),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            "nurullah",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "gunes",
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate("profile_about"),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "hakkkında",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}

Future<bool> _signOut(BuildContext context) async {
  final _userModel = Provider.of<UserViewModel>(context, listen: false);
  bool result = await _userModel.signOut();
  return result;
}
