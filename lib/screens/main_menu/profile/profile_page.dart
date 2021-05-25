import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/screens/main_menu/profile/numbers_widget.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
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
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).translate("update_information_text"),
            ),
            content: Text(
              AppLocalizations.of(context)
                  .translate("profile_photo_update_text"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _viewModel.uploadFile(
                      _viewModel.user.userId, "profile_photo", _profilePhoto);
                  Navigator.of(context2).pop();
                },
                child:
                    Text(AppLocalizations.of(context).translate("okay_text")),
              ),
              TextButton(
                onPressed: () {
                  _profilePhoto = null;
                  Navigator.of(context2).pop();
                },
                child:
                    Text(AppLocalizations.of(context).translate("cancel_text")),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(_viewModel.user.nameSurname),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
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
                                title: Text(AppLocalizations.of(context)
                                    .translate("take_photo_text")),
                                onTap: () {
                                  _takePhoto();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text(AppLocalizations.of(context)
                                    .translate("from_gallery_text")),
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
              buildName(_viewModel.user.nameSurname, _viewModel.user.userName,
                  _viewModel.user.verifiedUser),
              const SizedBox(height: 15),
              NumbersWidget(
                userRank: _viewModel.user.rank.toString(),
                userCase: _viewModel.user.userCases.length.toString(),
                userComment: "0",
              ),
              const SizedBox(height: 24),
              buildAbout(
                  _viewModel.user.aboutUser, _viewModel.user.userProfession),
            ],
          ),
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

  Future<Null> _refreshPage() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
