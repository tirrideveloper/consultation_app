import 'dart:io';

import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/view_model/case_view_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AddImage extends StatefulWidget {
  final CaseModel caseModel;

  AddImage({this.caseModel});

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  List<File> _images = [];
  final picker = ImagePicker();
  List<String> _casePhotoURLs = [];

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _images.add(File(pickedFile.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) return;

    if (response.file != null) {
      setState(() {
        _images.add(File(response.file.path));
      });
    } else
      print(response.file);
  }

  @override
  Widget build(BuildContext context) {
    CaseViewModel _caseViewModel =
        Provider.of<CaseViewModel>(context, listen: false);
    UserViewModel _userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    var _case = widget.caseModel;

    _uploadCase() async {
      for (var casePhoto in _images) {
        final fileName = basename(casePhoto.path);
        var casePhotoURL = await _caseViewModel.uploadCasePhoto(
            _case.caseId, fileName, casePhoto);
        _casePhotoURLs.add(casePhotoURL);
      }
      _case.casePhotos = _casePhotoURLs;

      var result = await _caseViewModel.saveCase(_case);

      var result2 = await _caseViewModel.updateUserCases(
          _userViewModel.user.userId, _case.caseId);

      if (result == true && result2 == true) {
        final snackBar = SnackBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 0,
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Vaka başarıyla kaydedildi. Ana sayfaya dönülüyor.",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        final snackBar = SnackBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 0,
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Bir hata oluştu lütfen tekrar deneyin",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Foto ekle ve vakayı paylaş"),
        actions: [
          TextButton(
            onPressed: () => _uploadCase(),
            child: Text(
              "Kaydet",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: _images.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return index == 0
              ? Center(
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      chooseImage();
                    },
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(_images[index - 1]),
                        fit: BoxFit.cover),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index - 1);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.close,
                              color: Colors.blueGrey, size: 20),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
