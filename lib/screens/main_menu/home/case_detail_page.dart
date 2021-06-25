import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/comment_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/common_widget/photo_detail.dart';
import 'package:consultation_app/screens/main_menu/home/comment_detail.dart';
import 'package:consultation_app/screens/main_menu/profile/other_users_profile.dart';
import 'package:consultation_app/view_model/comment_view_model.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';

class CaseDetailPage extends StatefulWidget {
  final CaseModel caseModel;

  CaseDetailPage({this.caseModel});

  @override
  _CaseDetailPageState createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;
  var _commentController = TextEditingController();
  bool currentUserFav = false;
  bool currentUserUnFav = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    final _commentModel = Provider.of<CommentViewModel>(context, listen: false);

    var _case = widget.caseModel;
    UserModel _caseOwner = UserModel.fromMap(widget.caseModel.caseOwner);
    int caseScore = _case.favList.length - _case.unFavList.length;

    for (var i in _case.favList) {
      if (i == _userModel.user.userId) {
        setState(() {
          currentUserFav = true;
          currentUserUnFav = false;
        });
      }
    }
    for (var i in _case.unFavList) {
      if (i == _userModel.user.userId) {
        setState(() {
          currentUserFav = false;
          currentUserUnFav = true;
        });
      }
    }

    Future<void> favCase() async {
      if (currentUserUnFav == true) {
        await _firestoreDB
            .collection("vakalar")
            .doc(_case.caseTag)
            .collection(_case.caseTag + "_vakalari")
            .doc(_case.caseId)
            .update({
          "un_fav_list": FieldValue.arrayRemove([_userModel.user.userId])
        });
      }

      await _firestoreDB
          .collection("vakalar")
          .doc(_case.caseTag)
          .collection(_case.caseTag + "_vakalari")
          .doc(_case.caseId)
          .update({
        "fav_list": FieldValue.arrayUnion([_userModel.user.userId])
      });
    }

    Future<void> unFavCase() async {
      if (currentUserFav == true) {
        await _firestoreDB
            .collection("vakalar")
            .doc(_case.caseTag)
            .collection(_case.caseTag + "_vakalari")
            .doc(_case.caseId)
            .update({
          "fav_list": FieldValue.arrayRemove([_userModel.user.userId])
        });
      }
      await _firestoreDB
          .collection("vakalar")
          .doc(_case.caseTag)
          .collection(_case.caseTag + "_vakalari")
          .doc(_case.caseId)
          .update({
        "un_fav_list": FieldValue.arrayUnion([_userModel.user.userId])
      });
    }

    return Scaffold(
      body: FooterLayout(
        footer: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 0.5,
              color: Colors.grey,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5),
                  width: MediaQuery.of(context).size.width * 0.08,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (Platform.isIOS) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => CommentDetail(),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => CommentDetail(),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.launch),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(18, 0, 8, 10),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.76,
                  child: TextFormField(
                    controller: _commentController,
                    maxLength: 240,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Type a comment.",
                      contentPadding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_commentController.text.length < 1) {
                          print("NABIYON YA");
                        } else {
                          var _comment = _saveComment();
                          await _commentModel.saveComment(
                              _comment, _case, _userModel.user.userId);
                          _commentController.clear();
                        }
                      } catch (e) {
                        print("HATAAAAAAAAAA " + e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0.1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.send, size: 18),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        child: CustomScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            backgroundImage:
                                NetworkImage(_caseOwner.profileURL),
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
                                  onPressed: () async {
                                    if (currentUserFav == true) {
                                      return null;
                                    } else {
                                      await favCase();
                                      setState(() {
                                        currentUserUnFav = false;
                                        currentUserFav = true;
                                        caseScore++;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.keyboard_arrow_up),
                                  splashRadius: 15,
                                  color: currentUserFav == true &&
                                          currentUserUnFav == false
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                ),
                                Text(
                                  caseScore.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (currentUserUnFav == true) {
                                      return null;
                                    } else {
                                      await unFavCase();
                                      setState(() {
                                        currentUserFav = false;
                                        currentUserUnFav = true;
                                        caseScore--;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  splashRadius: 15,
                                  color: currentUserFav == false &&
                                          currentUserUnFav == true
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
                            ),
                            SizedBox(width: 5),
                            Container(
                              height: 24,
                              child: VerticalDivider(thickness: 1),
                            ),
                            Container(
                                child: _case.caseSolve == true
                                    ? Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Text("Solved"),
                                          SizedBox(width: 5),
                                          Icon(Icons.verified_outlined,
                                              size: 15,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ],
                                      )
                                    : null),
                            Container(
                              height: 24,
                              child: _caseOwner.userId == _userModel.user.userId ? VerticalDivider(thickness: 1):null,
                            ),
                            Container(
                                child:
                                    _caseOwner.userId == _userModel.user.userId
                                        ? InkWell(
                                            onTap: () {},
                                            child: Icon(Icons.delete, size: 16, color: Colors.grey.shade600),
                                          )
                                        : null),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 5, 18, 0),
                          child: Text(_case.caseBody,
                              textAlign: TextAlign.justify,
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
                                                    PhotoDetail(
                                                        imgPath: item))),
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
                        ),
                        Divider(thickness: 1, indent: 15, endIndent: 15),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
                          child: Text(
                            "Comments",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          height: 300,
                          //comment liste uzunluğu alınıp belli bir değerle çarpılabilir
                          child: StreamBuilder<List<CommentModel>>(
                            stream: _commentModel.getComments(_case),
                            builder: (context, streamComment) {
                              if (!streamComment.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                var allComments = streamComment.data;
                                return ListView.builder(
                                  itemCount: allComments.length,
                                  itemBuilder: (context, index) {
                                    var owner = allComments[index].commentOwner;
                                    UserModel commentOwner =
                                        UserModel.fromMap(owner);
                                    return Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 8),
                                      child: Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                commentOwner.profileURL),
                                          ),
                                          title: RichText(
                                            text: TextSpan(
                                              text: commentOwner.nameSurname +
                                                  "\n",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                              children: [
                                                TextSpan(
                                                  text: allComments[index]
                                                      .commentText,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  child: Icon(
                                                    Icons.keyboard_arrow_up,
                                                    size: 22,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 22,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: commentOwner.userId ==
                                                  _userModel.user.userId
                                              ? InkWell(
                                                  onTap: () async {
                                                    await _commentModel
                                                        .deleteComment(
                                                            allComments[index]
                                                                .commentId,
                                                            _case,
                                                            _userModel
                                                                .user.userId);
                                                    final snackBar = SnackBar(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      elevation: 0,
                                                      duration: Duration(
                                                          milliseconds: 1500),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content: Text(
                                                        "Yorumunuz silindi",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 16,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CommentModel _saveComment() {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);

    String commentText = _commentController.text;

    CommentModel _comment = CommentModel(
        commentOwner: _userModel.user.toMap(), commentText: commentText);
    return _comment;
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
