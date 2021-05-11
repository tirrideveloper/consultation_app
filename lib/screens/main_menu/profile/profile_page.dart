import 'package:consultation_app/models/app_localizations.dart';
import 'package:consultation_app/screens/main_menu/profile/numbers_widget.dart';
import 'package:consultation_app/models/tablet_detector.dart';
import 'package:consultation_app/models/user_view_model.dart';
import 'package:consultation_app/screens/main_menu/profile/profile_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'profile_image_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _profilePhoto;
  final _picker = ImagePicker();

  void _takePhoto() async {
    var image = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _profilePhoto = image.path;
      updateAlert(context);
      Navigator.of(context).pop();
    });
  }

  void _selectFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _profilePhoto = image.path;
      updateAlert(context);
      Navigator.of(context).pop();
    });
  }

  void updateAlert(BuildContext context) {
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text("Profil fotoğrafı"),
            content: Text("Güncellensin mi?"),
            actions: [
              TextButton(
                onPressed: () async {
                  await _viewModel.uploadFile(
                      _viewModel.user.userId, "profile_photo", _profilePhoto);
                  Navigator.of(context2).pop();
                },
                child: Text("Evet"),
              ),
              TextButton(
                onPressed: () {
                  _profilePhoto = null;
                  Navigator.of(context2).pop();
                },
                child: Text("Hayır"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("tab_item_profile")),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: _profilePhoto == null
                  ? _viewModel.user.profileURL
                  : _profilePhoto,
              onClicked: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 160,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text("Kamera ile çek"),
                              onTap: () {
                                _takePhoto();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text("Galeriden seç"),
                              onTap: () {
                                _selectFromGallery();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
            const SizedBox(height: 24),
            buildName(_viewModel.user.nameSurname, _viewModel.user.userName),
            const SizedBox(height: 15),
            Center(
              child: Container(
                height: 42,
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          TabletDetector.isTablet() != true ? 30 : 30 * 2),
                    ),
                  ),
                  child: Text(
                      AppLocalizations.of(context)
                          .translate("tab_item_settings"),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            NumbersWidget(),
            const SizedBox(height: 24),
            buildAbout(_viewModel.user.aboutUser),
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
/*Future _signOutConfirmation(BuildContext context) async {
    final result = await PlatformAlertDialog(
      title: "Çıkış Yap",
      content: "Emin misiniz?",
      buttonText: "Evet",
      button2Text: "Vazgeç",
    ).show(context);

    // ignore: unrelated_type_equality_checks
    if (result == true) {
      _signOut(context);
    }
  }

  Future<bool> _signOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }*/
}
