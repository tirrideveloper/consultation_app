import 'dart:io';

import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({Key key}) : super(key: key);

  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  File file;

  @override
  Widget build(BuildContext context) {
    String fileName = file != null ? basename(file.path) : "dosya seçilmedi";

    UserViewModel _viewModel =
        Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanıcı Onayla"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Merhaba Sn. " + _viewModel.user.nameSurname,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "\nBuraya kullanıcı mezuniyet belgesi yüklesin diye yazı yazcaz."),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BasicButton(
                    buttonText: "Dosya seç",
                    buttonColor: Theme.of(context).primaryColor,
                    buttonTextColor: Colors.white,
                    buttonRadius: 10,
                    buttonIcon: Icon(Icons.attach_file),
                    buttonOnPressed: () => selectFile(),
                  ),
                  SizedBox(height: 5),
                  Text(
                    fileName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 35),
                  BasicButton(
                    buttonText: "Dosya yükle",
                    buttonColor: Theme.of(context).primaryColor,
                    buttonTextColor: Colors.white,
                    buttonIcon: Icon(Icons.upload_file),
                    buttonRadius: 10,
                    buttonOnPressed: () async {
                      try{
                        final fileName = basename(file.path);
                        await _viewModel.uploadVerifyFile(
                            _viewModel.user.userId, file, fileName);
                        final snackBar = SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            AppLocalizations.of(context).translate("successful_update"),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: AppLocalizations.of(context).translate("okay_text"),
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      catch(e){
                        final snackBar = SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            AppLocalizations.of(context).translate("error_occurred_text"),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: AppLocalizations.of(context).translate("okay_text"),
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      finally{
                       setState(() {
                         file = null;
                         fileName = null;
                       });
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["doc", "docx", "pdf"]);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
    });
  }
}
