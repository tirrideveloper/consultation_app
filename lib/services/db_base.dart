import 'package:consultation_app/models/user_model.dart';

abstract class DbBase {
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userId);
}
