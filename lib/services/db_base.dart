import 'package:consultation_app/models/chats_model.dart';
import 'package:consultation_app/models/message_model.dart';
import 'package:consultation_app/models/user_model.dart';

abstract class DbBase {
  Future<bool> saveUser(UserModel userModel);

  Future<UserModel> readUser(String userId);

  Future<bool> updateUserName(String userId, String userName);

  Future<bool> updateUser(String userId, String nameSurname, String aboutUser);

  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl);

  Future<bool> updateVerifyFile(String userId, String verifyFileUrl);

  Stream<List<Message>> getMessages(String currentUserId, String otherUserId);

  Future<bool> saveMessage(Message message);

  Future<List<Chats>> getAllConversations(String userId);

  Future<DateTime> showTime(String userId);
}
