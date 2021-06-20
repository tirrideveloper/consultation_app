import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentModel {
  String commentId;
  String commentText;
  Map commentOwner;
  Timestamp commentDate;
  List commentPhotos;
  List favList;
  List unFavList;

  CommentModel(
      {@required this.commentOwner, this.commentText, this.commentDate});

  Map<String, dynamic> toMap() {
    return {
      "comment_text": commentText,
      "comment_owner": commentOwner,
      "comment_date": commentDate ?? FieldValue.serverTimestamp(),
      "comment_photos": commentPhotos ?? [],
      "fav_list": favList ?? [],
      "un_fav_list": unFavList ?? [],
      "comment_id": commentId
    };
  }

  CommentModel.fromMap(Map<String, dynamic> map)
      : commentText = map["comment_text"],
        commentOwner = map["comment_owner"],
        commentDate = map["comment_date"],
        commentPhotos = map["comment_photos"],
        favList = map["fav_list"],
        unFavList = map["un_fav_list"],
        commentId = map["comment_id"];
}
