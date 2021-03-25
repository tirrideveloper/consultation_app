import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel _firebaseUser(User user) {
    if (user == null) {
      return null;
    }
    return UserModel(userId: user.uid);
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      return _firebaseUser(user);
    } catch (e) {
      print("ERROR CURRENT USER " + e.toString());
      return null;
    }
  }

  @override
  Future<UserModel> signInAnon() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _firebaseUser(userCredential.user);
    } catch (e) {
      print("ERROR ANONYMOUSLY AUTH" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("ERROR SIGN OUT" + e.toString());
      return false;
    }
  }
}
