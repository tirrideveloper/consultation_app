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
  String casePhotoURL1;
  String casePhotoURL2;
  String casePhotoURL3;

  CaseModel(this.caseId, this.caseTitle, this.caseBody, this.caseOwnerId,
      this.caseOwnerName, this.caseOwnerTitle, this.caseDate);

  Map<String, dynamic> toMap() {
    return {
      "case_id": caseId,
      "case_title": caseTitle,
      "case_body": caseBody,
      "case_ownerID": caseOwnerId,
      "case_owner_name": caseOwnerName,
      "case_owner_title": caseOwnerTitle,
      "case_date": FieldValue.serverTimestamp(),
      "case_solve": caseSolve,
      "case_photoURL1": casePhotoURL1,
      "case_photoURL2": casePhotoURL2,
      "case_photoURL3": casePhotoURL3
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
        casePhotoURL1 = map["case_photoURL1"],
        casePhotoURL2 = map["case_photoURL2"],
        casePhotoURL3 = map["case_photoURL3"];

  @override
  String toString() {
    return 'CaseModel{caseId: $caseId, caseTitle: $caseTitle, caseBody: $caseBody, caseOwnerId: $caseOwnerId, caseOwnerName: $caseOwnerName, caseOwnerTitle: $caseOwnerTitle, caseDate: $caseDate, caseSolve: $caseSolve, casePhotoURL1: $casePhotoURL1, casePhotoURL2: $casePhotoURL2, casePhotoURL3: $casePhotoURL3}';
  }
}
