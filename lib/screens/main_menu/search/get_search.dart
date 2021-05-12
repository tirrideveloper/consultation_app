import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  Future getData(String collection) async {
    QuerySnapshot snapshot = await _firestoreDB.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return _firestoreDB
        .collection("users")
        .where("nameSurname", isGreaterThanOrEqualTo: queryString).get();
  }
}
