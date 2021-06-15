import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/common_widget/photo_detail.dart';
import 'package:consultation_app/screens/main_menu/profile/other_users_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaseDetailPage extends StatefulWidget {
  final CaseModel caseModel;

  CaseDetailPage({this.caseModel});

  @override
  _CaseDetailPageState createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  bool _eksiOylama = false;
  bool _artiOylama = false;
  int _puan = 0;

  @override
  Widget build(BuildContext context) {
    var _case = widget.caseModel;
    UserModel _caseOwner = UserModel.fromMap(widget.caseModel.caseOwner);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            expandedHeight: 50,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_case.caseTitle),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => OtherUserProfile(
                                otherUser: _caseOwner,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(_caseOwner.profileURL),
                        ),
                        title: RichText(
                          text: TextSpan(
                            text: _caseOwner.nameSurname + "\n",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: "@" + _caseOwner.userName,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        trailing: Text(
                          _showTime(_case.caseDate),
                        ),
                      ),
                      Divider(thickness: 1, indent: 15, endIndent: 15),
                      Row(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_artiOylama == true &&
                                      _eksiOylama == false)
                                    return null;
                                  else if (_artiOylama == false &&
                                      _eksiOylama == false) {
                                    setState(() {
                                      _artiOylama = true;
                                      _eksiOylama = false;
                                      _puan++;
                                    });
                                  } else if (_artiOylama == false &&
                                      _eksiOylama == true) {
                                    setState(() {
                                      _artiOylama = true;
                                      _eksiOylama = false;
                                      _puan++;
                                    });
                                  }
                                },
                                icon: Icon(Icons.keyboard_arrow_up),
                                splashRadius: 15,
                                color:
                                    _artiOylama == true && _eksiOylama == false
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                              ),
                              Text(
                                _puan.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_artiOylama == false &&
                                      _eksiOylama == true)
                                    return null;
                                  else if (_artiOylama == false &&
                                      _eksiOylama == false) {
                                    setState(() {
                                      _artiOylama = false;
                                      _eksiOylama = true;
                                      _puan--;
                                    });
                                  } else if (_artiOylama == true &&
                                      _eksiOylama == false) {
                                    setState(() {
                                      _artiOylama = false;
                                      _eksiOylama = true;
                                      _puan--;
                                    });
                                  }
                                },
                                icon: Icon(Icons.keyboard_arrow_down),
                                splashRadius: 15,
                                color:
                                    _artiOylama == false && _eksiOylama == true
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                              ),
                            ],
                          ),
                          Container(
                            height: 24,
                            child: VerticalDivider(thickness: 1),
                          ),
                          Text(
                            _case.caseTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 5, 18, 0),
                        child: Text(_case.caseBody,
                            style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 8),
                      Divider(thickness: 1, indent: 15, endIndent: 15),
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: GridView(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            childAspectRatio: 1 / 1.15,
                          ),
                          padding: EdgeInsets.all(10),
                          children: _case.casePhotos
                              .map(
                                (item) => Card(
                                  elevation: 0,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PhotoDetail(imgPath: item))),
                                      child: Hero(
                                        tag: item,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: NetworkImage(item),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _showTime(Timestamp date) {
    var _formatter = DateFormat.yMd();
    var _formatter2 = DateFormat.Hm();
    var _formattedDate = _formatter.format(date.toDate());
    var _formattedDate2 = _formatter2.format(date.toDate());
    String result = _formattedDate + "\t • \t" + _formattedDate2;
    return result;
  }
}
