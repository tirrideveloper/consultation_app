import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/common_widget/platform_alert_dialog.dart';
import 'package:consultation_app/common_widget/shimmer_effect.dart';
import 'package:consultation_app/common_widget/side_menu.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/screens/main_menu/home/add_new_case.dart';
import 'package:consultation_app/screens/main_menu/home/case_detail_page.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/all_case_view_model.dart';
import 'package:consultation_app/view_model/case_view_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:dropdownfield/dropdownfield.dart';
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
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  final _tagController = TextEditingController();
  String _selectedTag = "";
  List<CaseModel> _allSearchedCase = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listController);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<UserViewModel>(context, listen: false);
    final _caseViewModel = Provider.of<CaseViewModel>(context, listen: false);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Container(
                padding: EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                  },
                  child: Icon(Icons.search),
                ))
          ],
          title: _isSearching
              ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey.shade50),
                        border: InputBorder.none,
                        hintText: "Search case",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _isSearching = false;
                              _selectedTag = "";
                              _tagController.clear();
                            });
                          },
                          icon: Icon(Icons.clear),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : Text(
                  AppLocalizations.of(context).translate("tab_item_home_page"),
                ),
        ),
        floatingActionButton: _isSearching
            ? null
            : Container(
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
                              buttonText: AppLocalizations.of(context)
                                  .translate("okay_text"))
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
        body: _isSearching == false
            ? Consumer<AllCaseViewModel>(
                builder: (context, model, child) {
                  if (model.state == AllCaseViewState.Busy) {
                    return ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                  child: ShimmerEffect.circular(
                                      width: 48, height: 48)),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerEffect.rectangular(
                                      height: 12, width: 80),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      ShimmerEffect.rectangular(
                                          height: 10, width: 130),
                                      SizedBox(width: 10),
                                      ShimmerEffect.rectangular(
                                          height: 10, width: 100),
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
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: _searchController.text.length > 1
                      ? buildSearchContainer(_caseViewModel, _viewModel,
                          getSearchedData(_searchController.text))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4, top: 10),
                              child: Text(
                                "Search with tag",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 3),
                              child: DropDownField(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                                controller: _tagController,
                                hintText: "or select case tag",
                                enabled: true,
                                items: vakaTagi,
                                itemsVisibleInDropdown: 5,
                                onValueChanged: (value) {
                                  setState(
                                    () {
                                      _allSearchedCase.clear();
                                      _selectedTag = value;
                                      FocusScope.of(context).unfocus();
                                    },
                                  );
                                },
                              ),
                            ),
                            buildSearchContainer(
                                _caseViewModel,
                                _viewModel,
                                _caseViewModel
                                    .getTagSearchedCases(_selectedTag)),
                          ],
                        ),
                ),
              ),
      ),
    );
  }

  Container buildSearchContainer(CaseViewModel _caseViewModel,
      UserViewModel _viewModel, Future<List<CaseModel>> list) {
    return Container(
      height: 500,
      child: FutureBuilder<List<CaseModel>>(
        future: list,
        builder: (context, searchedList) {
          if (!searchedList.hasData) {
            return Container();
          } else {
            _allSearchedCase = searchedList.data;
            if (_allSearchedCase.length > 0) {
              return ListView.builder(
                itemCount: _allSearchedCase.length,
                itemBuilder: (context, index) {
                  var _searchedCase = _allSearchedCase[index];
                  UserModel _searchedCaseOwner =
                      UserModel.fromMap(_searchedCase.caseOwner);
                  String _title = _searchedCase.caseTitle;
                  if (_searchedCase.caseTitle.length > 23) {
                    _title = _searchedCase.caseTitle.replaceRange(
                        22, _searchedCase.caseTitle.length, "...");
                  }
                  return InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) =>
                                CaseViewModel(currentUser: _viewModel.user),
                            child: CaseDetailPage(
                              caseModel: _searchedCase,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Card(
                        elevation: 0.7,
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: _searchedCaseOwner.nameSurname + "\n",
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
                                  text:
                                      _showTime(_searchedCase.caseDate) + "\n",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(_searchedCase.caseBody.replaceRange(
                              80, _searchedCase.caseBody.length, "...")),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(_searchedCaseOwner.profileURL),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return _noCaseWidget();
            }
          }
        },
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

  Future<List<CaseModel>> getSearchedData(String queryString) async {
    final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;
    QuerySnapshot _querySnapshot;
    List<CaseModel> _allCases = [];
    List _tagCases = [];

    for (String tag in vakaTagi) {
      _querySnapshot = await _firestoreDB
          .collection("vakalar")
          .doc(tag)
          .collection(tag + "_vakalari")
          .where("case_title", isEqualTo: queryString)
          .get();
      _tagCases.add(_querySnapshot);
    }
    for (QuerySnapshot query in _tagCases) {
      for (DocumentSnapshot snap in query.docs) {
        CaseModel _case = CaseModel.fromMap(snap.data());

        String titleId = _case.caseTitle.replaceAll(RegExp(r"\s+"), "");
        String _caseOwnerId = _case.caseId;
        String ownerId = _caseOwnerId.replaceAll("-" + titleId, "");

        DocumentSnapshot _owner = await FirebaseFirestore.instance
            .collection("users")
            .doc(ownerId)
            .get();
        Map<String, dynamic> _ownerMap = _owner.data();

        _case.caseOwner = _ownerMap;

        _allCases.add(_case);
      }
    }
    return _allCases;
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
