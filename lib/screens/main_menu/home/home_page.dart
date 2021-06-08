import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/common_widget/shimmer_effect.dart';
import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/screens/main_menu/home/add_new_case.dart';
import 'package:consultation_app/screens/main_menu/home/case_detail_page.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/all_case_view_model.dart';
import 'package:consultation_app/view_model/case_view_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listController);
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).translate("tab_item_home_page")),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.only(right: 7, bottom: 50),
          child: FloatingActionButton(
            onPressed: () async {
              if (_viewModel.user.verifiedUser) {
                _addNewCase();
              } else {
                PlatformAlertDialog(
                        title: AppLocalizations.of(context)
                            .translate("verification_error"),
                        content: AppLocalizations.of(context)
                            .translate("verify_account"),
                        buttonText:
                            AppLocalizations.of(context).translate("okay_text"))
                    .show(context);
              }
            },
            elevation: 2,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              "+\n" + AppLocalizations.of(context).translate("case_txt"),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        drawer: NavDrawer(),
        body: Consumer<AllCaseViewModel>(
          builder: (context, model, child) {
            if (model.state == AllCaseViewState.Busy) {
              return ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: ShimmerEffect.circular(width: 48, height: 48)),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerEffect.rectangular(height: 12, width: 80),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                ShimmerEffect.rectangular(height: 10, width: 130),
                                SizedBox(width: 10),
                                ShimmerEffect.rectangular(height: 10, width: 100),
                              ],
                            ),
                            SizedBox(height: 15)
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            ShimmerEffect.rectangular(height: 12),
                            SizedBox(height: 5),
                            ShimmerEffect.rectangular(height: 12)
                          ],
                        ),
                      ),
                    );
                  });
            } else if (model.state == AllCaseViewState.Loaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                  // ignore: unnecessary_statements
                  model.refresh;
                  await Future.delayed(Duration(seconds: 1));
                  return null;
                },
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (model.caseList.length == 0) {
                      return _noCaseWidget();
                    } else if (model.hasMoreLoading &&
                        index == model.caseList.length) {
                      return _newCaseLoadingIndicator();
                    } else {
                      return _createCase(index);
                    }
                  },
                  itemCount: model.hasMoreLoading
                      ? model.caseList.length + 1
                      : model.caseList.length,
                ),
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: AppLocalizations.of(context).translate("exit_app"),
        buttonText: AppLocalizations.of(context).translate("okay_text"),
        button2Text: AppLocalizations.of(context).translate("cancel_text"),
      ),
    );
  }

  void _addNewCase() {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    if (Platform.isAndroid) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => ChangeNotifierProvider(
            create: (context) => CaseViewModel(currentUser: _viewModel.user),
            child: AddNewCase(),
          ),
        ),
      );
    } else if (Platform.isIOS) {
      Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => ChangeNotifierProvider(
            create: (context) => CaseViewModel(currentUser: _viewModel.user),
            child: AddNewCase(),
          ),
        ),
      );
    }
  }

  _newCaseLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _listController() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getMoreCases();
    }
  }

  void getMoreCases() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _allCaseViewModel = Provider.of<AllCaseViewModel>(context);
      await _allCaseViewModel.getMoreCase();
      _isLoading = false;
    }
  }

  String _showTime(Timestamp date) {
    var _formatter = DateFormat.yMd();
    var _formatter2 = DateFormat.Hm();
    var _formattedDate = _formatter.format(date.toDate());
    var _formattedDate2 = _formatter2.format(date.toDate());
    String result = _formattedDate + "\t" + _formattedDate2;
    return result;
  }

  Widget _noCaseWidget() {
    final _allCaseView = Provider.of<AllCaseViewModel>(context);
    return RefreshIndicator(
      onRefresh: () async {
        // ignore: unnecessary_statements
        setState(() {});
        // ignore: unnecessary_statements
        _allCaseView.refresh;
        await Future.delayed(Duration(seconds: 1));
        return null;
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Case Yok",
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
    );
  }

  Widget _createCase(int index) {
    final _allCaseView = Provider.of<AllCaseViewModel>(context);
    final _userModel = Provider.of<UserViewModel>(context);
    var _snapCase = _allCaseView.caseList[index];
    UserModel caseOwner = UserModel.fromMap(_snapCase.caseOwner);
    String _title = _snapCase.caseTitle;
    if (_snapCase.caseTitle.length > 23) {
      _title = _snapCase.caseTitle
          .replaceRange(22, _snapCase.caseTitle.length, "...");
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => CaseViewModel(currentUser: _userModel.user),
              child: CaseDetailPage(
                caseModel: _snapCase,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Card(
          elevation: 0.7,
          child: ListTile(
            title: RichText(
              text: TextSpan(
                text: caseOwner.nameSurname + "\n",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                children: [
                  TextSpan(
                    text: _title + "\t • \t",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: _showTime(_snapCase.caseDate) + "\n",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            subtitle: Text(_snapCase.caseBody
                .replaceRange(80, _snapCase.caseBody.length, "...")),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(caseOwner.profileURL),
            ),
          ),
        ),
      ),
    );
  }
}
