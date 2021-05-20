class UserData {
  String name, phoneNo;
  String imageUrl;
  String about;
  String uid;
  bool online;
  List<String> chatsList;

  UserData(this.name, this.phoneNo, this.imageUrl, this.about, this.uid,
      this.online, this.chatsList);
}

class ChatsList {
  String chatId;
  int pendingMsgs;
  DateTime lastTime;
  ChatsList(this.chatId, this.pendingMsgs, this.lastTime);
}
