import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> getUserData(UserData data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      data.setName = value.data()['name'];
      data.setPhoneNo = value.data()['phoneNo'];
      data.setImageUrl = value.data()['imageUrl'];
      data.setOnline = value.data()['online'];
      data.setUid = value.data()['uid'];
      data.setList = value.data()['chats_list'];
    });
  }
}
