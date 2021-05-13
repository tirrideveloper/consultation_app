import 'dart:io';

abstract class StorageBase {
  Future<String> uploadPhoto(String userId, String fileType, File fileToUpload);

  Future<String> uploadVerifyFile(
      String userId, File verifyFile, String fileName);
}
