import 'package:chattie/AuthServices/AuthenticationService.dart';
import 'package:chattie/DataModels/UserData.dart';
import 'package:chattie/DatabaseServices/UserLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final userID = context.read<User>();
    final user = context.read<UserData>();
    UserLogin(uid: userID.uid).getUserData(user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
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
