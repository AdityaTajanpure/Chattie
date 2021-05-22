import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattie/DataModels/UserData.dart';
import 'package:chattie/DatabaseServices/UserLogin.dart';
import 'package:chattie/Screens/ChatScreen/Widget/MyMessage.dart';
import 'package:chattie/Screens/ChatScreen/Widget/YourMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final chatID, index;

  const ChatScreen({Key key, this.chatID, this.index}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String msg;
  int length = 0;
  ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();

  scrollToEnd() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<User>();
    final userData = context.read<UserData>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.chatID['image']),
                    fit: BoxFit.contain),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.chatID['name'],
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              Icon(Icons.menu, color: Colors.black)
            ],
          ),
          elevation: 1,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: UserLogin().getChatData(widget.chatID['chat_id']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              scrollToEnd();
              length = snapshot.data.data()['chat'].length;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: length + 1,
                      itemBuilder: (context, index) {
                        if (index == length) {
                          return SizedBox(
                            height: 80,
                          );
                        } else {
                          var data = snapshot.data.data()['chat'];
                          var msg = data[index]['msg'].split(':');
                          if (msg[-1] == user.uid)
                            return MyMessage(
                              data: msg[0],
                              time: data[index]['time'],
                            );
                          else
                            return YourMessage(
                              data: msg[0],
                              time: data[index]['time'],
                            );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    left: 25,
                    bottom: 20,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(2, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 18),
                        decoration: new InputDecoration(
                          hintText: "Enter Message",
                          border: OutlineInputBorder(),
                          suffix: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: IconButton(
                              onPressed: () {
                                var time;
                                var now = new DateTime.now();
                                var date = new DateFormat("H:mm").format(now);
                                msg = msg + ":" + user.uid;
                                if (int.parse(date.split(':')[0]) >= 12) {
                                  time = date + " PM";
                                } else {
                                  time = date + " AM";
                                }
                                _textController.text = "";
                                UserLogin(uid: user.uid).sendMsg(
                                    widget.chatID['chat_id'],
                                    msg,
                                    time,
                                    snapshot.data.data()['id1'],
                                    snapshot.data.data()['id2'],
                                    userData.getList,
                                    widget.index);
                              },
                              icon: Icon(
                                Icons.send_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        onChanged: (value) => this.msg = value,

                        // Only numbers can be entered
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
