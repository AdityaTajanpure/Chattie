import 'package:cloud_firestore/cloud_firestore.dart';

class UserLogin {
  final String uid;
  UserLogin({this.uid});

  final userReference = FirebaseFirestore.instance.collection('users');

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

  Future<void> getUserData(user) async {
    await userReference.doc(uid).get().then((value) {
      user.setName = value.data()['name'];
      user.setPhoneNo = value.data()['phoneNo'];
      user.setImageUrl = value.data()['imageUrl'];
      user.setOnline = value.data()['online'];
      user.setUid = value.data()['uid'];
      user.setList = value.data()['chats_list'];
      user.setRequest = value.data()['request'];
    });
  }
}
