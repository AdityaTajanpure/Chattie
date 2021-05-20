import 'package:cloud_firestore/cloud_firestore.dart';
import '../DataModels/UserData.dart';

class UserLogin {
  final String uid;
  UserLogin({this.uid});

  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String phoneNo, String imageUrl) async {
    await userReference.doc(uid).get().then((value) async {
      if (!value.exists) {
        return await userReference.doc(uid).set({
          'name': name,
          'phoneNo': phoneNo,
          'imageUrl': imageUrl,
          'uid': this.uid,
          'online': true,
          'chats_list': []
        });
      } else {
        return await userReference.doc(uid).update({
          'name': name,
          'phoneNo': phoneNo,
          'imageUrl': imageUrl,
          'online': true,
        });
      }
    });
  }
}
