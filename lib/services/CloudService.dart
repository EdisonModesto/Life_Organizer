import 'package:firebase_storage/firebase_storage.dart';

class CloudService{
  Future<String> uploadFile(filename, file) async {
    // Upload file to cloud
    var ref = await FirebaseStorage.instance.ref("images/$filename").putFile(file);
    // Get url of uploaded file
    return await ref.ref.getDownloadURL();
  }
}