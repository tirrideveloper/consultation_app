import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CaseModel {
  final String caseId;
  String caseTitle;
  final String caseBody;
  Map caseOwner;
  Timestamp caseDate;
  bool caseSolve;
  List casePhotos;
  String caseTag;
  List favList;
  List unFavList;

  CaseModel(
      {@required this.caseOwner,
      this.caseId,
      this.caseTitle,
      this.caseBody,
      this.caseDate,
      this.caseTag});

  Map<String, dynamic> toMap() {
    return {
      "case_id": caseId,
      "case_title": caseTitle,
      "case_body": caseBody,
      "case_owner": caseOwner,
      "case_date": caseDate ?? FieldValue.serverTimestamp(),
      "case_solve": caseSolve ?? false,
      "case_photos": casePhotos,
      "case_tag": caseTag,
      "fav_list": favList ?? [],
      "un_fav_list": unFavList ?? []
    };
  }

  CaseModel.fromMap(Map<String, dynamic> map)
      : caseId = map["case_id"],
        caseTitle = map["case_title"],
        caseBody = map["case_body"],
        caseOwner = map["caseOwner"],
        caseDate = map["case_date"],
        caseSolve = map["case_solve"],
        caseTag = map["case_tag"],
        casePhotos = map["case_photos"],
        favList = map["fav_list"],
        unFavList = map["un_fav_list"];

  @override
  String toString() {
    return 'CaseModel{caseOwner: $caseOwner}';
  }
}
