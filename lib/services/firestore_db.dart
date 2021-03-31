import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/db_base.dart';

class FireStoreDbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel userModel) async {
    await _firestore
        .collection("users")
        .doc(userModel.userId)
        .set(userModel.toMap());

    DocumentSnapshot _checkUser =
        await FirebaseFirestore.instance.doc("users/${userModel.userId}").get();

    Map _checkUserInformationMap = _checkUser.data();
    UserModel _checkedUserInformation =
        UserModel.fromMap(_checkUserInformationMap);
    print("checked user: " + _checkedUserInformation.toString());
    return true;
  }
}
