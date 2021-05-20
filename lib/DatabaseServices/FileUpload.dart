import 'package:firebase_storage/firebase_storage.dart';

class FileUpload {
  uploadPic(
    _image1,
    _userId,
  ) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    var url;
    Reference ref = storage.ref().child(_userId);
    TaskSnapshot uploadTask = await ref.putFile(_image1);
    url = await uploadTask.ref.getDownloadURL();
    return url;
  }
}
