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
          'chats_list': [],
          'request': [],
          'about': ''
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
    await userReference.doc(uid).get().then((value) {});
  }

  getUser() {
    return userReference.doc(uid).snapshots();
  }

  acceptRequest(index, List request) {
    Map<String, dynamic> data = request.removeAt(index);
    return userReference.doc(uid).update({'request': request}).then((value) {
      userReference.doc(uid).update({
        'chats_list': FieldValue.arrayUnion([data])
      });
    });
  }

  sendRequest() {}

  cancelRequest() {}

  getChatData(chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots();
  }

  sendMsg(chatID, data, time, id1, id2, chatList, index) {
    return FirebaseFirestore.instance.collection('chats').doc(chatID).update({
      'chat': FieldValue.arrayUnion([
        {
          'msg': data,
          'time': time,
          'seen': false,
        }
      ])
    }).then((value) {
      chatList[index]['last_msg'] = data.split(":")[0];
      chatList[index]['time'] = time;
      userReference.doc(id2).update({
        'chats_list': chatList,
      });
    });
  }
}
