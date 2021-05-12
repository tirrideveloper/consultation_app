import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/screens/main_menu/profile/numbers_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'profile_image_widget.dart';

// ignore: must_be_immutable
class OtherUserProfile extends StatefulWidget {

  Map otherUser;
  OtherUserProfile({this.otherUser});

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("tab_item_profile")),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(imagePath: widget.otherUser["profileURL"], isEdit: true,),
            const SizedBox(height: 24),
            buildName(widget.otherUser["nameSurname"], widget.otherUser["userName"]),
            const SizedBox(height: 15),
            NumbersWidget(),
            const SizedBox(height: 24),
            buildAbout(widget.otherUser["aboutUser"]),
          ],
        ),
      ),
    );
  }

  Widget buildName(String nameSurname, userName) {
    return Column(
      children: [
        Text(
          nameSurname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildAbout(String aboutUser) {
    return Container(
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
            aboutUser,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }
}
