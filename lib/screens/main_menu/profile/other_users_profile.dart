import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/chat_view_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:consultation_app/screens/main_menu/messaging/messaging_page.dart';
import 'package:consultation_app/screens/main_menu/profile/numbers_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_image_widget.dart';

class OtherUserProfile extends StatefulWidget {
  final UserModel otherUser;

  OtherUserProfile({this.otherUser});

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    var user = widget.otherUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.nameSurname),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: user.profileURL,
              isEdit: user.userId == _viewModel.user.userId ? false : true,
              onClicked: user.userId == _viewModel.user.userId
                  ? null
                  : _goMessagingScreen,
            ),
            const SizedBox(height: 24),
            buildName(user.nameSurname, user.userName, user.verifiedUser),
            const SizedBox(height: 15),
            NumbersWidget(
              userRank: user.rank.toString(),
              userCase: user.userCases.length.toString(),
              userComment: "0",
            ),
            SizedBox(height: 24),
            buildAbout(user.aboutUser, user.userProfession),
          ],
        ),
      ),
    );
  }

  Widget buildName(String nameSurname, userName, bool verify) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nameSurname,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            verify == true
                ? Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.verified,
                        color: Theme.of(context).primaryColor),
                  )
                : SizedBox(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildAbout(String aboutUser, String profession) {
    if (profession == "") {
      profession = "Belirtilmemiş";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).translate("profile_about"),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text("Uzmanlık Alanı: " + profession,
              style: TextStyle(fontSize: 16, height: 1.4)),
          SizedBox(height: 10),
          Text(
            aboutUser,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }

  void _goMessagingScreen() {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ChatViewModel(
              currentUser: _viewModel.user, otherUser: widget.otherUser),
          child: MessagingPage(),
        ),
      ),
    );
  }
}
