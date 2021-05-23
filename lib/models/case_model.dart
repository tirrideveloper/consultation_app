import 'package:cloud_firestore/cloud_firestore.dart';

class CaseModel {
  final String caseId;
  final String caseTitle;
  final String caseBody;
  final String caseOwnerId;
  final String caseOwnerName;
  final String caseOwnerTitle;
  final Timestamp caseDate;
  bool caseSolve;
  List<String> casePhotos;
  String caseTag;

  CaseModel(
      {this.caseId,
      this.caseTitle,
      this.caseBody,
      this.caseOwnerId,
      this.caseOwnerName,
      this.caseOwnerTitle,
      this.caseDate,
      this.caseTag});

  Map<String, dynamic> toMap() {
    return {
      "case_id": caseId,
      "case_title": caseTitle,
      "case_body": caseBody,
      "case_ownerID": caseOwnerId,
      "case_owner_name": caseOwnerName,
      "case_owner_title": caseOwnerTitle,
      "case_date": caseDate ?? FieldValue.serverTimestamp(),
      "case_solve": caseSolve,
      "case_photos": casePhotos,
      "case_tag": caseTag,
    };
  }

  CaseModel.fromMap(Map<String, dynamic> map)
      : caseId = map["case_id"],
        caseTitle = map["case_title"],
        caseBody = map["case_body"],
        caseOwnerId = map["case_ownerID"],
        caseOwnerName = map["case_owner_name"],
        caseOwnerTitle = map["case_owner_title"],
        caseDate = map["case_date"],
        caseSolve = map["case_solve"],
        caseTag = map["case_tag"],
        casePhotos = map["case_photos"];

  @override
  String toString() {
    return 'CaseModel{caseId: $caseId, caseTitle: $caseTitle, caseBody: $caseBody, caseOwnerId: $caseOwnerId, caseOwnerName: $caseOwnerName, caseOwnerTitle: $caseOwnerTitle, caseDate: $caseDate, caseSolve: $caseSolve}';
  }
}
