import 'ChatsList.dart';

class UserData {
  String name, phoneNo;
  String imageUrl;
  String about;
  String uid;
  bool online;
  List<ChatsList> chats_list;

  UserData(this.name, this.phoneNo, this.imageUrl, this.about, this.uid,
      this.online);
}
