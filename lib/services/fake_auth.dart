import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userId = "123456789123456789";

  @override
  Future<UserModel> currentUser() async {
    return await Future.value((UserModel(userId: userId)));
  }

  @override
  Future<UserModel> signInAnon() async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userId: userId));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userId: userId));
  }

  @override
  Future<UserModel> signInFacebook() async{
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userId: userId));
  }
}
