import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  String name = "";
  String phoneNo = "";
  String imageUrl = "";
  String about = "";
  String uid = "";
  bool online = false;
  List chatsList = [];
  List requests = [];

  String get getName => this.name;
  String get getPhoneNo => this.phoneNo;
  String get getImageUrl => this.imageUrl;
  String get getAbout => this.about;
  String get getUid => this.uid;
  bool get getOnline => this.online;
  List get getList => this.chatsList;
  List get getRequest => this.requests;

  set setName(value) => {
        this.name = value,
        notifyListeners(),
      };
  set setPhoneNo(value) => {
        this.phoneNo = value,
        notifyListeners(),
      };
  set setImageUrl(value) => {
        this.imageUrl = value,
        notifyListeners(),
      };
  set setAbout(value) => {
        this.about = value,
        notifyListeners(),
      };
  set setUid(value) => {
        this.uid = value,
        notifyListeners(),
      };
  set setOnline(value) => {
        this.online = value,
        notifyListeners(),
      };
  set setList(value) => {
        this.chatsList = value,
        notifyListeners(),
      };
  set setRequest(value) => {
        this.requests = value,
        notifyListeners(),
      };
}
