import 'package:consultation_app/models/user_model.dart';

abstract class AuthBase {
  Future<UserModel> currentUser();

  Future<bool> signOut();

  Future<UserModel> signInAnon();

  Future<UserModel> signInGoogle();
//Future<UserModel> signInFacebook();
//Future<UserModel> signInPhone();
//Future<UserModel> signInMail();
}
