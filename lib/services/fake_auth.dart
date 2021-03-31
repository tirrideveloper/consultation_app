import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userId = "123456789123456789";

  @override
  Future<UserModel> currentUser() async {
    return await Future.value((UserModel(userId: userId, email: "fake@fake.com")));
  }

  @override
  Future<UserModel> signInAnon() async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userId: userId, email: "fake@anon.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInGoogle() async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserModel(userId: "google_user", email: "fake@google.com"));
  }

  @override
  Future<UserModel> signInFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userId: "facebook_user", email: "fake@facebook.com"));
  }

  @override
  Future<UserModel> createEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userId: "created_user", email: "fake@fake.com"));
  }

  @override
  Future<UserModel> signInEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userId: "signed_user", email: "fake@fake.com"));
  }
}
