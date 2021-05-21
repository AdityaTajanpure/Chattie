import 'package:chattie/AuthServices/AuthenticationService.dart';
import 'package:chattie/DataModels/UserData.dart';
import 'package:chattie/DatabaseServices/UserLogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;

  @override
  void initState() {
    user = context.read<User>();
    super.initState();
    getData();
  }

  getData() async {
    final userData = context.read<UserData>();
    await UserLogin(uid: user.uid).getUserData(userData);
    print(userData.getName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          user.uid,
        ),
      ),
    );
  }
}
