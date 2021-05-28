import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

  acceptRequest(index, request, uid2, userData) {
    var uuid = Uuid();
    String chatId = uuid.v4().replaceAll("-", "");
    return userReference.doc(uid).update({
      'request': FieldValue.arrayRemove([request]),
    }).then((value) {
      request['time'] = '';
      request['last_msg'] = '';
      request['chat_id'] = chatId;
      userReference.doc(uid).update({
        'chats_list': FieldValue.arrayUnion([
          request,
        ])
      }).then((value) {
        FirebaseFirestore.instance.collection('chats').doc(chatId).set({
          'chat': [],
          'id1': uid,
          'id2': request['uid'],
        });
      }).then((value) {
        request['name'] = userData.getName;
        request['image'] = userData.getImageUrl;
        request['uid'] = userData.getUid;
        userReference.doc(uid2).update({
          'chats_list': FieldValue.arrayUnion([
            request,
          ])
        });
      });
    });
  }

  cancelRequest(index, request) {
    return userReference.doc(uid).update({
      'request': FieldValue.arrayRemove([request]),
    });
  }

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
      ]),
    }).then((value) {
      chatList[index]['last_msg'] = data.split(":")[0];
      chatList[index]['time'] = time;
    }).then((value) {
      userReference.doc(id1).update({
        'chats_list': chatList,
      });
    }).then((value) {
      userReference.doc(id2).get().then((value) {
        chatList = value.data()['chats_list'];
      }).then((value) {
        chatList.forEach(
          (el) => {
            if (el['chat_id'] == chatID)
              {
                el['last_msg'] = data.split(":")[0],
                el['time'] = time,
              },
          },
        );
        print(chatList);
        userReference.doc(id2).update({
          'chats_list': chatList,
        });
      });
    });
  }

  deleteMsg(chatID, index, chat) {
    chat.removeAt(index);
    FirebaseFirestore.instance.collection('chats').doc(chatID).update({
      'chat': chat,
    });
  }

  sendRequest(userData, id, context) {
    userReference
        .doc(id)
        .update({
          'request': [
            {
              'name': userData.getName,
              'image': userData.getImageUrl,
              'uid': userData.getUid,
            }
          ]
        })
        .onError((error, stackTrace) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("User ID Not Found")))
            })
        .then((value) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Friend Request Sent")))
            });
  }
}
