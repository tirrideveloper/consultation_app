import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/screens/main_menu/home/add_image.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/case_view_model.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewCase extends StatefulWidget {
  @override
  _AddNewCaseState createState() => _AddNewCaseState();
}

class _AddNewCaseState extends State<AddNewCase> {
  TextEditingController _controllerTitle, _controllerContent;

  @override
  void initState() {
    super.initState();
    _controllerTitle = TextEditingController();
    _controllerContent = TextEditingController();
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerContent.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    if (_controllerTitle.text.isNotEmpty ||
        _controllerContent.text.isNotEmpty) {
      _selectedTag = "";
      return showDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: AppLocalizations.of(context).translate("cancel_case"),
          buttonText: AppLocalizations.of(context).translate("okay_text"),
          button2Text: AppLocalizations.of(context).translate("cancel_text"),
        ),
      );
    } else {
      _selectedTag = "";
      Navigator.of(context).pop();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("new_case_txt")),
          actions: [addCasePhoto(context)],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: Column(
              children: [
                DropDownField(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  controller: _tagController,
                  hintText:
                      AppLocalizations.of(context).translate("select_tag"),
                  enabled: true,
                  items: vakaTagi,
                  itemsVisibleInDropdown: 5,
                  onValueChanged: (value) {
                    setState(() {
                      _selectedTag = value;
                      FocusScope.of(context).unfocus();
                      //_tagController.clear();
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _selectedTag != ""
                    ? Row(
                        children: [
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(_selectedTag),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedTag = "";
                                        _tagController.clear();
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      size: 18,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(height: 0),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _controllerTitle,
                        maxLength: 50,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate("title_txt"),
                          contentPadding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                          //suffixIcon: Icon(Icons.arrow_downward)
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        maxLines: 10,
                        maxLength: 1000,
                        controller: _controllerContent,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate("content_txt"),
                          contentPadding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                          //suffixIcon: Icon(Icons.arrow_downward)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton addCasePhoto(BuildContext context) {
    return TextButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (_controllerTitle.text.trim().length > 0 &&
            _controllerContent.text.trim().length > 0) {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => AddImage(
                caseModel: _saveCase(),
              ),
            ),
          );
        } else {
          final snackBar = SnackBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 0,
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            content: Text(
              AppLocalizations.of(context).translate("empty_title_content"),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).translate("add_image_save"),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward,
            size: 17,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  CaseModel _saveCase() {
    final _caseModel = Provider.of<CaseViewModel>(context, listen: false);

    if (_selectedTag == "") _selectedTag = "diger";

    String titleId = _controllerTitle.text.replaceAll(RegExp(r"\s+"), "");
    String userId = _caseModel.currentUser.userId;
    String caseId = userId + "-" + titleId;
    String caseTitle = _controllerTitle.text;
    String caseBody = _controllerContent.text;

    CaseModel _case = CaseModel(
        caseId: caseId,
        caseTitle: caseTitle,
        caseBody: caseBody,
        caseOwner: _caseModel.currentUser.toMap(),
        caseTag: _selectedTag);
    return _case;
  }
}

String _selectedTag = "";

final _tagController = TextEditingController();

List<String> vakaTagi = [
  "agiz-dis",
  "beyin-sinir",
  "paediatric",
  "diger",
  "genel-cerrahi",
  "gogus-cerrahi",
  "goz-hastaklıkları",
  "kadın-hastalıkları",
  "kalp-damar",
  "kulak-burun-bogaz",
  "ortopedi",
  "plastik-estetik",
  "uroloji"
];
