import 'package:cloud_firestore/cloud_firestore.dart';

class GetChat {
  final String chatID;

  GetChat(this.chatID);

  Future getChat() async {
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .get()
        .then((value) {});
  }
}
