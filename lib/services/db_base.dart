import 'package:consultation_app/models/user_model.dart';

abstract class DbBase {
  Future<bool> saveUser(UserModel userModel);

  Future<UserModel> readUser(String userId);

  Future<bool> updateUserName(String userId, String userName);

  Future<bool> updateUser(String userId, String nameSurname, String aboutUser);

  Future<bool>updateProfilePhoto(String userId, String profilePhotoUrl);
}
