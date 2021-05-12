import 'package:consultation_app/models/user_model.dart';

abstract class AuthBase {
  Future<UserModel> currentUser();

  Future<bool> signOut();

  Future<UserModel> signInAnon();

  Future<UserModel> signInGoogle();

  Future<UserModel> signInFacebook();

  Future<UserModel> signInEmailAndPassword(String email, String password);

  Future<UserModel> createEmailAndPassword(String email, String password);
}
