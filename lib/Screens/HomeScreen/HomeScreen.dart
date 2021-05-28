import 'package:badges/badges.dart';
import 'package:chattie/DataModels/UserData.dart';
import 'package:chattie/DatabaseServices/UserLogin.dart';
import 'package:chattie/Screens/HomeScreen/Components/FourthScreen.dart';
import 'package:chattie/Screens/HomeScreen/Components/SecondScreen.dart';
import 'package:chattie/Screens/HomeScreen/Components/ThirdScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'Components/FirstScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  int _selectedIndex = 0;
  UserData userData;
  List<Widget> tabs;

  @override
  void initState() {
    userData = context.read<UserData>();
    user = context.read<User>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2), () => true),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return StreamBuilder(
                stream: UserLogin(uid: user.uid).getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    userData.setAllData = snapshot.data.data();
                    return Stack(
                      children: [
                        if (_selectedIndex == 0)
                          FirstScreen(chatsList: userData.getList),
                        if (_selectedIndex == 1)
                          SecondScreen(
                            chatRequests: userData.getRequest,
                            uid: user.uid,
                          ),
                        if (_selectedIndex == 2) ThirdScreen(),
                        if (_selectedIndex == 3) FourthScreen(),
                        Positioned(
                          left: 25,
                          bottom: 20,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      2, 5), // changes position of shadow
                                  //first paramerter of offset is left-right
                                  //second parameter is top to down
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.home,
                                      color: _selectedIndex == 0
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 0;
                                      });
                                    }),
                                IconButton(
                                    icon: (userData.getRequest.length) > 0
                                        ? Badge(
                                            badgeContent: Text(
                                              userData.getRequest.length
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            child: Icon(
                                              Icons
                                                  .notifications_active_outlined,
                                              color: _selectedIndex == 1
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          )
                                        : Icon(
                                            Icons.notifications_outlined,
                                            color: _selectedIndex == 1
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 1;
                                      });
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.people,
                                      color: _selectedIndex == 2
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 2;
                                      });
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.settings,
                                      color: _selectedIndex == 3
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 3;
                                      });
                                    }),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
        },
      ),
    );
  }
}
