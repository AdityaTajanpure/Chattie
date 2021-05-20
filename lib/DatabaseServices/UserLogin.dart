import 'package:cloud_firestore/cloud_firestore.dart';
import '../DataModels/UserData.dart';

class UserLogin {
  final String uid;
  UserLogin({this.uid});

  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(UserData data) async {
    await userReference.doc(uid).get().then((value) async {
      if (!value.exists) {
        return await userReference.doc(uid).set({
          'name': data.name,
          'phoneNo': data.phoneNo,
          'imageUrl': data.imageUrl,
          'uid': data.uid,
          'online': data.online,
          'chats_list': data.chatsList
        });
      }
    });
  }
}
